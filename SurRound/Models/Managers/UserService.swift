//
//  UserManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserService {
    
    static func queryUser(uid: String, completion: @escaping (SRUser?) -> Void) {
        
        FirestoreDB.users.document(uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                completion(nil)
                return
            }
            
            let srUser = GenericParser.parse(snapshot, of: SRUser.self)
            
            completion(srUser)
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
