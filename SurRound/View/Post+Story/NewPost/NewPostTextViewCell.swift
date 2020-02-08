//
//  NewPostTextViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class NewPostTextViewCell: UITableViewCell {
  
  @IBOutlet weak var textView: KMPlaceholderTextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textView.placeholder = "Write Something..."
  }
  
}
