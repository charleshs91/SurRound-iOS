//
//  PostContentView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostContentView: UIView {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        postImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.width * 1.2)
        
        styleCloseButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    // MARK: - Public Methods
    func layoutView(from post: Post?) {
        
        guard let post = post else { return }
       
        postImageView.loadImage(post.mediaLink, placeholder: UIImage.asset(.Image_Placeholder))
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        
        tableView.registerCellWithNib(withCellClass: PostInfoTableViewCell.self)
        tableView.registerCellWithNib(withCellClass: PostDetailBodyCell.self)
        tableView.registerCellWithNib(withCellClass: PostReplyCell.self)
        
        tableView.contentInset = UIEdgeInsets(top: UIScreen.width * 1.2 - 24, left: 0, bottom: 24, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: UIScreen.width)
    }
    
    private func styleCloseButton() {
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.setDefaultShadow()
    }
}
