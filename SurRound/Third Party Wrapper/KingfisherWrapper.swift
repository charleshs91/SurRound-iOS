//
//  KingfisherWrapper.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/22.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
  
  func loadImage(_ urlString: String?, placeholder: UIImage? = nil) {
    guard urlString != nil else { return }
    let url = URL(string: urlString!)
    self.kf.setImage(with: url, placeholder: placeholder)
  }
}
