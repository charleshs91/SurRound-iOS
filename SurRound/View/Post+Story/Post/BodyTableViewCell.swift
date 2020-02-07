//
//  BodyTableViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class BodyTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: BodyTableViewCell.self)
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
