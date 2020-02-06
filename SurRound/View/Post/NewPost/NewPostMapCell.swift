//
//  NewPostMapCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import MapKit

protocol NewPostMapCellDelegate: AnyObject {
    
    func mapCell(_ mapCell: NewPostMapCell, didTapSelectLocation )
}

class NewPostMapCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: NewPostMapCell.self)
    }
    
    weak var delegate: NewPostMapCellDelegate?
    
    var canChangeLocation: Bool! {
        didSet {
            chooseLocationBtn.isHidden = !self.canChangeLocation
            
            layoutIfNeeded()
        }
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
    
    @IBOutlet weak var chooseLocationBtn: UIButton!
    
    @IBOutlet weak var placeIcon: UIImageView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var removeLocationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setVisibleForLocationInfo(false)
        
        mkMapView.mapType = .mutedStandard
        
        mkMapView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mkMapView.layer.cornerRadius = 10
    }
    
    @IBAction func removeLocation(_ sender: Any) {
        
    }
    
    private func setVisibleForLocationInfo(_ isVisible: Bool) {
        
        placeIcon.isHidden = !isVisible
        placeNameLabel.isHidden = !isVisible
        removeLocationBtn.isHidden = !isVisible
    }
}
