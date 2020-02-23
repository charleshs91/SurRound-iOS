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
    
    static func queryUser(uid: String, completion: @escaping (SRUser) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            guard let data = snapshot?.data(), error == nil else {
                print(error!)
                return
            }
            
            do {
                let srUser = try data.decode(SRUser.self)
                completion(srUser)
            } catch {
                print(error)
            }
        }
    }
    
    static func createUser(user: SRUser, completion: @escaping SRUserResult) {
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "uid": user.uid,
            "email": user.email,
            "username": user.username,
            "follower": [],
            "following": []
        ]) { (error) in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(user))
        }
    }
    
    static func attachPost(user: SRUser, postRef: DocumentReference) {
        
        Firestore.firestore()
            .collection("users").document(user.uid)
            .collection("user_posts").document(postRef.documentID).setData([
                "post_ref": postRef,
                "post_id": postRef.documentID
            ], merge: true, completion: nil)
    }
    
    static func attachStory(user: SRUser, storyRef: DocumentReference) {
        
        Firestore.firestore()
        .collection("users").document(user.uid)
        .collection("user_stories").document(storyRef.documentID).setData([
            "story_ref": storyRef,
            "story_id": storyRef.documentID
        ], merge: true, completion: nil)
    }
}

extension Dictionary {
    
    func decode<T: Codable>(_ type: T.Type) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let result = try JSONDecoder().decode(T.self, from: jsonData)
            return result
            
        } catch {
            throw error
        }
    }
}
