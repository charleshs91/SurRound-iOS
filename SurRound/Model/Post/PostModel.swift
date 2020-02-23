//
//  PostModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post: Codable {
  
  let id: String
  let category: String
  let author: Author
  let createdTime: Date
  let text: String
  let location: Location
  var mediaType: String?
  var mediaLink: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "post_id"
    case category
    case author
    case createdTime = "created_time"
    case text
    case location
    case mediaType = "media_type"
    case mediaLink = "media_link"
  }
  
  struct Author: Codable {
    let uid: String
    let username: String
    let avatar: String
  }
}
