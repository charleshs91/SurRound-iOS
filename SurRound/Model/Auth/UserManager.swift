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
  
  class func createUser(user: SRUser, completion: @escaping (Result<SRUser, Error>) -> Void) {
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
