//
//  AnimatedCollectionViewLayoutWrapper.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class CubeAnimatedCollectionView: UICollectionView {
    
    static func makeLayout() -> UICollectionViewLayout {
        let layout = AnimatedCollectionViewLayout()
        layout.animator = CubeAttributesAnimator()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func commonInit() {
        self.collectionViewLayout = CubeAnimatedCollectionView.makeLayout()
    }
    
    init() {
        let layout = CubeAnimatedCollectionView.makeLayout()
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
