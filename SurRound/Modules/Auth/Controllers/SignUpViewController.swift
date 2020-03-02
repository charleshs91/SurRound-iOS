//
//  SignUpViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SRAuthTextField!
    @IBOutlet weak var usernameTextField: SRAuthTextField!
    @IBOutlet weak var passwordTextField: SRAuthTextField!
    @IBOutlet weak var confirmPwdTextField: SRAuthTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpBtn: SRAuthButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        checkTextFieldsContent()
//        setupDescLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: - User Actions
    @IBAction func didTapSignUpBtn(_ sender: Any) {
        
        createAccount(completion: { [weak self] (result) in
            
            switch result {
            case .success:
                self?.displayMainView()
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }
    
    @IBAction func showPrivacyPolicy(_ sender: UIButton) {
        let wkWebVC = WKWebViewController()
        wkWebVC.urlString = "https://sites.google.com/view/charleshs"
        navigationController?.pushViewController(wkWebVC, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupTextField() {
        
        let textFields = [emailTextField, usernameTextField, passwordTextField, confirmPwdTextField]
        
        let categories: [AuthInputCategory] = [.email, .username, .password, .confirmPwd]
        
        for (textField, category) in zip(textFields, categories) {
            textField?.delegate = self
            textField?.placeholder = category.placeholder
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func createAccount(completion: @escaping (Result<SRUser, Error>) -> Void) {
        
        guard let email = emailTextField.text,
            let password = confirmPwdTextField.text,
            let username = usernameTextField.text else {
                SRProgressHUD.showFailure(text: "Missing fields")
                return
        }
        
        if !email.isValidEmail {
            SRProgressHUD.showFailure(text: "Invalid email address")
            return
        }
        
        SRProgressHUD.showLoading()
        AuthManager.shared.signUp(email: email, password: password, username: username) { authResult in
            
            switch authResult {
            case .success(let srUser):
                print("# `\(srUser.username)` created")
                completion(.success(srUser))
                
            case .failure(let error):
                SRProgressHUD.dismiss()
                completion(.failure(error))
            }
        }
    }
    
    private func checkTextFieldsContent() {
        
        errorLabel.clear()
        
        if passwordTextField.text != confirmPwdTextField.text {
            errorLabel.isHidden = false
            errorLabel.text = "密碼確認不符，請重新確認"
        }
        
        signUpBtn.isEnabled = !emailTextField.isEmpty &&
            !usernameTextField.isEmpty &&
            !passwordTextField.isEmpty &&
            passwordTextField.text == confirmPwdTextField.text
    }
    
//    private func setupDescLabel() {
//
//        descLabel.textAlignment = .center
//        descLabel.numberOfLines = 0
//
//        let titleText = "Sign up with Email"
//        let titleAttributes = [
//            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
//            .foregroundColor: UIColor.darkGray
//        ]
//        let titleString = NSMutableAttributedString(string: titleText, attributes: titleAttributes)
//
//        let captionText = "\nThe email address is only for logging into our app and won't be seen by others. Therefore, the username is required to be displayed on your posts and will be seen by others."
//        let captionAttributes = [
//            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1),
//            .foregroundColor: UIColor.gray
//        ]
//        let captionString = NSAttributedString(string: captionText, attributes: captionAttributes)
//        titleString.append(captionString)
//        descLabel.attributedText = titleString
//    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        checkTextFieldsContent()
    }
    
    private func displayMainView() {
        
        if let window = AppDelegate.shared.window {
            let tbc = UIStoryboard.main.instantiateInitialViewController()
            window.rootViewController = tbc
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkTextFieldsContent()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
