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
            tableView.registerCellWithNib(withCellClass: PostInfoTableViewCell.self)
            tableView.registerCellWithNib(withCellClass: PostBodyCell.self)
            tableView.registerCellWithNib(withCellClass: PostReplyCell.self)
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Public Methods
    func layoutView(image: String?) {
        
        postImageView.loadImage(image, placeholder: UIImage.asset(.Image_Placeholder))
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        postImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.width * 1.2)
        tableView.contentInset = UIEdgeInsets(top: UIScreen.width, left: 0, bottom: 24, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: UIScreen.width)
        closeButton.layer.cornerRadius = 18
    }
}
