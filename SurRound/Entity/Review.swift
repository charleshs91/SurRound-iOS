//
//  Review.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

struct Review: Codable {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case authorId = "author_id"
        case createdTime = "created_time"
        case id
        case author
        case text
        case likes
    }
    
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
        return Review.dateFormatter.string(from: createdTime)
    }
}
