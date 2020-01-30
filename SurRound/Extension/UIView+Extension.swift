//
//  UIView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIView {
  
  func setCornerRadius(by ratio: CGFloat) {
    layer.cornerRadius = frame.size.width * ratio
  }
}
