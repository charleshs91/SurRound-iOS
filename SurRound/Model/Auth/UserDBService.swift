//
//  UserManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserDBService {
    
    static func queryUser(uid: String, completion: @escaping (SRUser?) -> Void) {
        
        FirestoreDB.users.document(uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                completion(nil)
                return
            }
            
            let srUser = GenericParser.parse(snapshot, of: SRUser.self)
            
            completion(srUser)
//            do {
//                let srUser = try data.decode(SRUser.self)
//                completion(srUser)
//            } catch {
//                print(error)
//            }
        }
    }
    
    static func createUser(user: SRUser, completion: @escaping SRUserResult) {
        
        let userProfile = SRUserProfile(user: user)
        do {
            try FirestoreDB.users.document(user.uid).setData(
            from: userProfile, merge: true, encoder: .init()) { (error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(user))
            }
        } catch {
            completion(.failure(error))
        }
//
//        FirestoreDB.users.document(user.uid).setData([
//            "uid": user.uid,
//            "email": user.email,
//            "username": user.username,
//            "avatar": user.avatar ?? "",
//            "created": Timestamp(date: Date()),
//            "follower": [],
//            "following": [],
//            "blocking": []
//        ]) { (error) in
//
//            guard error == nil else {
//                completion(.failure(error!))
//                return
//            }
//            completion(.success(user))
//        }
    }
    
    static func attachPost(user: SRUser, postRef: DocumentReference) {
        
        let postId = postRef.documentID
        
        FirestoreDB.userPosts(userId: user.uid).document(postId).setData([
                UserPost.CodingKeys.postRef.rawValue: postRef,
                UserPost.CodingKeys.postId.rawValue: postRef.documentID
            ], merge: true, completion: nil)
    }
    
    static func attachStory(user: SRUser, storyRef: DocumentReference) {
        
        let storyId = storyRef.documentID
        
        FirestoreDB.userStories(userId: user.uid).document(storyId).setData([
            UserStory.CodingKeys.storyRef.rawValue: storyRef,
            UserStory.CodingKeys.storyId.rawValue: storyRef.documentID
        ], merge: true, completion: nil)
    }
}
