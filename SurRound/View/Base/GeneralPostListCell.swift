//
//  GeneralPostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/12.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class GeneralPostListCell: UITableViewCell {
    
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
