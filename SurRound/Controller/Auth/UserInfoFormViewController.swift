//
//  UserInfoFormViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/18.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class UserInfoFormViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: SRAuthTextField!
    
    @IBOutlet weak var emailTextField: SRAuthTextField!
    
    @IBOutlet weak var continueButton: SRAuthButton!
    
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.becomeFirstResponder()
        
        setupTextField()
    }
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
            let email = emailTextField.text else {
                return
        }
        
        SRProgressHUD.showLoading()
        AuthManager.shared.signUpWithApple(uid: uid, email: email, username: username) { [weak self] (result) in
            
            SRProgressHUD.dismiss()
            switch result {
            case .success:
                SRProgressHUD.showSuccess(text: "登入成功")
                self?.displayMainView()
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: "錯誤: \(error.localizedDescription)")
            }
        }
    }
    
    private func displayMainView() {
        
        if let window = AppDelegate.shared.window {
            let tbc = UIStoryboard.main.instantiateInitialViewController()
            window.rootViewController = tbc
        }
    }
    
    private func setupTextField() {
        
        let textFields = [usernameTextField, emailTextField]
        
        for textField in textFields {
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        textFieldDidChange(usernameTextField)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        continueButton.isEnabled = !usernameTextField.isEmpty
    }
}

extension UserInfoFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
