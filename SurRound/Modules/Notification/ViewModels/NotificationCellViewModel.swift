//
//  NotificationCellViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/2/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class NotificationCellViewModel {
    
    // MARK: - iVars
    var type: String {
        return notification.type
    }
    var username: String {
        return notification.senderName
    }
    var avatarImage: String? {
        didSet {
            guard avatarImage != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageCallback?(self!.avatarImage!)
            }
        }
    }
    
    var postImage: String? {
        didSet {
            guard postImage != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.postImageCallback?(self!.postImage!)
            }
        }
    }
    
    var datetime: Date {
        return notification.created
    }
    
    private var notification: SRNotification
    private var avatarImageCallback: ((String) -> Void)?
    private var postImageCallback: ((String) -> Void)?
    
    init(notification: SRNotification) {
        self.notification = notification
    }
    
    deinit {
        postImageCallback = nil
        avatarImageCallback = nil
    }
    
    // MARK: - Public Methods
    func updateAvatarImage(callback: ((String) -> Void)?) {
        
        self.avatarImageCallback = callback
        
        UserService.queryUser(uid: notification.senderId) { [weak self] (user) in
            guard let user = user else { return }
            self?.avatarImage = user.avatar
        }
        
    }
    
    func updatePostImage(callback: ((String) -> Void)?) {
        
        guard let postId = notification.postId else { return }
        
        self.postImageCallback = callback
        
        PostManager.shared.fetchSinglePost(postId) { [weak self] (result) in
            switch result {
            case .success(let post):
                self?.postImage = post.mediaType
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
