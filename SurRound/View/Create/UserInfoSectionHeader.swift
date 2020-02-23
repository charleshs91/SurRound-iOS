//
//  UserInfoSectionHeader.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class UserInfoSectionHeader: UITableViewHeaderFooterView {
  
  @IBOutlet weak var userImgView: UIImageView!
  
  @IBOutlet weak var userLabel: UILabel!
  
  static var identifier: String {
    return String(describing: UserInfoSectionHeader.self)
  }
}
