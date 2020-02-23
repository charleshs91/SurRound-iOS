//
//  UITextField+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol TextRelatable: AnyObject {
    
    var text: String? { get set }
    
    var isEmpty: Bool { get }
    
    func clear()
}

extension TextRelatable {
    
    var isEmpty: Bool {
        return self.text == "" || self.text == nil
    }
    
    func clear() {
        self.text = ""
    }
}

extension UITextField: TextRelatable { }
extension UILabel: TextRelatable { }

extension UITextView {
    
    var isEmpty: Bool {
        return self.text == "" || self.text == nil
    }
    
    func clear() {
        self.text = ""
    }
}
