//
//  ShadedButton.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ShadedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.setShadow(radius: 4, offset: CGSize(width: 0, height: 2), color: .gray, opacity: 0.7)
        layer.cornerRadius = 4
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
