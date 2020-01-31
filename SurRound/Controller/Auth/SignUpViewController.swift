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
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
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
                self?.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }
    
    // MARK: - Private Methods
    private func setupTextField() {
        
        let textFields = [emailTextField, usernameTextField, passwordTextField, confirmPwdTextField]
        
        let categories: [AuthInputCategory] = [.email, .username, .password, .confirmPwd]
        
        for (textField, category) in zip(textFields, categories) {
            textField?.delegate = self
            textField?.placeholder = category.placeholder
        }
    }
    
    private func createAccount(completion: @escaping (Result<SRUser, Error>) -> Void) {
        
        guard let email = emailTextField.text,
            let password = confirmPwdTextField.text,
            let username = usernameTextField.text else {
                SRProgressHUD.showFailure(text: "Missing fields")
                return
        }
        
        if !validateEmail(email) {
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
    
    private func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        guard let regEx = try? NSRegularExpression(pattern: emailRegex, options: .caseInsensitive) else {
            return false
        }
        
        let matches = regEx.matches(in: candidate,
                                    options: [],
                                    range: NSRange(location: 0, length: candidate.count))
        return matches.count > 0
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
