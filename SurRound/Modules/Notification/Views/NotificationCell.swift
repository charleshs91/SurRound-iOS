//
//  NotificationCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NotificationCell: SRBaseTableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postImageWidth: NSLayoutConstraint!
    
    private lazy var avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnAvatar(_:)))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.roundToHalfHeight()
    }
    
    func hidePostImage() {
        postImageWidth.isActive = false
        postImageWidth.constant = 0
        postImageWidth.isActive = true
    }
    
    private func setupViews() {
        
        avatarImageView.addGestureRecognizer(avatarTapGesture)
    }
    
    @objc func handleTapOnAvatar(_ sender: UITapGestureRecognizer) {
        print(123)
    }
}
