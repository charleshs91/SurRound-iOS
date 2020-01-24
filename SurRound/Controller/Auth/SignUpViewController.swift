//
//  SignUpViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: SRRoundedTextField!
  @IBOutlet weak var usernameTextField: SRRoundedTextField!
  @IBOutlet weak var passwordTextField: SRRoundedTextField!
  @IBOutlet weak var confirmPwdTextField: SRRoundedTextField!
  @IBOutlet weak var signUpBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTextField()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(false)
    super.touchesBegan(touches, with: event)
  }
  
  @IBAction func didTapSignUpBtn(_ sender: Any) {
    SRProgressHUD.shared.showLoading()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      SRProgressHUD.shared.dismiss()
      self?.navigationController?.dismiss(animated: true, completion: nil)
    }
  }
  
  private func setupTextField() {
    emailTextField.delegate = self
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    confirmPwdTextField.delegate = self
  }
}

extension SignUpViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
