//
//  UserProfile.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class SRUserProfile: Codable {
    
    let uid: String
    let email: String
    var username: String
    var avatar: String?
    let created: Date
    
    var following: [String] = []
    var follower: [String] = []
    var blocking: [String] = []
    
    var posts: [UserPost] = []
    var stories: [UserStory] = []
    
    var notifications: [SRNotification] = []
    
    enum CodingKeys: String, CodingKey {
        
        case uid
        case email
        case username
        case avatar
        case created
        case following
        case follower
        case blocking
    }
    
    init(user: SRUser) {
        
        self.uid = user.uid
        self.email = user.email
        self.username = user.username
        self.avatar = user.avatar
        self.created = Date()
    }
}
