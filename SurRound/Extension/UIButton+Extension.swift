//
//  UIButton+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/14.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setDefaultShadow() {
        
        layer.shadowOpacity = 0.7
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
    }
}
