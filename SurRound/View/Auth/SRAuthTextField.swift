//
//  SRAuthTextField.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRAuthTextField: UITextField {

  private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    
    return bounds.inset(by: padding)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    clearButtonMode = .unlessEditing
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    borderStyle = .none
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = frame.height / 2
    layer.masksToBounds = true
  }
  
}
