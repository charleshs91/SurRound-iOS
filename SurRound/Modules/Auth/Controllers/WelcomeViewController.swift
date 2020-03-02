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
    
    @IBOutlet weak var emailSignInBtn: SRAuthButton!
    
    @IBOutlet weak var guestSignInBtn: SRAuthButton!
    
    private let curveShapeView: CurveShapeView = {
        let view = CurveShapeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        
        setupBackgroundView()
        
        appleSignInButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,
                                 padding: .zero, widthConstant: 0, heightConstant: 48)
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
   
    // MARK: - User Actions
    @objc func signInWithApple(_ sender: ASAuthorizationAppleIDButton) {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func signInAsGuest(_ sender: UIButton) {
        
        if let guestVC = UIStoryboard.guest.instantiateInitialViewController() {
            guestVC.modalPresentationStyle = .overCurrentContext
            present(guestVC, animated: true, completion: nil)
        }
        
    }
    
    private func displayMainView() {
        
        if let window = AppDelegate.shared.window {
            let tbc = UIStoryboard.main.instantiateInitialViewController()
            window.rootViewController = tbc
        }
    }
    
    private func setupBackgroundView() {
        
        view.insertSubview(curveShapeView, at: 0)
        curveShapeView.shapeColor = UIColor.hexStringToUIColor(hex: "39375B")
        curveShapeView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height / 1.6)
        
        let vStack = UIStackView(arrangedSubviews: [emailSignInBtn, appleSignInButton, guestSignInBtn])
        view.addSubview(vStack)

        vStack.axis = .vertical
        vStack.spacing = 24
           
        vStack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), widthConstant: 0, heightConstant: 0)
        
        NSLayoutConstraint(item: vStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.75, constant: 0).isActive = true
        
    }
}
extension WelcomeViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userId = credential.user
        let uid = String(userId.split(separator: ".")[1])
        
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userId) { [weak self] (credentialState, _) in
            
            switch credentialState {
            case .authorized:
                
                UserService.queryUser(uid: uid) { (srUser) in
                    
                    guard let user = srUser else {
                        DispatchQueue.main.async {
                            let newVC = UIStoryboard.auth.instantiateViewController(identifier: "UserInfoFormViewController")
                            guard let userInfoVC = newVC as? UserInfoFormViewController else { return }
                            userInfoVC.uid = uid
                            self?.navigationController?.show(userInfoVC, sender: nil)
                        }
                        return
                    }
                    
                    AuthManager.shared.currentUser = user
                    DispatchQueue.main.async {
                        self?.displayMainView()
                    }
                }
                
            default:
                break
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension WelcomeViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
}
