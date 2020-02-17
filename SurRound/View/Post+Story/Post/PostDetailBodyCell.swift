//
//  BodyTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostDetailBodyCellViewModel {
    
    var postText: String
    var isLiked: Observable<Bool>
    var likeCount: Int
    
    var onReplyTapped: (() -> Void)?
    
    init(post: Post, isLiked: Bool = false, likeCount: Int = 0, _ onReply: @escaping () -> Void) {
        self.postText = post.text
        self.isLiked = Observable(isLiked)
        self.likeCount = likeCount
        self.onReplyTapped = onReply
    }
}

class PostDetailBodyCell: UITableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    private var viewModel: PostDetailBodyCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            postTextLabel.text = viewModel.postText
            likeButton.isSelected = viewModel.isLiked.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: PostDetailBodyCellViewModel) {
        
        self.viewModel = viewModel
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        
        likeButton.isSelected.toggle()
        likeButton.tintColor = likeButton.isSelected ? .yellow : .darkGray
        viewModel?.isLiked.value.toggle()
    }
    
    @IBAction func didTapReplyButton(_ sender: UIButton) {
        
        viewModel?.onReplyTapped?()
    }
}
