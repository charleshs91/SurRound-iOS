//
//  UserManager.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class UserManager {
    
    static let jsonDecoder = JSONDecoder()
    
    struct FetchUserResource: Resource {
        
        var paths: [Path] {
            return [.collection(FirestoreDB.CollectionId.users), .document(userId)]
        }
        var action: Action = .fetch
        
        var conditions: [Condition] = []
        
        var userId: String
        
        init(userId: String) {
            self.userId = userId
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<SRUser, FirestoreManagerError>) -> Void) {
        
        do {
            try FirestoreManager().request(resource: FetchUserResource(userId: userId)) { result in
                switch result {
                case .success(let data):
                    do {
                        let srUser = try UserManager.jsonDecoder.decode(SRUser.self, from: data)
                        completion(.success(srUser))
                    } catch {
                        completion(.failure(.firestoreError(error.localizedDescription)))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.firestoreError(error.localizedDescription)))
        }
    }
}
