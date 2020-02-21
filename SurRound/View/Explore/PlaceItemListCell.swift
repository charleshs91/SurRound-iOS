//
//  PlaceItemListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PlaceItemListCell: SRBaseTableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ post: Post, distance: Double) {
        placeNameLabel.text = post.place.name
        addressLabel.text = post.place.address
        categoryLabel.text = post.category
        distanceLabel.text = textForDistance(distance: distance)
        postImageView.loadImage(post.mediaLink)
    }
    
    private func textForDistance(distance: Double) -> String {
        
        if distance < 1000 {
            return "\(Int(distance))m"
        }
        
        let kilometer = String(format: "%.1f", distance / 1000)
        return "\(kilometer)km"
    }
}
