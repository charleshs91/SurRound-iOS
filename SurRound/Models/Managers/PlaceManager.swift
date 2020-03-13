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
    
    static let current = PlaceManager()
    
    var coordinate: Coordinate?
    
    var place: SRPlace? {
        guard let location = self.location else { return nil }
        return SRPlace(location.coordinate)
    }
    
    var location: CLLocation? {
        return clLocationManager.location
    }
    
    private let clLocationManager = CLLocationManager()
    
    private var onUpdated: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        
        clLocationManager.delegate = self
    }
    
    func updateLocation(completion: @escaping (CLLocation?) -> Void) throws {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            clLocationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            throw PlaceManagerError.accessDenied
            
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            return
        }
        
        self.onUpdated = completion
        clLocationManager.startUpdatingLocation()
    }
    
    static func calculateDistance(_ target: Coordinate, reference: Coordinate) -> Double {
        
        return target.location.distance(from: reference.location)
    }
}

extension PlaceManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            coordinate = Coordinate(location)
            onUpdated?(location)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        SRProgressHUD.showFailure(text: error.localizedDescription)
        manager.stopUpdatingLocation()
    }
}
