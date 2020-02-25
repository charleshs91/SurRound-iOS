//
//  Notification.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

struct SRNotification: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case senderName = "sender_name"
        case senderId = "sender_id"
        case created = "created"
        case postId = "post_id"
    }
    
    let type: String
    let senderName: String
    let senderId: String
    let created: Date
    var postId: String?
}
