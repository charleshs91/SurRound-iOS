//
//  AuthViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: SRRoundedTextField!
  @IBOutlet weak var passwordTextField: SRRoundedTextField!
  @IBOutlet weak var signInBtn: UIButton!
  
  private func setupTextField() {
    let textFields = [emailTextField, passwordTextField]
    let categories: [AuthInputCategory] = [.email, .password]
    for (textField, category) in zip(textFields, categories) {
      textField?.delegate = self
      textField?.placeholder = category.placeholder
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextField()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(false)
    super.touchesBegan(touches, with: event)
  }
  
  @IBAction func didTapSignInBtn(_ sender: UIButton) {
    guard let email = emailTextField.text,
          let password = passwordTextField.text else { return }
    SRProgressHUD.showLoading()
    AuthManager.shared.signIn(email: email, password: password) { [weak self] (loginResult) in
      SRProgressHUD.dismiss()
      switch loginResult {
      case .success(let uid):
        print("User ID: \(uid)")
        self?.navigationController?.dismiss(animated: true, completion: nil)
      case .failure(let error):
        SRProgressHUD.showFailure(text: error.localizedDescription)
      }
    }
  }
  
  @IBAction func didTapSignInAsGuest(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapAppleSignInBtn(_ sender: UIButton) {
    
  }
  
  private func checkTextFieldsContent() {
    signInBtn.isEnabled = !emailTextField.isEmpty && !passwordTextField.isEmpty
  }
}

extension AuthViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    checkTextFieldsContent()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
