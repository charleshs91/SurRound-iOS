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
  
  var location: Location? {
    didSet {
      guard let location = self.location else { return }
      let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
      let region = MKCoordinateRegion(center: clLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
      mkMapView.setRegion(region, animated: true)
    }
  }
  
  @IBOutlet weak var mkMapView: MKMapView!
  @IBOutlet weak var placeNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    mkMapView.mapType = .mutedStandard
    mkMapView.isUserInteractionEnabled = false
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mkMapView.layer.cornerRadius = 10
  }
}
