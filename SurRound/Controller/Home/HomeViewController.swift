//
//  HomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet { setupCollectionView() }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Private Constants
    private let cellHeightInset: CGFloat = 16
    private let cellLeadingInset: CGFloat = 10
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocation()
        
        configureMap()
    }
    
    // MARK: - Private Methods
    private func updateLocation() {
        do {
            try PlaceManager.current.updateLocation()
            
        } catch PlaceManagerError.accessDenied {
            let alert = UIAlertController(title: "Location Services disabled",
                                          message: "Please enable Location Services in Settings",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
            
        } catch { }
    }
    
    private func configureMap() {
        
        mapView.isMyLocationEnabled = true
        
        mapView.settings.myLocationButton = true
        mapView.settings.rotateGestures = false
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
        
        if let location = PlaceManager.current.location {
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 18.0)
            
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.map = mapView
        }
    }
    
    private func refreshMap() {
        
        if let location = PlaceManager.current.location {
            mapView.moveCamera(GMSCameraUpdate.setTarget(location.coordinate))
            mapView.clear()
            
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.map = mapView
        }
    }
    
    private func setupCollectionView() {
        
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        collectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        collectionView.layer.cornerRadius = 12
        
        collectionView.layer.shadowOffset = CGSize(width: 6, height: 6)
        collectionView.layer.shadowOpacity = 0.7
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowRadius = 3
        
        collectionView.contentInset = UIEdgeInsets(top: cellHeightInset / 4,
                                                   left: cellLeadingInset,
                                                   bottom: 0,
                                                   right: 0)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCollectionCell.identifier, for: indexPath)
        guard let storyCell = cell as? StoryCollectionCell else { return cell }
        
        storyCell.layoutIfNeeded()
        
        return storyCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = collectionView.frame.size.height - cellHeightInset
        
        return CGSize(width: cellHeight, height: cellHeight)
    }
}
