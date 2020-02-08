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
    
    // Middle Section
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    
    // Bottom Section
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var likedCountLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!
        
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
    }
    
    // MARK: - User Actions
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        selectionStyle = .none
        
        avatarImageView.roundToHeight()
        
        postImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        postImageView.layer.cornerRadius = 8
        
        substrateView.layer.cornerRadius = 8
        substrateView.layer.shadowColor = UIColor.lightGray.cgColor
        substrateView.layer.shadowOpacity = 0.7
        substrateView.layer.shadowRadius = 2
        substrateView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
