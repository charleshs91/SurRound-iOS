//
//  LocationStorage.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
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
    
    init(_ location: CLLocation) {
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

enum PlaceManagerError: Error {
    
    case accessDenied
}

class PlaceManager: NSObject {
    
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
