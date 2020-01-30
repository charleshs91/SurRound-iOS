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
  
  var pickedImage: UIImage? {
    didSet {
      guard let image = pickedImage else {
        contentImgView.image = UIImage.asset(.Image_Placeholder)
        deleteBtn.isHidden = true
        return
      }
      contentImgView.image = image
      deleteBtn.isHidden = false
    }
  }
  
  var attachHandler: (() -> Void)?
  var deleteHandler: (() -> Void)?
  
  @IBOutlet weak var deleteBtn: UIButton!
  @IBOutlet weak var contentImgView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    deleteBtn.isHidden = true
  }

  @IBAction func didTapCamera(_ sender: UIButton) {
    attachHandler?()
  }
  
  @IBAction func didTapDelete(_ sender: UIButton) {
    deleteHandler?()
  }
  
}
