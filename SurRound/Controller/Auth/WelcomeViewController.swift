//
//  WelcomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: UIViewController {
    
    private let appleSignInButton: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(authorizationButtonType: .default,
                                               authorizationButtonStyle: .black)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signInWithApple(_:)), for: .touchUpInside)
        btn.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appleSignInButton)
        appleSignInButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0), widthConstant: 300, heightConstant: 50)
        appleSignInButton.anchorCenterXToSuperview()
    }
    
    @objc private func signInWithApple(_ sender: ASAuthorizationAppleIDButton) {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension WelcomeViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        print("Success")
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        
        print("Fail to Sign in to Apple")
    }
}

extension WelcomeViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
}
