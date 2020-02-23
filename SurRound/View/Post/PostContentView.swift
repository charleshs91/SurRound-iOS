//
//  PostContentView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostContentView: UIView {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var datetimeLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { setupTableView() }
    }
    
    var onOutletsBinded: () -> Void = { }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        postImageView.frame = CGRect(x: 0, y: 0, width: Constant.maxWidth, height: 500)
        
        onOutletsBinded()
    }
    
    // MARK: - Public Methods
    func layoutView(from post: Post?) {
        
        guard let post = post else { return }
        
        onOutletsBinded = { [weak self] in
            
            self?.postImageView.loadImage(post.mediaLink, placeholder: UIImage.asset(.Image_Placeholder))
            self?.userImageView.loadImage(post.author.avatar, placeholder: UIImage.asset(.Icons_Avatar))
            self?.usernameLabel.text = post.author.username
            self?.datetimeLabel.text = DateFormatter().string(from: post.createdTime)
        }
    }
    
    
    // MARK: - Private Methods
    private func setupTableView() {
        
        tableView.registerCellWithNib(withCellClass: LocationTableViewCell.self)
        tableView.registerCellWithNib(withCellClass: BodyTableViewCell.self)
        
        tableView.contentInset = UIEdgeInsets(top: 500, left: 0, bottom: 0, right: 0)
    }
}
