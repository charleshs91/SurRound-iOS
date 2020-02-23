//
//  UserModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SRNotification: Codable {
    
    let type: String
    let senderName: String
    let senderId: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case senderName = "sender_name"
        case senderId = "sender_id"
        case created = "created"
    }
    
}

class SRUserProfile: Codable {
    
    let uid: String
    let email: String
    var username: String
    var avatar: String?
    
    var following: [String] = []
    var follower: [String] = []
    
    var posts: [UserPost] = []
    var stories: [UserStory] = []
    
    var notifications: [SRNotification] = []
    
    enum CodingKeys: String, CodingKey {
        
        case uid
        case email
        case username
        case avatar
        case following
        case follower
    }
    
    init(user: SRUser) {
        
        self.uid = user.uid
        self.email = user.email
        self.username = user.username
        self.avatar = user.avatar
    }
}

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
