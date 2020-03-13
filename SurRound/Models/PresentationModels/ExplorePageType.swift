//
//  ExplorePageType.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

enum ExplorePageType: Int {
    
    case following = 0
    case trending = 1
    case nearest = 2
    
    var title: String {
        switch self {
        case .following: return "Following"
        case .trending: return "Trending"
        case .nearest: return "Nearest"
        }
    }
}
