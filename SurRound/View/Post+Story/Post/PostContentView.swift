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
        
        postImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 400)
        
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
        tableView.registerCellWithNib(withCellClass: BodyTableViewCell.self)
        
        tableView.contentInset = UIEdgeInsets(top: 400, left: 0, bottom: 0, right: 0)
        
    }
    
    private func styleCloseButton() {
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.setDefaultShadow()
    }
}
