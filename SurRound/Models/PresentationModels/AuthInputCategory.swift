//
//  InputField.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

enum AuthInputCategory {
    
    case email
    case username
    case password
    case confirmPwd
    
    var placeholder: String {
        
        switch self {
        case .email:
            return "Email address"
            
        case .username:
            return "Username"
            
        case .password:
            return "Password"
            
        case .confirmPwd:
            return "Confirm password"
        }
    }
}
