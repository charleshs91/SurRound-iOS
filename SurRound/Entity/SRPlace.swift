//
//  SRPlace.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import GooglePlaces

class SRPlace: Codable {
    
    var coordinate: Coordinate
    var name: String?
    var address: String?
    
    convenience init(_ coordinate: CLLocationCoordinate2D) {
        
        self.init(Coordinate(coordinate), name: nil, address: nil)
    }
    
    convenience init(place: GMSPlace) {
        
        self.init(Coordinate(place.coordinate), name: place.name, address: place.formattedAddress)
    }
    
    init(_ coordinate: Coordinate, name: String?, address: String?) {
        self.coordinate = coordinate
        self.name = name
        self.address = address
    }
}
