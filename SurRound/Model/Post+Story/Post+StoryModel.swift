//
//  Post+StoryModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Story: Codable {
    
    let id: String
    let author: String
    let createdTime: Date
    let place: SRPlace
    let movieLink: String
    let movieDuration: Double
    
    var datetimeString: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdTime)
    }
}

struct Post: Codable {
    
    let id: String
    let category: String
    let author: Author
    let createdTime: Date
    let text: String
    let place: SRPlace
    var mediaType: String?
    var mediaLink: String?
    
    var datetimeString: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdTime)
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id = "post_id"
        case category
        case author
        case createdTime = "created_time"
        case text
        case place
        case mediaType = "media_type"
        case mediaLink = "media_link"
    }
}

struct Author: Codable {
    
    let uid: String
    let username: String
    let avatar: String
    
    init(user: SRUser) {
        self.uid = user.uid
        self.username = user.username
        self.avatar = user.avatar ?? ""
    }
}
