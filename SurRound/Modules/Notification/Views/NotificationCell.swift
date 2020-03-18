//
//  NotificationCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    
    func didTapOnAvatar(_ cell: NotificationCell, viewModel: NotificationCellViewModel)
    
    func didTapOnPostImage(_ cell: NotificationCell, viewModel: NotificationCellViewModel)
}

class NotificationCell: SRBaseTableViewCell {
    
    weak var delegate: NotificationCellDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descTrailingConstraint: NSLayoutConstraint!
    
    private var viewModel: NotificationCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.roundToHalfHeight()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        unbind()
    }
    
    func setupCell(_ viewModel: NotificationCellViewModel) {
        
        self.viewModel = viewModel
        
        bindAvatarImage()
        bindPostImage()
        showDescription()
    }
    
    func showPostImage() {
        
        descTrailingConstraint.isActive = false
        descTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: postImageView.leadingAnchor, constant: -16)
        descTrailingConstraint.isActive = true
        postImageView.isHidden = false
    }
    
    func hidePostImage() {
        
        descTrailingConstraint.isActive = false
        descTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        descTrailingConstraint.isActive = true
        postImageView.isHidden = true
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnAvatar(_:)))
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnPostImage(_:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(postImageTapGesture)
        postImageView.layer.cornerRadius = 8
    }
    
    private func showDescription() {
        
        var text = ""
        switch viewModel.type {
        case "follow":
            text = "\(viewModel.username)已開始追蹤你。"
        case "reply":
            text = "\(viewModel.username)在你的文章中留言。"
        default:
            break
        }
        descriptionLabel.text = text
    }
    
    private func bindAvatarImage() {
        
        viewModel.avatarImage.addObserver { [weak self] urlString in
            self?.avatarImageView.loadImage(urlString, placeholder: UIImage.asset(.Image_Avatar_Placeholder))
        }
    }
    
    private func bindPostImage() {
        
        viewModel.postImage.addObserver { [weak self] urlString in
            if urlString == nil {
                self?.hidePostImage()
                return
            }
            self?.postImageView.loadImage(urlString, placeholder: UIImage.asset(.Image_Placeholder))
            self?.showPostImage()
        }
    }
    
    private func unbind() {
        
        viewModel.avatarImage.removeObserver()
        viewModel.postImage.removeObserver()
    }
    
    // MARK: - Selectors
    @objc func handleTapOnAvatar(_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOnAvatar(self, viewModel: viewModel)
    }
    
    @objc func handleTapOnPostImage(_ sender: UITapGestureRecognizer) {
        
        delegate?.didTapOnPostImage(self, viewModel: viewModel)
    }
}
