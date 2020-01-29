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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
  }
  
  @IBAction func didTapSignInBtn(_ sender: UIButton) {
    guard let email = emailTextField.text,
          let password = passwordTextField.text else { return }
    SRProgressHUD.showLoading()
    AuthManager.shared.signIn(email: email, password: password) { loginResult in
      SRProgressHUD.dismiss()
      switch loginResult {
      case .success(let uid):
        print("User ID: \(uid)")
        self.displayMainView()
      case .failure(let error):
        SRProgressHUD.showFailure(text: error.localizedDescription)
      }
    }
  }
  
  @IBAction func close(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  private func checkTextFieldsContent() {
    signInBtn.isEnabled = !emailTextField.isEmpty && !passwordTextField.isEmpty
  }
  
  private func displayMainView() {
    if let window = AppDelegate.shared.window {
      let tbc = UIStoryboard.main.instantiateInitialViewController()
      window.rootViewController = tbc
      window.makeKeyAndVisible()
      
    }
  }
}

extension SignInViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    checkTextFieldsContent()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
