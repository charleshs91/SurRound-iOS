//
//  AppleSignInViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AuthenticationServices

// MARK: - Protocols
protocol AppleSignInAction {
    
    func executeSignIn(delegate: AppleSignInViewModelDelegate?)
    
    func createAcountInDatabase(srUser: SRUser, completion: @escaping (Result<SRUser, Error>) -> Void)
}

protocol AppleSignInViewModelDelegate: AnyObject {
    
    func didSignInAsNewUser(_ viewModel: AppleSignInViewModel, userId: String)
    
    func didSignInAsExistingUser(_ viewModel: AppleSignInViewModel)
    
    func didFailSignIn(_ viewModel: AppleSignInViewModel, with error: Error)
}

// MARK: - AppleSignInViewModel
class AppleSignInViewModel: NSObject, AppleSignInAction {
    
    weak var delegate: AppleSignInViewModelDelegate?
    
    private let presentationAnchor: UIWindow
 
    init(presentationAnchor: UIWindow) {
        
        self.presentationAnchor = presentationAnchor
    }
    
    // MARK: - Public Methods
    func executeSignIn(delegate: AppleSignInViewModelDelegate?) {
        
        self.delegate = delegate
        
        performRequests()
    }
    
    func createAcountInDatabase(srUser: SRUser, completion: @escaping (Result<SRUser, Error>) -> Void) {
        
        let uid = srUser.uid
        let email = srUser.email
        let username = srUser.username
        
        AuthManager.shared.signUpWithApple(uid: uid, email: email, username: username, completion: completion)
    }
    
    // MARK: - Private Methods
    private func performRequests() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    private func verifyUserIdInDatabase(uid: String) {
        
        UserService.queryUser(uid: uid) { [weak self, delegate] srUser in
            
            guard let strongSelf = self else { return }
            
            if let srUser = srUser {
                AuthManager.shared.currentUser = srUser
                DispatchQueue.main.async {
                    delegate?.didSignInAsExistingUser(strongSelf)
                }
                
            } else {
                DispatchQueue.main.async {
                    delegate?.didSignInAsNewUser(strongSelf, userId: uid)
                }
            }
        }
    }
    
    private func checkAuthorization(for credential: ASAuthorizationAppleIDCredential) {
        
        let userId = credential.user
        let uid = String(userId.split(separator: ".")[1])
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userId) { [weak self] (credentialState, _) in
            
            switch credentialState {
            case .authorized:
                self?.verifyUserIdInDatabase(uid: uid)
                
            default:
                break
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleSignInViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        checkAuthorization(for: credential)
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        
        delegate?.didFailSignIn(self, with: error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleSignInViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.presentationAnchor
    }
}
