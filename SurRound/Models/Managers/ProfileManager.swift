//
//  ProfileManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/12.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileManager {
    
    private var dataFetcher: DataFetching
    private var notificationManager: NotificationManager
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
        self.notificationManager = NotificationManager()
    }
    
    // MARK: - Public Methods
    func updateAvatar(_ image: UIImage, uid: String, completion: @escaping (Error?) -> Void) {
        
        let storageManager = StorageManager()
        
        storageManager.uploadAvatar(image, userId: uid) { (url) in
            
            guard let url = url else { return }
            
            UIImageView.clearCache()
            
            let dict: [String: Any] = [SRUser.CodingKeys.avatar.rawValue: url.absoluteString]
            FirestoreDB.users.document(uid).setData(dict, merge: true) { (error) in
                guard error == nil else {
                    completion(error!)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func fetchUserList(uids: [String], completion: @escaping ([SRUser]) -> Void) {
        
        let query = FirestoreDB.users.whereField(SRUser.CodingKeys.uid.rawValue, in: uids)
        
        dataFetcher.fetch(from: query) { result in
            switch result {
            case .success(let documents):
                guard let users = GenericParser.parse(documents, of: SRUser.self) else {
                    completion([])
                    return
                }
                completion(users)
                
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func fetchProfile(user uid: String, completion: @escaping (SRUserProfile?) -> Void) {
        
        let docRef = FirestoreDB.users.document(uid)
        let userPostRef = FirestoreDB.userPosts(userId: uid)
        let userStoryRef = FirestoreDB.userStories(userId: uid)
        
        dataFetcher.fetch(from: docRef) { [weak self] result in
            switch result {
            case .success(let document):
                guard let userProfile = GenericParser.parse(document, of: SRUserProfile.self) else {
                    completion(nil)
                    return
                }
                let group = DispatchGroup()
                
                group.enter()
                self?.fetchSubCollection(ref: userPostRef, of: UserPost.self, completion: { userPosts in
                    userProfile.posts = userPosts
                    group.leave()
                })
                
                group.enter()
                self?.fetchSubCollection(ref: userStoryRef, of: UserStory.self, completion: { userStories in
                    userProfile.stories = userStories
                    group.leave()
                })
                
                group.notify(queue: .main) {
                    completion(userProfile)
                }
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    private func fetchSubCollection<T: Codable>(ref: CollectionReference, of type: T.Type,
                                                completion: @escaping ([T]) -> Void) {
        
        dataFetcher.fetch(from: ref) { result in
            var results: [T] = []
            switch result {
            case .success(let documents):
                results = GenericParser.parse(documents, of: T.self) ?? []
                
            case .failure(let error):
                print(error)
            }
            completion(results)
        }
    }
    
    func blockUser(targetUid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let currentUser = AuthManager.shared.currentUser else {
            return
        }
        
        let userRef = FirestoreDB.users.document(currentUser.uid)
        
        userRef.setData(
            ["blocking": FieldValue.arrayUnion([targetUid])],
            merge: true,
            completion: { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(()))
        })
    }
    
    func followUser(receiverId: String, current user: SRUser,
                    completion: @escaping (Result<Void, Error>) -> Void) {
        
        let group = DispatchGroup()
        
        group.enter()
        FirestoreDB.users.document(user.uid)
            .setData(["following": FieldValue.arrayUnion([receiverId])], merge: true) { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                group.leave()
        }
        
        group.enter()
        FirestoreDB.users.document(receiverId)
            .setData(["follower": FieldValue.arrayUnion([user.uid])], merge: true) { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                group.leave()
        }
        
        let notification = SRNotification(type: "follow", senderName: user.username,
                                          senderId: user.uid, created: Date())
        group.enter()
        notificationManager.sendNotification(notification, receiverId: receiverId) { (error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
}
