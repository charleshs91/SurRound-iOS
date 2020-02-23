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
    
    var canChangeLocation: Bool! {
        didSet {
            chooseLocationBtn.isHidden = !self.canChangeLocation
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
            
            mkMapView.removeAnnotations(mkMapView.annotations)
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
    
    // MARK: - User Actions
    func setPlace(with place: SRPlace) {
        
        coordinate = place.coordinate
        placeNameLabel.text = place.name
        chooseLocationBtn.isHidden.toggle()
        setVisibleForLocationInfo(true)
    }
    
    @IBAction func removeLocation(_ sender: Any) {
        
        coordinate = PlaceManager.current.coordinate
        chooseLocationBtn.isHidden.toggle()
        setVisibleForLocationInfo(false)
    }
    
    private func setVisibleForLocationInfo(_ isVisible: Bool) {
        
        placeIcon.isHidden = !isVisible
        placeNameLabel.isHidden = !isVisible
        removeLocationBtn.isHidden = !isVisible
    }
}
