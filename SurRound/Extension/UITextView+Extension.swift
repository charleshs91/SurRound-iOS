//
//  UITextView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UITextView {
    
    var isEmpty: Bool {
        
        return self.text == "" || self.text == nil
    }
}
