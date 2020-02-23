//
//  PlaceItemListCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PlaceItemListCell: UITableViewCell {
        
    static var identifier: String {
        return String(describing: PlaceItemListCell.self)
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet { setupCollectionView() }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet { setupPageControl() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerCellWithNib(cellWithClass: PlacePostCollectionCell.self)
        
        collectionView.isPagingEnabled = true
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    private func setupPageControl() {
        
        pageControl.numberOfPages = 5
    }
}

extension PlaceItemListCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlacePostCollectionCell.identifier, for: indexPath)
        
        return cell
    }
}

extension PlaceItemListCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        pageControl.currentPage = indexPath.item
    }
}

extension PlaceItemListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentView.frame.width - layoutMargins.left - layoutMargins.right
        
        return CGSize(width: width, height: width)
    }
}
