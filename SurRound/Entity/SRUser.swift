//
//  User.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

struct SRUser: Codable {
    
    let uid: String
    let email: String
    var username: String
    var avatar: String?
    
    enum CodingKeys: String, CodingKey {
        
        case uid
        case email
        case username
        case avatar
    }
}
