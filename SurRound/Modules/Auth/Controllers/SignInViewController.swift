//
//  SignInViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SRAuthTextField!
    
    @IBOutlet weak var passwordTextField: SRAuthTextField!
    
    @IBOutlet weak var signInBtn: SRAuthButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        checkTextFieldsContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: - User Actions
    @IBAction func didTapSignInBtn(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        SRProgressHUD.showLoading()
        
        AuthManager.shared.signIn(email: email, password: password) { loginResult in
            
            SRProgressHUD.dismiss()
            
            switch loginResult {
            case .success:
                self.displayMainView()
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupTextField() {
        
        let textFields = [emailTextField, passwordTextField]
        
        let categories: [AuthInputCategory] = [.email, .password]
        
        for (textField, category) in zip(textFields, categories) {
            textField?.delegate = self
            textField?.placeholder = category.placeholder
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func checkTextFieldsContent() {
        
        signInBtn.isEnabled = !emailTextField.isEmpty && !passwordTextField.isEmpty
    }
    
    private func displayMainView() {
        
        if let window = AppDelegate.shared.window {
            let tbc = UIStoryboard.main.instantiateInitialViewController()
            window.rootViewController = tbc
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        checkTextFieldsContent()
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
