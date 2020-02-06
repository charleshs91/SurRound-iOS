//
//  SelectLocationViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SelectLocationViewController: UIViewController {
    
    static func storyboardInstance() -> SelectLocationViewController? {
        return UIStoryboard.newPost.instantiateViewController(
            identifier: String(describing: SelectLocationViewController.self)
            ) as? SelectLocationViewController
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    private func configureMap() {
        
        //        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.rotateGestures = false
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
        
        if let location = PlaceManager.current.location {
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 18.0)
        }
    }
}
