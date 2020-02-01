//
//  ImagePostListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/1.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ImagePostListCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var likedButton: UIButton!
    
    @IBOutlet weak var likedCountLabel: UILabel!
    
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
    
    // MARK: - Private Methods
    private func configureCell() {
        
        selectionStyle = .none
    }
}
