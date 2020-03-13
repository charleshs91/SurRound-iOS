//
//  SRMediumTextLabel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRMediumTextLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textColor = .systemGray
        font = .systemFont(ofSize: 16, weight: .medium)
    }

}
