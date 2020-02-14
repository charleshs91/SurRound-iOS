//
//  UserListTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: SRMediumTextLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(user: SRUser) {
        
        avatarImageView.loadImage(user.avatar, placeholder: UIImage.asset(.Icons_Avatar))
        
        usernameLabel.text = user.username
    }
}
