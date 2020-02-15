//
//  PostReplyCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/15.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostReplyCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var replyTextLabel: UILabel!
    
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
    }
    
}
