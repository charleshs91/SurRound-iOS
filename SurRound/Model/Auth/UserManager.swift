//
//  UserManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
  
  static let shared = UserManager()
  
  var currentUser: SRUser?
  
  static func updateCurrentUser() {
    guard let uid = AuthManager.shared.currentUserID else { return }
    queryUser(uid: uid) { (srUser) in
      shared.currentUser = srUser
    }
  }
  
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
