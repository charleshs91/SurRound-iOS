//
//  AuthViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: SRRoundedTextField! {
    didSet {
      emailTextField.delegate = self
    }
  }
  @IBOutlet weak var passwordTextField: SRRoundedTextField! {
    didSet {
      passwordTextField.delegate = self
    }
  }
  @IBOutlet weak var signInBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(false)
    super.touchesBegan(touches, with: event)
  }
  
  @IBAction func didTapSignInBtn(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapSignInAsGuest(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapAppleSignInBtn(_ sender: UIButton) {
    
  }
}

extension AuthViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
