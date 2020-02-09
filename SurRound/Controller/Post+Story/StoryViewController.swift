//
//  StoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    let collectionView: CubeAnimatedCollectionView = {
        let clv = CubeAnimatedCollectionView()
        clv.translatesAutoresizingMaskIntoConstraints = false
        clv.isPagingEnabled = true
        clv.showsHorizontalScrollIndicator = false
        clv.showsVerticalScrollIndicator = false
        return clv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.stickToView(view)
        collectionView.registerCellWithNib(cellWithClass: StoryDetailCollectionCell.self)
        
    }
    
    @objc func dismissStoryVC(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension StoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            StoryDetailCollectionCell.reuseIdentifier, for: indexPath)
        guard let storyCell = cell as? StoryDetailCollectionCell else { return cell }
        storyCell.closeButton.addTarget(self, action: #selector(dismissStoryVC(_:)), for: .touchUpInside)
        storyCell.layoutIfNeeded()
        return storyCell
    }
}

extension StoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
}
