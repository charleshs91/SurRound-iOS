//
//  NotificationCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    
    func didTapOnAvatar(_ cell: NotificationCell)
}

class NotificationCell: SRBaseTableViewCell {
    
    weak var delegate: NotificationCellDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descTrailingConstraint: NSLayoutConstraint!
    
    private var avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnAvatar(_:)))
    private var viewModel: NotificationCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.roundToHalfHeight()
    }
    
    func setupCell(_ viewModel: NotificationCellViewModel) {
        
        self.viewModel = viewModel

        descLabel.text = {
            switch viewModel.type {
            case "follow": return "\(viewModel.username)已開始追蹤你。"
            case "reply": return "\(viewModel.username)在你的文章中留言。"
            default: return ""
            }
        }()
        
        fetchImages(from: viewModel)
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
    
    private func fetchImages(from viewModel: NotificationCellViewModel) {
        
        viewModel.updateAvatarImage { [weak self] urlString in
            self?.avatarImageView.loadImage(urlString)
        }
        viewModel.updatePostImage { [weak self] urlString in
            self?.postImageView.loadImage(urlString)
        }
    }
    
    @objc func handleTapOnAvatar(_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOnAvatar(self)
    }
}
