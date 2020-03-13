//
//  PostContentViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

protocol PostContentViewModelDelegate: AnyObject {
    
}

protocol PostContentViewModelInterface {
    
    var delegate: PostContentViewModelDelegate? { get set }
    
    var avatarImage: String { get }
    var username: String { get }
    var placeName: String? { get }
    var postId: String { get }
    var postText: String { get }
    var postImageLink: String? { get }
    var likeCount: Int { get }
    var replyCount: Int { get }
    var isLiked: Observable<Bool> { get }
    var datetime: String { get }
    
    func reply(text: String, completion: @escaping (Result<Void, Error>) -> Void)
    func tapLikeButton(completion: @escaping (Result<Void, Error>) -> Void)
    func reportPost()
    func blockUser()
}

class PostContentViewModel: PostContentViewModelInterface {
    
    // MARK: - Public iVars
    weak var delegate: PostContentViewModelDelegate?
    
    var avatarImage: String {
        return post.author.avatar
    }
    var username: String {
        return post.author.username
    }
    var placeName: String? {
        return post.place.name
    }
    var postId: String {
        return post.id
    }
    var postText: String {
        return post.text
    }
    var postImageLink: String? {
        return post.mediaLink
    }
    var likeCount: Int {
        return post.likeCount
    }
    var replyCount: Int {
        return post.replyCount
    }
    lazy var isLiked: Observable<Bool> = {
        let isLiked = post.likedBy.contains(self.viewerUser.uid)
        return Observable(isLiked)
    }()
    var datetime: String {
        return post.datetimeString
    }
    // MARK: - Private iVars
    private let post: Post
    private let viewerUser: SRUser
    private let postOperator: PostLikable
    private let profileManager: ProfileManager
    
    init(post: Post, viewerUser: SRUser, postOperator: PostLikable = PostManager.shared) {
        self.post = post
        self.viewerUser = viewerUser
        self.postOperator = postOperator
        self.profileManager = ProfileManager()
    }
    
    deinit {
        print("$ PostContentViewModel deinit")
    }
    
    // MARK: - Public Methods
    func reply(text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let author = Author(viewerUser)
        
        ReviewManager.shared.sendReview(
            postAuthorId: post.authorId,
            postId: postId,
            replyAuthor: author,
            text: text
        ) { error in
            
            if error == nil {
                completion(.success(()))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func tapLikeButton(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if isLiked.value == false {
            postOperator.likePost(postId: postId, userId: viewerUser.uid) { [weak self] result in
                guard let self = self else { return }
                let handledResult = self.handleLikeResult(result: result)
                completion(handledResult)
            }
            
        } else {
            postOperator.dislikePost(postId: postId, userId: viewerUser.uid) { [weak self] result in
                guard let self = self else { return }
                let handledResult = self.handleLikeResult(result: result)
                completion(handledResult)
            }
        }
    }
    
    func reportPost() {
        
        SRProgressHUD.showLoading()
        profileManager.blockUser(targetUid: post.authorId) { result in
            
            SRProgressHUD.dismiss()
            switch result {
            case .success:
                SRProgressHUD.showSuccess(text: "We've received your report on this post.")
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    func blockUser() {
        
        SRProgressHUD.showLoading()
        profileManager.blockUser(targetUid: post.authorId) { result in
            
            SRProgressHUD.dismiss()
            switch result {
            case .success:
                SRProgressHUD.showSuccess(text: "You'll no longer see content of this user.")
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func handleLikeResult(result: Result<Void, Error>) -> Result<Void, Error> {
        
        switch result {
        case .success:
            isLiked.value.toggle()
            
        case .failure(let error):
            SRProgressHUD.showFailure(text: error.localizedDescription)
        }
        return result
    }
}
