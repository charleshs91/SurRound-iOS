//
//  LocationStorage.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import CoreLocation

enum PlaceManagerError: Error {
    
    case accessDenied
}

class PlaceManager: NSObject {
    
    struct Default {
        
        static let taipei: SRPlace = SRPlace(coordinate: Coordinate(lat: 25.0475847, long: 121.5162492),
                                             name: nil,
                                             address: nil)
    }
    
    static let current = PlaceManager()
    
    let manager = CLLocationManager()
    
    var coordinate: Coordinate?
    
    var location: CLLocation? {
        return manager.location
    }
    
    override init() {
        super.init()
        
        manager.delegate = self
    }
    
    func updateLocation() throws {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            throw PlaceManagerError.accessDenied
            
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            return
        }
        
        manager.startUpdatingLocation()
    }
}

extension PlaceManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            coordinate = Coordinate(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        SRProgressHUD.showFailure(text: error.localizedDescription)
        manager.stopUpdatingLocation()
    }
}
