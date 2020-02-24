//
//  Story.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

class StoryCollection {
    
    var stories: [Story]
    var author: Author
    
    var isWatched: Bool = false
    
    init(stories: [Story], author: Author) {
        self.stories = stories
        self.author = author
    }
}

class Story: Codable {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
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
        return Story.dateFormatter.string(from: createdTime)
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
