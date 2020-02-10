//
//  HomeViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GoogleMaps
import MobileCoreServices

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
    private var storyEntities = [StoryEntity]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Constants
    private let cellHeightInset: CGFloat = 12
    private let cellLeadingInset: CGFloat = 8
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocation()
        
        configureMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if postMarkers.count == 0 {
            fetchPosts()
        }
        if storyEntities.count == 0 {
            fetchStories()
        }
    }
    
    // MARK: - User Actions
    @IBAction func showVideoRecording(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let imagePickerAlert = UIAlertController(title: "Create Story with Video",
                                                 message: "Select video source from",
                                                 preferredStyle: .actionSheet)
        
        imagePickerAlert.addAction(
            UIAlertAction(title: "Video library", style: .default) { [weak self] _ in
                
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    self?.present(imagePicker, animated: true, completion: nil)
                }
        })
        
        imagePickerAlert.addAction(
            UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    imagePicker.videoQuality = .typeHigh
                    self?.present(imagePicker, animated: true, completion: nil)
                }
        })
        
        imagePickerAlert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { _ in
                
                imagePickerAlert.dismiss(animated: true, completion: nil)
        })
        
        present(imagePickerAlert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func fetchStories() {
        
        storyEntities.removeAll()
        StoryManager().fetchAllStoryEntities { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let entities):
                strongSelf.storyEntities.append(contentsOf: entities)
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func fetchPosts() {
        
        postMarkers.removeAll()
        PostManager().fetchAllPosts { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let posts):
                posts.forEach { post in
                    let position = CLLocationCoordinate2D(latitude: post.place.coordinate.latitude,
                                                          longitude: post.place.coordinate.longitude)
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
        
        return storyEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryPreviewCell.reuseIdentifier, for: indexPath)
        guard let storyCell = cell as? StoryPreviewCell else { return cell }
        
        let storyEntity = storyEntities[indexPath.item]
        
        storyCell.layoutCell(storyEntity.author.avatar)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let storyVC = UIStoryboard.story.instantiateInitialViewController() as? StoryViewController else { return }
        storyVC.modalPresentationStyle = .overCurrentContext
        storyVC.storyEntities = storyEntities
        tabBarController?.present(storyVC, animated: true, completion: nil)
    }
}

// MARK: - GMSMapViewDelegate
extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let matches = postMarkers.filter { (postMarker) -> Bool in
            return postMarker.mapMarker == marker
        }
        
        if let first = matches.first {
            guard let postVC = UIStoryboard.post.instantiateInitialViewController()
                as? PostContentViewController else { return false }
            
            postVC.post = first.post
            navigationController?.show(postVC, sender: nil)
        }
        
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else { return }

        guard let newStoryVC = NewStoryViewController.storyboardInstance() else { return }
        newStoryVC.videoURL = url
        self.present(newStoryVC, animated: true, completion: nil)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
    
}
