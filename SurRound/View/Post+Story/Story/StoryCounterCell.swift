//
//  StoryCounterCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryCounterCell: UICollectionViewCell {

    @IBOutlet weak var timerBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timerBar.progress = 0
    }
}
