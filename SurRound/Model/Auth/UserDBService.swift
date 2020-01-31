//
//  UserManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

class UserDBService {
    
    //  static let shared = UserManager()
    
    //  var currentUser: SRUser? {
    //    get {
    //      guard let uid = UserDefaults.standard.object(forKey: "uid") as? String,
    //        let username = UserDefaults.standard.object(forKey: "username") as? String,
    //        let email = UserDefaults.standard.object(forKey: "email") as? String else { return nil }
    //
    //      return SRUser(uid: uid, email: email, username: username)
    //    }
    //    set {
    //      guard let user = newValue else { return }
    //      UserDefaults.standard.setValue(user.uid, forKey: "uid")
    //      UserDefaults.standard.setValue(user.username, forKey: "username")
    //      UserDefaults.standard.setValue(user.email, forKey: "email")
    //    }
    //  }
    //
    //  static func updateCurrentUser(completion: @escaping (SRUser) -> Void) {
    //    guard let uid = AuthManager.shared.currentUserID else { return }
    //    queryUser(uid: uid) { (srUser) in
    //      shared.currentUser = srUser
    //      completion(srUser)
    //    }
    //  }
    
    static func queryUser(uid: String, completion: @escaping (SRUser) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            
            guard let data = snapshot?.data(), error == nil else {
                print(error!)
                return
            }
            
            guard let uid = data["uid"] as? String,
                let email = data["email"] as? String,
                let username = data["username"] as? String else { return }
            completion(SRUser(uid: uid, email: email, username: username))
        }
    }
    
    static func createUser(user: SRUser, completion: @escaping (Result<SRUser, Error>) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "uid": user.uid,
            "email": user.email,
            "username": user.username
        ]) { (error) in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(user))
        }
    }
}
