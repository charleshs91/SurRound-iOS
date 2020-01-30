//
//  HomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
  
  let locationManager = CLLocationManager()
  
  var currentLocation: Location?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    monitorLocation()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    locationManager.stopUpdatingLocation()
  }
  
  func monitorLocation() {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
      
    case .denied, .restricted:
      let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
      return
      
    case .authorizedAlways, .authorizedWhenInUse:
      break
      
    @unknown default:
      return
    }
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let current = locations.last {
      LocationProvider.current.location = current
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
