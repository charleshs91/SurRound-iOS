//
//  String+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/18.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        guard let regEx = try? NSRegularExpression(
            pattern: emailRegex, options: .caseInsensitive) else {
                return false
        }
        
        let matches = regEx.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return matches.count > 0
    }
}
