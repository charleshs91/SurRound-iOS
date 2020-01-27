//
//  PostContentView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostContentView: UIView {

  @IBOutlet weak var contentImgView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    tableView.registerCellWithNib(withCellClass: LocationTableViewCell.self)
    tableView.registerCellWithNib(withCellClass: BodyTableViewCell.self)
    
    tableView.backgroundColor = .clear
    tableView.contentInset = UIEdgeInsets(top: 500, left: 0, bottom: 0, right: 0)
    contentImgView.frame = CGRect(x: 0, y: 0, width: Constant.maxWidth, height: 500)
  }
}
