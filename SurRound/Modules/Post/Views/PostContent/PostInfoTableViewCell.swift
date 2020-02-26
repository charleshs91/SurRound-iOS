//
//  LocationTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostInfoTableViewCell: SRBaseTableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleCell()
    }
    
    private var onTappingUserInfo: ((SRUser) -> Void)?
    private var post: Post!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.roundToHalfHeight()
    }
    
    func setupCell(with post: Post, userProfileHandler: ((SRUser) -> Void)? = nil) {
        
        userImageView.loadImage(post.author.avatar, placeholder: UIImage.asset(.Icons_Avatar))
        usernameLabel.text = post.author.username
        datetimeLabel.text = post.datetimeString
        placeLabel.text = post.place.name
        onTappingUserInfo = userProfileHandler
        self.post = post
    }
    
    private func styleCell() {
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16
    }
    
    @IBAction func didTapOnUserInfo(_ sender: UIButton) {
        
        let user = SRUser(uid: post.authorId, email: "", username: post.author.username, avatar: post.author.avatar)
        onTappingUserInfo?(user)
    }
}