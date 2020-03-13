//
//  SRAuthButton.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRAuthButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.hexStringToUIColor(hex: "39375B")
            } else {
                backgroundColor = .lightGray
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        titleLabel?.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height / 2
    }
}
