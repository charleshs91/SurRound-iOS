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
    @IBOutlet weak var descTrailingConstraint: NSLayoutConstraint!
    
    private lazy var avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnAvatar(_:)))
    private var viewModel: NotificationViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.roundToHalfHeight()
    }
    
    func setupCell(_ viewModel: NotificationViewModel) {
        
        var text: String = ""
        self.viewModel = viewModel
        if viewModel.type == "follow" {
            text = "\(viewModel.username)已開始追蹤你。"
        } else if viewModel.type == "reply" {
            text = "\(viewModel.username)在你的文章中留言。"
        }
        descLabel.text = text
    }
    
    func showPostImage() {
        
        descTrailingConstraint.isActive = false
        descTrailingConstraint = descLabel.trailingAnchor.constraint(equalTo: postImageView.leadingAnchor, constant: -16)
        descTrailingConstraint.isActive = true
        postImageView.isHidden = false
    }
    
    func hidePostImage() {
        
        descTrailingConstraint.isActive = false
        descTrailingConstraint = descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        descTrailingConstraint.isActive = true
        postImageView.isHidden = true
    }
    
    private func setupViews() {
        
        avatarImageView.addGestureRecognizer(avatarTapGesture)
    }
    
    @objc func handleTapOnAvatar(_ sender: UITapGestureRecognizer) {
        print(123)
    }
}
