//
//  LocationTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol PostInfoTableViewCellDelegate: AnyObject {
    
    func didTapOnUser(_ cell: PostInfoTableViewCell, user: SRUser)
}

class PostInfoTableViewCell: SRBaseTableViewCell {
    
    weak var delegate: PostInfoTableViewCellDelegate?
    
    var postContentViewModel: PostContentViewModelInterface!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleCell()
    }
    
    private var onTappingUserInfo: ((SRUser) -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.roundToHalfHeight()
    }
    
    func configure(with viewModel: PostContentViewModelInterface) {
        
        userImageView.loadImage(viewModel.avatarImage, placeholder: UIImage.asset(.Icons_Avatar))
        usernameLabel.text = viewModel.username
        datetimeLabel.text = viewModel.datetime
        placeLabel.text = viewModel.placeName
        
        self.postContentViewModel = viewModel
    }
    
    private func styleCell() {
        
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16
    }
    
    @IBAction func didTapOnUserInfo(_ sender: UIButton) {
        
        let user = SRUser(uid: postContentViewModel.userId,
                          email: "",
                          username: postContentViewModel.username,
                          avatar: postContentViewModel.avatarImage)
        delegate?.didTapOnUser(self, user: user)
    }
}
