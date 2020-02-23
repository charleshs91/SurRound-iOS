//
//  UITextField+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UITextField {
    
    var isEmpty: Bool {
        
        return self.text == "" || self.text == nil
    }
}
