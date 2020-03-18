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
    
    let avatarImage: Observable<String?> = .init(nil)
    
    let postImage: Observable<String?> = .init(nil)

    var datetime: Date {
        return notification.created
    }
    
    private var notification: SRNotification
    
    init(notification: SRNotification) {
        self.notification = notification
        
        updateAvatarImage()
        updatePostImage()
    }

    // MARK: - Public Methods
    func updateAvatarImage() {
        
        UserService.queryUser(uid: notification.senderId) { [weak self] (user) in
            guard let user = user else { return }
            self?.avatarImage.value = user.avatar
        }
    }
    
    func updatePostImage() {
        
        guard let postId = notification.postId else { return }
        
        PostManager.shared.fetchSinglePost(postId) { [weak self] (result) in
            switch result {
            case .success(let post):
                self?.postImage.value = post.mediaLink
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
