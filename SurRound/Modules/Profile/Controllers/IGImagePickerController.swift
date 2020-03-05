//
//  IGImagePicker.swift
//  CSLibrary
//
//  Created by Kai-Ta Hsieh on 2020/2/17.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import Photos

class IGImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}

protocol IGImagePickerControllerDelegate: AnyObject {
    
    func didSelectImage(_ controller: IGImagePickerController, with image: UIImage)
}

class IGImagePickerController: UIViewController, Storyboarded {
    
    static var storyboard: UIStoryboard {
        return UIStoryboard.profile
    }
    
    weak var delegate: IGImagePickerControllerDelegate?
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        grabPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedImageView.image = imageArray.first
    }
    
    var imageArray = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func setupViews() {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navHeight = navigationController?.navigationBar.frame.height ?? 0.0
        let safeAreaHeight = statusBarHeight + navHeight
        
        selectedImageView.frame = CGRect(x: 0, y: safeAreaHeight, width: UIScreen.width, height: UIScreen.width)
        selectedImageView.layer.borderWidth = 1
        selectedImageView.layer.borderColor = UIColor.white.cgColor
        
        collectionView.contentInset = UIEdgeInsets(top: UIScreen.width, left: 1, bottom: 0, right: 1)
        collectionView.contentOffset = CGPoint(x: 0, y: -UIScreen.width)
        collectionView.allowsSelection = true
    }
    
    @IBAction func selectImage(_ sender: UIBarButtonItem) {
        
        delegate?.didSelectImage(self, with: selectedImageView.image!)
    }
    
    func grabPhotos() {
        
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            for index in 0..<fetchResult.count {
                imageManager.requestImage(
                    for: fetchResult.object(at: index),
                    targetSize: CGSize(width: 256, height: 256),
                    contentMode: .aspectFill,
                    options: requestOptions) { (image, _) in
                        self.imageArray.append(image!)
                }
            }
        } else {
            print("You got no photos!")
            collectionView.reloadData()
        }
    }
}

extension IGImagePickerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IGImageCell.reuseIdentifier, for: indexPath)
        guard let imageCell = cell as? IGImageCell else { return cell }
        imageCell.imageView.image = imageArray[indexPath.item]
        return imageCell
    }
}

extension IGImagePickerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageArray[indexPath.item]
        selectedImageView.image = image
    }
}
