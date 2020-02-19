//
//  Post+StoryModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore

class StoryCollection {
    
    var stories: [Story]
    var author: Author
    
    var isWatched: Bool = false
    
    init(stories: [Story], author: Author) {
        self.stories = stories
        self.author = author
    }
}

struct UserStory: Codable {
    
    let storyId: String
    let storyRef: DocumentReference
    
    enum CodingKeys: String, CodingKey {
        case storyId = "story_id"
        case storyRef = "story_ref"
    }
}

class Story: Codable {
    
    init(id: String, author: Author, place: SRPlace, link: String) {
        self.id = id
        self.authorId = author.uid
        self.author = author
        self.createdTime = Date()
        self.place = place
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        self.videoLink = link
    }
    
    let id: String
    let authorId: String
    let author: Author
    let createdTime: Date
    var place: SRPlace
    var latitude: Double
    var longitude: Double
    var videoLink: String
    
    var datetimeString: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdTime)
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id = "story_id"
        case authorId = "author_id"
        case author
        case createdTime = "created_time"
        case place
        case latitude
        case longitude
        case videoLink = "video_link"
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

struct Review: Codable {
    
    init(id: String, postId: String, author: Author, text: String) {
        self.id = id
        self.postId = postId
        self.authorId = author.uid
        self.author = author
        self.text = text
        self.createdTime = Date()
    }
    
    let id: String
    let postId: String
    let authorId: String
    let author: Author
    let text: String
    let createdTime: Date
    var likes: Int = 0
    
    var datetimeString: String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdTime)
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case authorId = "author_id"
        case createdTime = "created_time"
        case id, author, text, likes
        
    }
}

struct Post: Codable {
    
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
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdTime)
    }
    
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
}

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
