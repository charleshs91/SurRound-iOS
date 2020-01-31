//
//  AuthManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias SRUserResult = (Result<SRUser, Error>) -> Void

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() { }
    
    var currentUser: SRUser? {
        get {
            guard let uid = UserDefaults.standard.object(forKey: "uid") as? String,
                let username = UserDefaults.standard.object(forKey: "username") as? String,
                let email = UserDefaults.standard.object(forKey: "email") as? String else { return nil }
            
            let avatar = UserDefaults.standard.object(forKey: "avatar") as? String
            
            return SRUser(uid: uid, email: email, username: username, avatar: avatar)
        }
        set {
            guard let user = newValue else { return }
            UserDefaults.standard.setValue(user.uid, forKey: "uid")
            UserDefaults.standard.setValue(user.username, forKey: "username")
            UserDefaults.standard.setValue(user.email, forKey: "email")
            UserDefaults.standard.setValue(user.avatar, forKey: "avatar")
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping SRUserResult) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            
            guard let user = authResult?.user, error == nil else {
                completion(.failure(error!))
                return
            }
            
            UserDBService.queryUser(uid: user.uid) { srUser in
                self?.currentUser = srUser
            }
        }
    }
    
    func signUp(email: String, password: String, username: String, completion: @escaping SRUserResult) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let user = authResult?.user, error == nil else {
                completion(.failure(error!))
                return
            }
            
            let newUser = SRUser(uid: user.uid,
                                 email: user.email!,
                                 username: username,
                                 avatar: nil)
            
            UserDBService.createUser(user: newUser, completion: completion)
        }
    }
}
