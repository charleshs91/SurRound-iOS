//
//  ProfileUserListModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

enum ProfileUserListModel {
    
    case following(SRUserProfile)
    
    case follower(SRUserProfile)
    
    var uids: [String] {
        switch self {
        case .follower(let profile):
            return profile.follower
            
        case .following(let profile):
            return profile.following
        }
    }
    
    var title: String {
        switch self {
        case .follower:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}
