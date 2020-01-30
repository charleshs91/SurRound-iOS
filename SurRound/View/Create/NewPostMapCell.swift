//
//  NewPostMapCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import MapKit

class NewPostMapCell: UITableViewCell {
  
  static var identifier: String {
    return String(describing: NewPostMapCell.self)
  }
  
  @IBOutlet weak var mkMapView: MKMapView!
  @IBOutlet weak var placeNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mkMapView.layer.cornerRadius = 10
  }
}
