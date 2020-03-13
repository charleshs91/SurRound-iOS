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

class IGImagePickerController: UIViewController {
    
    static func storyboardInstance() -> IGImagePickerController? {
        return UIStoryboard.profile.instantiateViewController(
            identifier: String(describing: self)) as? IGImagePickerController
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        grabPhotos()
    }
    
    var imageArray = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func setupCollectionView() {
        
        collectionView.allowsSelection = true
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
        
        let width = collectionView.frame.width / 3 - 1
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
        print(image.jpegData(compressionQuality: 0.9))
    }
}
