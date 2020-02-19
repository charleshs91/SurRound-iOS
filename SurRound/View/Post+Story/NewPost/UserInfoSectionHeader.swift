//
//  UserInfoSectionHeader.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class UserInfoSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: SRRoundedLabel! {
        didSet {
            categoryLabel.backgroundColor = .systemGray5
            categoryLabel.textColor = .darkGray
        }
    }
    
    func updateView(category: PostCategory, user: SRUser?) {
        
        categoryLabel.text = category.text
        userLabel.text = user?.username
        userImgView.loadImage(user?.avatar, placeholder: UIImage.asset(.Icons_Avatar))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutCategoryLabel()
    }
    
    private func layoutCategoryLabel() {
        
        categoryLabel.sizeToFit()
        let xPos = UIScreen.width - categoryLabel.frame.width - 16
        categoryLabel.frame.origin = CGPoint(x: xPos, y: 16)
    }
}
