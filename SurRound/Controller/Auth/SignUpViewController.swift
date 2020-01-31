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
  
  private func setupTextField() {
    let textFields = [emailTextField, usernameTextField, passwordTextField, confirmPwdTextField]
    let categories: [AuthInputCategory] = [.email, .username, .password, .confirmPwd]
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
    emailTextField.becomeFirstResponder()
    super.viewDidAppear(animated)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(false)
    super.touchesBegan(touches, with: event)
  }
  
  @IBAction func didTapSignUpBtn(_ sender: Any) {
    createAccount(completion: { [weak self] (result) in
      switch result {
      case .success:
        self?.navigationController?.dismiss(animated: true, completion: nil)
      case .failure(let error):
        SRProgressHUD.showFailure(text: error.localizedDescription)
      }
    })
  }
  
  private func createAccount(completion: @escaping (Result<Void, Error>) -> Void) {
    guard let email = emailTextField.text,
      let password = confirmPwdTextField.text,
      let username = usernameTextField.text else { return }
    SRProgressHUD.showLoading()
    AuthManager.shared.signUp(email: email, password: password) { (authResult) in
      switch authResult {
      case .success(let uid):
        let user = SRUser(uid: uid, email: email, username: username)
        UserManager.createUser(user: user) { (dbResult) in
          SRProgressHUD.dismiss()
          switch dbResult {
          case .success(let srUser):
            print("# `\(srUser.username)` created")
            completion(.success(()))
          case .failure(let error):
            completion(.failure(error))
          }
        }
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
      errorLabel.text = "密碼確認不符，請重新輸入"
    }
    signUpBtn.isEnabled = !emailTextField.isEmpty &&
                          !usernameTextField.isEmpty &&
                          !passwordTextField.isEmpty &&
                          passwordTextField.text == confirmPwdTextField.text
  }
}

extension SignUpViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    checkTextFieldsContent()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
