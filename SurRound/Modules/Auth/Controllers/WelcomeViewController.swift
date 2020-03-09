//
//  WelcomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AuthenticationServices

class WelcomeViewController: SRBaseViewController {
    
    @IBOutlet weak var emailSignInBtn: SRAuthButton!
    @IBOutlet weak var guestSignInBtn: SRAuthButton!
    
    var appleSignInViewModel: AppleSignInAction?
    
    // MARK: - Private iVars
    private let appleSignInButton: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(authorizationButtonType: .default,
                                               authorizationButtonStyle: .black)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signInWithApple(_:)), for: .touchUpInside)
        btn.cornerRadius = 20
        return btn
    }()
    
    private lazy var loginButtonsStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [emailSignInBtn, appleSignInButton, guestSignInBtn])
        vStack.axis = .vertical
        vStack.spacing = 24
        return vStack
    }()
    
    private let curveShapeView: CurveShapeView = create {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.shapeColor = UIColor.hexStringToUIColor(hex: "39375B")
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height / 1.6)
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - User Actions
    @objc func signInWithApple(_ sender: ASAuthorizationAppleIDButton) {
        
        appleSignInViewModel = AppleSignInViewModel(presentationAnchor: self.view.window!)
        appleSignInViewModel?.executeSignIn(delegate: self)
    }
    
    @IBAction func signInAsGuest(_ sender: UIButton) {
        
        if let guestVC = UIStoryboard.guest.instantiateInitialViewController() {
            guestVC.modalPresentationStyle = .overCurrentContext
            present(guestVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    private func displayMainView() {
        
        if let window = AppDelegate.shared.window {
            let tbc = UIStoryboard.main.instantiateInitialViewController()
            window.rootViewController = tbc
        }
    }
    
    private func setupViews() {
        
        view.insertSubview(curveShapeView, at: 0)
        setupLoginButtonsStackView()
    }
    
    private func setupLoginButtonsStackView() {
        
        view.addSubview(loginButtonsStackView)
        loginButtonsStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,
                                     padding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                                     widthConstant: 0, heightConstant: 0)
        
        appleSignInButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,
                                 padding: .zero, widthConstant: 0, heightConstant: 48)
        
        NSLayoutConstraint(item: loginButtonsStackView, attribute: .centerY, relatedBy: .equal,
                           toItem: view, attribute: .bottom, multiplier: 0.75, constant: 0).isActive = true
    }
}

// MARK: - AppleSignInViewModelDelegate
extension WelcomeViewController: AppleSignInViewModelDelegate {
    
    func didSignInAsNewUser(_ viewModel: AppleSignInViewModel, userId: String) {
        
        let userInfoVC = UserInfoFormViewController.instantiate()
        userInfoVC.uid = userId
        userInfoVC.appleSignInViewModel = appleSignInViewModel
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    func didSignInAsExistingUser(_ viewModel: AppleSignInViewModel) {
        
        displayMainView()
    }
    
    func didFailSignIn(_ viewModel: AppleSignInViewModel, with error: Error) {
        
        SRProgressHUD.showFailure(text: error.localizedDescription)
    }
    
}
