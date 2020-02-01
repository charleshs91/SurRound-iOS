//
//  TrendingListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import collection_view_layouts

class TrendingListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet { setupCollectionView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
    }
    
    private func setupCollectionView() {
        
        collectionView.registerCellWithNib(cellWithClass: TrendingListGridCell.self)
        
        collectionView.collectionViewLayout = getLayout()
        collectionView.reloadData()
    }
    
    private func getLayout() -> UICollectionViewLayout {
        
        let layout = InstagramLayout()
        layout.delegate = self
        layout.contentPadding = ItemsPadding(horizontal: 4, vertical: 4)
        layout.cellsPadding = ItemsPadding(horizontal: 4, vertical: 4)
        layout.gridType = .regularPreviewCell
        return layout
    }
}

extension TrendingListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingListGridCell.identifier,
            for: indexPath)
        
        return cell
    }
}

extension TrendingListViewController: UICollectionViewDelegate {
    
}

extension TrendingListViewController: LayoutDelegate {
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
}
