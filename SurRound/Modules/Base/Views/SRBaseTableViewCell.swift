//
//  SRBaseTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/19.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
