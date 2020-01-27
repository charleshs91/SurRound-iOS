//
//  SRAuthButton.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRAuthButton: UIButton {
  
  struct SizeRatio {
    static let roundCornerRatio = CGFloat(0.25)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.size.height * SizeRatio.roundCornerRatio
  }
  
}
