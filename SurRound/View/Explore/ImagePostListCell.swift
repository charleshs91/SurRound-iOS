//
//  ImagePostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/1.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostListCellViewModel {
    
    let username: String
    let text: String
    let datetime: String
    var placeName: String?
    var userImageUrlString: String?
    var postImageUrlString: String?
    
    init(_ post: Post) {
        
        self.username = post.author.username
        self.text = post.text
        self.datetime = post.datetimeString
        self.placeName = "Somewhere"
        self.userImageUrlString = post.author.avatar
        self.postImageUrlString = post.mediaLink
    }
}

class ImagePostListCell: UITableViewCell {
    
    @IBOutlet weak var substrateView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var likedButton: UIButton!
    
    @IBOutlet weak var likedCountLabel: UILabel!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    static var identifier: String {
        return String(describing: ImagePostListCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        placeNameLabel.clear()
        userImageView.image = nil
        postImageView.image = nil
    }
    
    func layoutCell(_ viewModel: PostListCellViewModel) {
        
        usernameLabel.text = viewModel.username
        postTextLabel.text = viewModel.text
        postImageView.loadImage(viewModel.postImageUrlString,
                                placeholder: UIImage.asset(.Image_Placeholder))
        userImageView.loadImage(viewModel.userImageUrlString,
                                placeholder: UIImage.asset(.Icons_Avatar))
        placeNameLabel.text = viewModel.placeName
        datetimeLabel.text = viewModel.datetime
    }
    
    // MARK: - User Actions
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
    }
    
    // MARK: - Private Methods
    private func initCell() {
        
        selectionStyle = .none
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        
        substrateView.layer.cornerRadius = 8
        substrateView.layer.shadowColor = UIColor.lightGray.cgColor
        substrateView.layer.shadowOpacity = 0.7
        substrateView.layer.shadowRadius = 2
        substrateView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
