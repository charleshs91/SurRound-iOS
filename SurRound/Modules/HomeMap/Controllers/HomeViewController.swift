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

private let cellHeightInset: CGFloat = 10
private let cellLeadingInset: CGFloat = 8

class HomeViewController: UIViewController {
    
    // MARK: - iVars
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .white
            collectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            collectionView.layer.cornerRadius = 8
            collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
            collectionView.layer.shadowOpacity = 0.6
            collectionView.layer.shadowColor = UIColor.lightGray.cgColor
            collectionView.layer.shadowRadius = 4
            collectionView.contentInset =
                UIEdgeInsets(top: cellHeightInset / 4, left: cellLeadingInset, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var homeViewModel: HomeViewModel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNagivationLeftTitle()
        updateLocation()
        configureMap()
        fireUpViewModel()
    }
    
    // MARK: - User Actions
    @IBAction func showNewStoryAction(_ sender: UIBarButtonItem) {
        
        displayNewStoryActionSheet()
    }
    
    // MARK: - Private Methods
    private func styleNagivationLeftTitle() {
        
        let label = UILabel()
        label.textColor = UIColor.themeColor
        label.text = "SurRound"
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
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
            
        } catch {
            print(error)
        }
    }
    
    private func configureMap() {
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        if let mapStyleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: mapStyleURL)
        }
        if let location = PlaceManager.current.location {
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 18.0)
        }
    }
    
    private func fireUpViewModel() {
        
        homeViewModel = HomeViewModel()
        
        homeViewModel.bindMapPost { [weak self] mapPosts in
            
            guard let strongSelf = self else {
                return
            }
            
            mapPosts.forEach {
                $0.displayMarker(onMap: strongSelf.mapView)
            }
        }
        homeViewModel.bindStory { [weak self] _ in
            
            self?.collectionView.reloadData()
        }
    }
        
    private func displayNewStoryActionSheet() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        let imagePickerAlert = UIAlertController(title: "Post Video Story",
                                                 message: "Select video source from",
                                                 preferredStyle: .actionSheet)
        
        imagePickerAlert.addAction(UIAlertAction(title: "Library", style: .default) { [weak self] _ in
            
                self?.presentImagePickerForPhotosAlbum(imagePicker)
        })
        
        imagePickerAlert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            
                self?.presentImagePickerForCamera(imagePicker)
        })
        
        imagePickerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
                imagePickerAlert.dismiss(animated: true, completion: nil)
        })
        
        present(imagePickerAlert, animated: true, completion: nil)
    }
    
    private func presentImagePickerForPhotosAlbum(_ imagePicker: UIImagePickerController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func presentImagePickerForCamera(_ imagePicker: UIImagePickerController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.videoQuality = .typeHigh
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return homeViewModel.numberOfStoryCollections + 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryPreviewCell.reuseIdentifier, for: indexPath)
        guard let storyCell = cell as? StoryPreviewCell else {
            return cell
        }
        
        switch indexPath.item {
        case 0:
            storyCell.showAsNewStoryButton()
        default:
            if let storyCollection = homeViewModel.getStoryCollectionAt(index: indexPath.item - 1) {
                storyCell.layoutCell(image: storyCollection.author.avatar,
                                     text: storyCollection.author.username)
            }
        }
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
        
        switch indexPath.item {
        case 0:
            displayNewStoryActionSheet()
        default:
            guard
                let storyVC = UIStoryboard.story.instantiateInitialViewController() as? StoryViewController
                else {
                    return
            }
            storyVC.modalPresentationStyle = .overCurrentContext
            storyVC.storyEntities = homeViewModel.storyCollections
            storyVC.initialIndexPath = IndexPath(item: 0, section: indexPath.item - 1)
            tabBarController?.present(storyVC, animated: true, completion: nil)
        }
    }
}

// MARK: - GMSMapViewDelegate
extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard
            let post = homeViewModel.getPostFromMarker(marker),
            let nav = UIStoryboard.post.instantiateInitialViewController() as? UINavigationController,
            let postVC = nav.topViewController as? PostContentViewController else {
                return false
        }
        postVC.post = post
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        return true
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if let myLocation = mapView.myLocation {
            mapView.animate(to: GMSCameraPosition(target: myLocation.coordinate, zoom: 18))
            return true
        }
        return false
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                return
        }
        dismiss(animated: true, completion: { [weak self] in
            self?.homeViewModel.sendStory(videoURL: url)
        })
    }
}
