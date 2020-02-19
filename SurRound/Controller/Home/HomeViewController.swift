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
        didSet {
            collectionView.backgroundColor = .white
            
            collectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            collectionView.layer.cornerRadius = 8
            
            collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
            collectionView.layer.shadowOpacity = 0.6
            collectionView.layer.shadowColor = UIColor.lightGray.cgColor
            collectionView.layer.shadowRadius = 4
            
            collectionView.contentInset = UIEdgeInsets(top: cellHeightInset / 4,
                                                       left: cellLeadingInset,
                                                       bottom: 0,
                                                       right: 0)
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var postMarkers: [PostMarker] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.displayPostsOnMap()
            }
        }
    }
    
    private var storyEntities = [StoryCollection]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Constants
    private let cellHeightInset: CGFloat = 10
    private let cellLeadingInset: CGFloat = 8
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNagivationLeftTitle()
        
        updateLocation()
        
        configureMap()
        
        fetchPosts()
        
        fetchStories()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts),
                                               name: Constant.NotificationId.newPost, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchStories),
                                               name: Constant.NotificationId.newStory, object: nil)
    }
    
    // MARK: - User Actions
    @IBAction func showVideoRecording(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let imagePickerAlert = UIAlertController(title: "Post Video Story",
                                                 message: "Select video source from",
                                                 preferredStyle: .actionSheet)
        
        imagePickerAlert.addAction(
            UIAlertAction(title: "Library", style: .default) { [weak self] _ in
                
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
    @objc private func fetchStories() {
        
        storyEntities.removeAll()
        
        StoryManager().fetchStoryCollection { [weak self] result in
            
            switch result {
            case .success(let entities):
                self?.storyEntities.append(contentsOf: entities)
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func fetchPosts() {
        
        postMarkers.removeAll()
        
        PostManager().fetchAllPost { [weak self] result in
            
            switch result {
            case .success(let posts):
                posts.forEach { post in
                    let position = CLLocationCoordinate2D(latitude: post.place.coordinate.latitude,
                                                          longitude: post.place.coordinate.longitude)
                    let marker = GMSMarker(position: position)
                    self?.postMarkers.append(PostMarker(post: post, mapMarker: marker))
                }
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func styleNagivationLeftTitle() {
        
        let label = UILabel()
        label.textColor = UIColor.themeColor
        label.text = "SurRound"
        label.font = UIFont(name: "Marker Felt", size: 32)
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
    
    private func displayPostsOnMap() {
        
        postMarkers.forEach { [weak self] postPin in
            
            let imgView = SRMapMarker(avatar: postPin.post.author.avatar,
                                      text: postPin.post.text,
                                      category: nil,
                                      placeholder: UIImage.asset(.Icons_Avatar))
            
            let sizeFit = imgView.sizeThatFits(CGSize(width: 200, height: 200))
            print(sizeFit)
            
            postPin.mapMarker.iconView = imgView
            postPin.mapMarker.iconView?.frame = CGRect(x: 0, y: 0, width: 120, height: 48)
            
            postPin.mapMarker.map = self?.mapView
        }
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
        
        guard let storyCell = cell as? StoryPreviewCell else {
            return cell
        }
        
        let storyEntity = storyEntities[indexPath.item]
        storyCell.layoutCell(image: storyEntity.author.avatar,
                             text: storyEntity.author.username)
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
        
        guard let storyVC = UIStoryboard.story.instantiateInitialViewController()
            as? StoryViewController else {
                return
        }
        storyVC.modalPresentationStyle = .overCurrentContext
        storyVC.storyEntities = storyEntities
        storyVC.indexPath = IndexPath(item: 0, section: indexPath.item)
        tabBarController?.present(storyVC, animated: true, completion: nil)
    }
}

// MARK: - GMSMapViewDelegate
extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let matches = postMarkers.filter { (postMarker) -> Bool in
            return postMarker.mapMarker == marker
        }
        guard
            let first = matches.first,
            let postVC = UIStoryboard.post.instantiateInitialViewController()
                as? PostContentViewController else {
                    return false
        }
        postVC.post = first.post
        present(postVC, animated: true, completion: nil)
        
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            let newStoryVC = NewStoryViewController.storyboardInstance() else {
                return
        }
        
        newStoryVC.videoURL = url
        self.present(newStoryVC, animated: true, completion: nil)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
    
}
