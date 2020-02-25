//
//  StoryCollectionCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {
    
    private let kUnreadColor = UIColor.hexStringToUIColor(hex: "66CCCC")
    private let kReadColor = UIColor.lightGray
    
    @IBOutlet weak var borderCircleView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderCircleView.layer.masksToBounds = true
        avatarImageView.layer.masksToBounds = true
        
        borderCircleView.layer.cornerRadius = borderCircleView.frame.size.height / 2
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        
        borderCircleView.layer.borderWidth = 2
        borderCircleView.layer.borderColor = UIColor.red.cgColor
    }
    
    func layoutCell(image: String, text: String) {
        avatarImageView.loadImage(image, placeholder: UIImage.asset(.Icons_Avatar))
        usernameLabel.text = text
    }
}
