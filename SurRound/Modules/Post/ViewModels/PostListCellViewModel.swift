//
//  PostListCellViewModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

//protocol PostListCellViewModel: AnyObject {
//
//    var cellType: PostListCellType { get }
//
//    var onRequestUserProfile: ((SRUser) -> Void)? { get set }
//
//    var post: Post { get }
//
//    var isLiked: Observable<Bool> { get set }
//
//    func increaseLikeCount(value: Int)
//}

class PostListCellViewModel {
    
    var cellType: PostListCellType {
        fatalError("Hasn't overridden `var cellType`")
    }
    
    var authorId: String
    var username: String
    var userImageUrlString: String?
    var placeName: String?
    var datetime: String
    var text: String
    var likeCount: Observable<Int>
    var replyCount: Observable<Int>
    lazy var isLiked: Observable<Bool> = {
        let isLiked = post.likedBy.contains(self.viewerUser.uid)
        return Observable(isLiked)
    }()
    
    var onRequestUserProfile: ((SRUser) -> Void)?

    let post: Post
    
    private let viewerUser: SRUser
    
    init(_ post: Post, viewerUser: SRUser) {
        self.authorId = post.authorId
        self.username = post.author.username
        self.userImageUrlString = post.author.avatar
        self.placeName = post.place.name
        self.datetime = post.datetimeString
        self.text = post.text
        self.likeCount = .init(post.likeCount)
        self.replyCount = .init(post.replyCount)
        self.viewerUser = viewerUser
        self.post = post
    }
    
    func increaseLikeCount(value: Int) {
        likeCount.value += value
    }
}

class ImagePostListCellViewModel: PostListCellViewModel {
    
    override var cellType: PostListCellType {
        return PostListCellType.image
    }
    
    var postImageUrlString: String?
    
    override init(_ post: Post, viewerUser: SRUser) {
        self.postImageUrlString = post.mediaLink
        super.init(post, viewerUser: viewerUser)
    }
}

class TextPostListCellViewModel: PostListCellViewModel {
    
    override var cellType: PostListCellType {
        return PostListCellType.text
    }
}
