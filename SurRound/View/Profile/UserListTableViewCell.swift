//
//  UserListTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    typealias ButtonHandler = (UserListTableViewCell) -> Void
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: SRMediumTextLabel!
    
    var handler: ButtonHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        handler = nil
    }
    
    func setupCell(user: SRUser, buttonHandler: ButtonHandler? = nil) {
        
        avatarImageView.loadImage(user.avatar, placeholder: UIImage.asset(.Icons_Avatar))
        
        usernameLabel.text = user.username
        
        handler = buttonHandler
    }
    
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        
        handler?(self)
    }
}
