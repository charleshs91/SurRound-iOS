//
//  PlaceItemListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PlaceItemListCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
