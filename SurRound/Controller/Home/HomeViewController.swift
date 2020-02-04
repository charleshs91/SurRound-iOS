//
//  HomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps

struct PostMarker {
    
    let post: Post
    let mapMarker: GMSMarker
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet { setupCollectionView() }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var postMarkers = [PostMarker]()
    
    // MARK: - Private Constants
    private let cellHeightInset: CGFloat = 16
    private let cellLeadingInset: CGFloat = 10
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocation()
        
        configureMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PostFetcher().fetchAllPosts { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let posts):
                posts.forEach { post in
                    let position = CLLocationCoordinate2D(latitude: post.location.latitude,
                                                          longitude: post.location.longitude)
                    let marker = GMSMarker(position: position)
                    strongSelf.postMarkers.append(PostMarker(post: post, mapMarker: marker))
                }
                
                DispatchQueue.main.async {
                    strongSelf.displayPostsOnMap()
                }
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
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
        
        mapView.delegate = self
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
    
    private func markerView() -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        view.backgroundColor = .black
        view.layer.cornerRadius = view.frame.size.width / 2
        return view
    }
    
    private func displayPostsOnMap() {
        
        postMarkers.forEach { [weak self] postPin in
            postPin.mapMarker.icon = UIImage.asset(.Icons_16px_RestaurantMarker)
            postPin.mapMarker.map = self?.mapView
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

extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let matches = postMarkers.filter { (postMarker) -> Bool in
            return postMarker.mapMarker == marker
        }
        
        if let first = matches.first {
            guard let postVC = UIStoryboard.post.instantiateInitialViewController() as? PostContentViewController else { return false }
            
            postVC.post = first.post
            navigationController?.show(postVC, sender: nil)
        }
        
        return false
    }
}
