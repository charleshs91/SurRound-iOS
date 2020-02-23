//
//  StoryCollectionCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryCollectionCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: StoryCollectionCell.self)
    }
    
    @IBOutlet weak var borderCircleView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderCircleView.layer.cornerRadius = borderCircleView.frame.size.height / 2
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        
        borderCircleView.layer.borderWidth = 2
        borderCircleView.layer.borderColor = UIColor.red.cgColor
    }
}
