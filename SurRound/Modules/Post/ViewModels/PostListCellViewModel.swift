//
//  PostListCellViewModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol PostListCellViewModel: AnyObject {
    
    var cellType: PostListCellType { get }
    
    var onRequestUserProfile: ((SRUser) -> Void)? { get set }
    
    var post: Post { get }
}

class BasePostListCellViewModel: PostListCellViewModel {
    
    var cellType: PostListCellType {
        fatalError("Hasn't overridden `var cellType`")
    }
    
    var authorId: String
    var username: String
    var userImageUrlString: String?
    var placeName: String?
    var datetime: String
    var text: String
    var likeCount: Int
    var replyCount: Int
    
    var onRequestUserProfile: ((SRUser) -> Void)?

    let post: Post
    
    init(_ post: Post) {
        
        self.authorId = post.authorId
        self.username = post.author.username
        self.userImageUrlString = post.author.avatar
        self.placeName = post.place.name
        self.datetime = post.datetimeString
        self.text = post.text
        self.likeCount = post.likeCount
        self.replyCount = post.replyCount
        
        self.post = post
    }
}

class ImagePostListCellViewModel: BasePostListCellViewModel {
    
    override var cellType: PostListCellType {
        return PostListCellType.image
    }
    
    var postImageUrlString: String?
    
    override init(_ post: Post) {
        self.postImageUrlString = post.mediaLink
        super.init(post)
    }
}

class TextPostListCellViewModel: BasePostListCellViewModel {
    
    override var cellType: PostListCellType {
        return PostListCellType.text
    }
}
