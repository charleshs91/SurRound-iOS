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
    
    var coordinate: Coordinate? {
        didSet {
            guard let coordinate = self.coordinate else { return }
            
            let location = coordinate.location
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 100,
                                            longitudinalMeters: 100)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                           longitude: coordinate.longitude)
            mkMapView.addAnnotation(annotation)
            mkMapView.setRegion(region, animated: false)
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
