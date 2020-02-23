//
//  UIView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundToHeight() {
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / 2
    }
}
