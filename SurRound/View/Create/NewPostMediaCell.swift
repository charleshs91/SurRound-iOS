//
//  NewPostMediaCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NewPostMediaCell: UITableViewCell {
  
  static var identifier: String {
    return String(describing: NewPostMediaCell.self)
  }
  
  @IBOutlet weak var deleteBtn: UIButton!
  
  @IBOutlet weak var imgView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  @IBAction func didTapCamera(_ sender: UIButton) {
    
  }
  
  @IBAction func didTapDelete(_ sender: UIButton) {
  }
  
}
