//
//  LocationStorage.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
  
  let latitude: Double
  
  let longitude: Double
  
  let date: Date
  
  var description: String?
  
  var dateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy hh:mm:ss"
    return formatter.string(from: date)
  }
  
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case date
  }
}

class LocationProvider {
  
  static let current = LocationProvider()
  
  var location: CLLocation?
  
  static func getCurrentLocation() -> Location? {
    return convert(current.location)
  }
  
  static func convert(_ clLocation: CLLocation?) -> Location? {
    guard let location = clLocation else { return nil }
    return Location(latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    date: location.timestamp)
  }
}
