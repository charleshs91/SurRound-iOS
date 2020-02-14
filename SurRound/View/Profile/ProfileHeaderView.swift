//
//  ProfileHeaderView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var editAvatarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        followingCountLabel.lineBreakMode = .byCharWrapping
        followingCountLabel.numberOfLines = 0
        
        followerCountLabel.lineBreakMode = .byCharWrapping
        followerCountLabel.numberOfLines = 0
        
        postCountLabel.lineBreakMode = .byCharWrapping
        postCountLabel.numberOfLines = 0
        
        postCountLabel.text = "\nPosts"
        followingCountLabel.text = "\nFollowing"
        followerCountLabel.text = "\nFollowers"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.roundToHalfHeight()
        editAvatarButton.roundToHalfHeight()
        editAvatarButton.layer.borderWidth = 2
        editAvatarButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setupView(user: SRUser) {
        usernameLabel.text = user.username
        profileImageView.loadImage(user.avatar, placeholder: UIImage.asset(.Icons_Avatar))
    }
    
    func updateProfile(profile: SRUserProfile, postCount: Int) {
        
        postCountLabel.text = "\(postCount)\nPosts"
        followingCountLabel.text = "\(profile.following.count)\nFollowing"
        followerCountLabel.text = "\(profile.follower.count)\nFollowers"
    }
}
