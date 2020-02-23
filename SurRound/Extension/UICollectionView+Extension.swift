//
//  UICollectionView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/1.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func registerCellWithNib<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        
        let nib = UINib(nibName: String(describing: name), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }
}
