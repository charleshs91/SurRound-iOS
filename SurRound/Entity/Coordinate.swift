//
//  Coordinate.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    
    var latitude: Double
    var longitude: Double
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
        set {
            self.latitude = newValue.coordinate.latitude
            self.longitude = newValue.coordinate.longitude
        }
    }
    
    init(lat: Double, long: Double) {
        
        self.latitude = lat
        self.longitude = long
    }
    
    init(_ clCoordinate: CLLocationCoordinate2D) {
        
        self.latitude = clCoordinate.latitude
        self.longitude = clCoordinate.longitude
    }
    
    init(_ location: CLLocation) {
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
