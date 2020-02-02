//
//  ImagePostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/1.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ImagePostListCell: UITableViewCell {
    
    @IBOutlet weak var substrateView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var likedButton: UIButton!
    
    @IBOutlet weak var likedCountLabel: UILabel!
    
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    static var identifier: String {
        return String(describing: ImagePostListCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }
    
    // MARK: - User Actions
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapReviewButton(_ sender: UIButton) {
    }
    
    // MARK: - Private Methods
    private func configureCell() {
        
        selectionStyle = .none
        
        postImageView.clipsToBounds = true
        
        substrateView.layer.cornerRadius = 8
        substrateView.layer.shadowColor = UIColor.lightGray.cgColor
        substrateView.layer.shadowOpacity = 0.7
        substrateView.layer.shadowRadius = 2
        substrateView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
