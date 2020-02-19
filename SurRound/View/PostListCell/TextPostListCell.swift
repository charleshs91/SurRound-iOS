//
//  TextPostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class TextPostListCell: PostListCell {
    
    @IBOutlet weak var substrateView: UIView!
    
    // Top Section
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    // Middle Section
    @IBOutlet weak var largeTextLabel: UILabel!
    
    // Bottom Section
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var likedCountLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var viewModel: TextPostListCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    override func layoutCell(with viewModel: PostListCellViewModel) {
        
        guard let viewModel = viewModel as? TextPostListCellViewModel else { return }
        
        // Top Section
        avatarImageView.loadImage(viewModel.userImageUrlString,
                                  placeholder: UIImage.asset(.Icons_Avatar))
        usernameLabel.text = viewModel.username
        placeNameLabel.text = viewModel.placeName
        datetimeLabel.text = viewModel.datetime
        
        // Middle Section
        largeTextLabel.text = viewModel.text
        likedCountLabel.text = String(viewModel.likeCount)
        reviewCountLabel.text = String(viewModel.replyCount)
        
        self.viewModel = viewModel
    }
    
    // MARK: - User Actions
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        selectionStyle = .none
        
        avatarImageView.roundToHalfHeight()
                
        substrateView.layer.cornerRadius = 8
        substrateView.layer.shadowColor = UIColor.lightGray.cgColor
        substrateView.layer.shadowOpacity = 0.7
        substrateView.layer.shadowRadius = 2
        substrateView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    private func isUserPostAuthor(_ authorId: String) -> Bool {
        
        guard let user = AuthManager.shared.currentUser else {
            return false
        }
        return user.uid == authorId
    }
}
