//
//  Constant.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

struct Constant {
    
    struct Google {
        
        static let googleServiceInfo = "GoogleService-Info"
        static let plist = "plist"
        static let apiKey = "API_KEY"
    }
    
    struct Auth {
        
        static let uid = "uid"
        static let username = "username"
        static let email = "email"
        static let avatar = "avatar"
    }
    
    struct NotificationId {
        
        static let newPost = Notification.Name(rawValue: "SurRound.NewPost")
        static let newStory = Notification.Name(rawValue: "SurRound.NewStory")
    }
}
