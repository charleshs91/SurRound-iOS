//
//  BodyTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostBodyViewModel {
    
    var postId: String
    var postText: String
    var isLiked: Observable<Bool>
    var likeCount: Int
    
    var onReplyTapped: (() -> Void)?
    
    init(post: Post, isLiked: Bool = false, likeCount: Int = 0, onReply: @escaping () -> Void) {
        self.postId = post.id
        self.postText = post.text
        self.isLiked = Observable(isLiked)
        self.likeCount = likeCount
        self.onReplyTapped = onReply
    }
}

class PostBodyCell: SRBaseTableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var onMoreActionTapped: (() -> Void)?
    
    private var viewModel: PostBodyViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            postTextLabel.text = viewModel.postText
            likeButton.isSelected = viewModel.isLiked.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: PostBodyViewModel) {
        
        guard let user = AuthManager.shared.currentUser else { return }
        
        viewModel.isLiked.addObserver(fireNow: false) { (state) in
            
            if state {
                PostManager.shared.likePost(postId: viewModel.postId, uid: user.uid) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        SRProgressHUD.showFailure(text: error.localizedDescription)
                    case .success:
                        self?.updateLikeButton()
                    }
                }
            } else {
                PostManager.shared.dislikePost(postId: viewModel.postId, uid: user.uid) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        SRProgressHUD.showFailure(text: error.localizedDescription)
                    case .success:
                        self?.updateLikeButton()
                    }
                }
            }
        }
        
        self.viewModel = viewModel
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        
        viewModel?.isLiked.value.toggle()
    }
    
    @IBAction func didTapReplyButton(_ sender: UIButton) {
        
        viewModel?.onReplyTapped?()
    }
    @IBAction func moreActionTapped(_ sender: UIButton) {
        
        onMoreActionTapped?()
    }
    
    private func updateLikeButton() {
        
        likeButton.isSelected.toggle()
        likeButton.tintColor = likeButton.isSelected ? .yellow : .darkGray
    }
}
