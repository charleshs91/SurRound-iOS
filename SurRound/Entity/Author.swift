//
//  Author.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

struct Author: Codable, Equatable, Hashable {
    
    let uid: String
    let username: String
    let avatar: String
    
    init(_ user: SRUser) {
        self.uid = user.uid
        self.username = user.username
        self.avatar = user.avatar ?? ""
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uid == rhs.uid
    }
}
