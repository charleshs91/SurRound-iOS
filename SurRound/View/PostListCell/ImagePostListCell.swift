//
//  ImagePostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/1.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ImagePostListCell: PostListCell {
    
    @IBOutlet weak var substrateView: UIView!
    
    // Top Section
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    // Middle Section
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    
    // Bottom Section
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var likedCountLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!
        
    var viewModel: ImagePostListCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    override func layoutCell(with viewModel: PostListCellViewModel) {
        
        guard let viewModel = viewModel as? ImagePostListCellViewModel else { return }
        
        // Top Section
        avatarImageView.loadImage(viewModel.userImageUrlString,
                                  placeholder: UIImage.asset(.Icons_Avatar))
        usernameLabel.text = viewModel.username
        placeNameLabel.text = viewModel.placeName
        datetimeLabel.text = viewModel.datetime
        // Middle Section
        postImageView.loadImage(viewModel.postImageUrlString,
                                placeholder: UIImage.asset(.Image_Placeholder))
        captionTextLabel.text = viewModel.text
        likedCountLabel.text = String(viewModel.likeCount)
        reviewCountLabel.text = String(viewModel.replyCount)
        
        self.viewModel = viewModel
    }
    
    // MARK: - User Actions
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
        
    }
    
    @IBAction func followUser(_ sender: UIButton) {
        if let currentUser = AuthManager.shared.currentUser {
        let manager = ProfileManager()
            manager.followUser(receiverId: viewModel.authorId, current: currentUser) { error in
                guard error == nil else {
                    return
                }
                SRProgressHUD.showSuccess()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        selectionStyle = .none
        
        avatarImageView.roundToHalfHeight()
        
        postImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        postImageView.layer.cornerRadius = 8
        
        styleSubstrateView()
    }
    
    private func styleSubstrateView() {
        
        substrateView.layer.cornerRadius = 8
        substrateView.layer.shadowColor = UIColor.lightGray.cgColor
        substrateView.layer.shadowOpacity = 0.7
        substrateView.layer.shadowRadius = 4
        substrateView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private func isUserPostAuthor(_ authorId: String) -> Bool {
        
        guard let user = AuthManager.shared.currentUser else {
            return false
        }
        return user.uid == authorId
    }
}
