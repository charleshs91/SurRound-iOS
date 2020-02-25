//
//  Post.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

struct Post: Codable, Hashable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        
        case id = "post_id"
        case category
        case authorId = "author_id"
        case author
        case createdTime = "created_time"
        case text
        case place
        case latitude
        case longitude
        case mediaType = "media_type"
        case mediaLink = "media_link"
        case likeCount = "like_count"
        case replyCount = "reply_count"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    init(id: String, category: String, author: Author, text: String, place: SRPlace) {
        
        self.id = id
        self.category = category
        self.authorId = author.uid
        self.author = author
        self.createdTime = Date()
        self.text = text
        self.place = place
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
    }
    
    let id: String
    let category: String
    let authorId: String
    let author: Author
    let createdTime: Date
    let text: String
    let place: SRPlace
    let latitude: Double
    let longitude: Double
    var mediaType: String?
    var mediaLink: String?
    var likeCount: Int = 0
    var replyCount: Int = 0
    
    var datetimeString: String {
        
        return DateManager.shared.postDateFormatter().string(from: createdTime)
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}

struct UserPost: Codable {
    
    let postId: String
    let postRef: DocumentReference
    
    enum CodingKeys: String, CodingKey {
        
        case postId = "post_id"
        case postRef = "post_ref"
    }
}
