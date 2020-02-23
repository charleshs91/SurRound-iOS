//
//  PlaceModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import GooglePlaces

class SRPlace: Codable {
    
    var coordinate: Coordinate
    var name: String?
    var address: String?
    
    init(_ coordinate: CLLocationCoordinate2D) {
        
        self.coordinate = Coordinate(coordinate)
        self.name = nil
        self.address = nil
    }
    
    init(place: GMSPlace) {
        
        self.coordinate = Coordinate(place.coordinate)
        self.name = place.name
        self.address = place.formattedAddress
    }
    
    init(_ coordinate: Coordinate, name: String?, address: String?) {
        self.coordinate = coordinate
        self.name = name
        self.address = address
    }
}

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
