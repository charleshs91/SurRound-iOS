//
//  ProfileHeaderView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.color = .white
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.stopAnimating()
        self.addSubview(indicatorView)
        return indicatorView
    }()
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var editAvatarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 16
        layer.setShadow(radius: 10, offset: CGSize(width: 4, height: 4), color: .lightGray, opacity: 0.7)
        
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
    
    // MARK: - User Actions
    func followButtonStartAnimating() {
        
        activityIndicator.frame = followButton.frame
        followButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func followButtonStopAnimating(_ toggle: Bool = true) {
        
        activityIndicator.stopAnimating()
        followButton.isHidden = false
        if toggle {
            followButton.isEnabled.toggle()
        }
    }
    
    func setupView(user: SRUser) {
        
        if user.uid == AuthManager.shared.currentUser!.uid {
            followButton.isHidden = true
        }
        usernameLabel.text = user.username
        profileImageView.loadImage(user.avatar, placeholder: UIImage.asset(.Icons_Avatar))
    }
    
    func updateProfile(profile: SRUserProfile, postCount: Int) {
        
        postCountLabel.text = "\(postCount)\nPosts"
        followingCountLabel.text = "\(profile.following.count)\nFollowing"
        followerCountLabel.text = "\(profile.follower.count)\nFollowers"
    }
}
