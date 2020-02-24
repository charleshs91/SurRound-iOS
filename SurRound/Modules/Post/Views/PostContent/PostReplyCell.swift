//
//  PostReplyCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/15.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostReplyCell: SRBaseTableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var replyTextLabel: UILabel!
    
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.roundToHalfHeight()
        
    }

    @IBAction func didTapLikeButton(_ sender: UIButton) {
        
    }
    
    func updateCell(_ review: Review) {
        userImageView.loadImage(review.author.avatar)
        usernameLabel.text = review.author.username
        replyTextLabel.text = review.text
        datetimeLabel.text = review.datetimeString
    }
    
}
