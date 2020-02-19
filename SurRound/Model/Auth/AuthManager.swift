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
    
    var userProfile: SRUserProfile?
    
    var currentUser: SRUser? {
        get {
            guard
                let uid = UserDefaults.standard.object(forKey: Constant.Auth.uid) as? String,
                let username = UserDefaults.standard.object(forKey: Constant.Auth.username) as? String,
                let email = UserDefaults.standard.object(forKey: Constant.Auth.email) as? String
                else { return nil }
            
            let avatar = UserDefaults.standard.object(forKey: Constant.Auth.avatar) as? String
            
            return SRUser(uid: uid, email: email, username: username, avatar: avatar)
        }
        set {
            guard let user = newValue else { return }
            UserDefaults.standard.setValue(user.uid, forKey: Constant.Auth.uid)
            UserDefaults.standard.setValue(user.username, forKey: Constant.Auth.username)
            UserDefaults.standard.setValue(user.email, forKey: Constant.Auth.email)
            UserDefaults.standard.setValue(user.avatar, forKey: Constant.Auth.avatar)
            
            updateProfile()
        }
    }
    
    func updateProfile() {
        
        guard let user = currentUser else {
            return
        }
        
        let manager = ProfileManager()
        manager.fetchProfile(user: user.uid, completion: { profile in
            
            guard let profile = profile else {
                return
            }
            
            self.userProfile = profile
        })
    }
    
    func signIn(email: String, password: String,
                completion: @escaping SRUserResult) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            
            guard let user = authResult?.user, error == nil else {
                completion(.failure(error!))
                return
            }
            
            UserDBService.queryUser(uid: user.uid) { srUser in
                self?.currentUser = srUser
                completion(.success(srUser!))
            }
        }
    }
    
    func signUpWithApple(uid: String, email: String, username: String,
                         completion: @escaping SRUserResult) {
        
        StorageManager().uploadAvatar(UIImage.asset(.Image_Avatar_Placeholder)!, userId: uid) { (url) in
            
            let newUser = SRUser(uid: uid,
                                 email: email,
                                 username: username,
                                 avatar: url?.absoluteString ?? "")
            
            UserDBService.createUser(user: newUser) { [weak self] (result) in
                
                switch result {
                case .success(let srUser):
                    self?.currentUser = srUser
                    completion(.success(srUser))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signUp(email: String, password: String, username: String,
                completion: @escaping SRUserResult) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            guard let user = authResult?.user, error == nil else {
                completion(.failure(error!))
                return
            }
            
            StorageManager().uploadAvatar(UIImage.asset(.Image_Avatar_Placeholder)!, userId: user.uid) { (url) in
                
                let newUser = SRUser(uid: user.uid,
                                     email: user.email!,
                                     username: username,
                                     avatar: url?.absoluteString ?? "")
                
                UserDBService.createUser(user: newUser, completion: { _ in
                    self.signIn(email: email, password: password, completion: completion)
                })
            }
        }
    }
    
    func signOut() -> Bool {
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: Constant.Auth.uid)
            UserDefaults.standard.removeObject(forKey: Constant.Auth.username)
            UserDefaults.standard.removeObject(forKey: Constant.Auth.email)
            UserDefaults.standard.removeObject(forKey: Constant.Auth.avatar)
            
            return true
            
        } catch {
            debugPrint(error)
            return false
        }
    }
}
