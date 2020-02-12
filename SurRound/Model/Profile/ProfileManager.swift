//
//  ProfileManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/12.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ProfileManager {
    
    var userProfile: SRUserProfile?
    
    private var dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchProfile(user uid: String, completion: @escaping (SRUserProfile?) -> Void) {
        
        let docRef = FirestoreService.users.document(uid)
        
        dataFetcher.fetch(from: docRef) { result in
            switch result {
            case .success(let document):
                let profile = GenericParser.parse(document, of: SRUserProfile.self)
                self.userProfile = profile
                completion(profile)
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func followUser(receiverId: String, current user: SRUser, completion: @escaping (Error?) -> Void) {
        
        let group = DispatchGroup()
        
        group.enter()
        FirestoreService.users.document(user.uid)
            .setData(["following": FieldValue.arrayUnion([receiverId])], merge: true) { error in
                
                guard error == nil else {
                    completion(error!)
                    return
                }
                group.leave()
        }
        
        group.enter()
        FirestoreService.users.document(receiverId)
            .setData(["follower": FieldValue.arrayUnion([user.uid])], merge: true) { error in
                
                guard error == nil else {
                    completion(error!)
                    return
                }
                group.leave()
        }
        
        group.enter()
        FirestoreService.users.document(receiverId).collection("notifications").document()
            .setData([
                "type": "follow",
                "sender_name": user.username,
                "sender_id": user.uid
            ], merge: true) { error in
                
                guard error == nil else {
                    completion(error!)
                    return
                }
                group.leave()
        }
        
        group.notify(queue: .main) {
            completion(nil)
        }
    }
}
