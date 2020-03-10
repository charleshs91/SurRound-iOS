//
//  BodyTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol PostBodyCellDelegate: AnyObject {
    
    func didTapLikeButton(_ cell: PostBodyCell)
    
    func didTapReplyButton(_ cell: PostBodyCell)
    
    func didTapMoreAction(_ cell: PostBodyCell)
}

class PostBodyCell: SRBaseTableViewCell {
    
    weak var delegate: PostBodyCellDelegate?
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var onMoreActionTapped: (() -> Void)?
    
    private var viewModel: PostContentViewModelInterface?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: PostContentViewModelInterface) {
        
        postTextLabel.text = viewModel.postText
        likeButton.isSelected = viewModel.isLiked.value
        
        viewModel.isLiked.addObserver(fireNow: true) { [weak self] isLiked in
            self?.updateLikeButton(isSelected: isLiked)
        }
        self.viewModel = viewModel
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        
        delegate?.didTapLikeButton(self)
    }
    
    @IBAction func didTapReplyButton(_ sender: UIButton) {
        
        delegate?.didTapReplyButton(self)
    }
    
    @IBAction func moreActionTapped(_ sender: UIButton) {
        
        delegate?.didTapMoreAction(self)
    }
    
    private func updateLikeButton(isSelected: Bool) {
        
//        likeButton.isSelected.toggle()
        likeButton.tintColor = isSelected ? .yellow : .darkGray
    }
}
