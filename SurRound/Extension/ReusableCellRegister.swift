//
//  UITableView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/26.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    func registerHeaderFooterWithNib<T: UITableViewHeaderFooterView>(withHeaderFooterViewClass name: T.Type) {
        
        register(T.nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    func registerCell<T: UITableViewCell>(cellWithClass name: T.Type) {
        
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func registerCellWithNib<T: UITableViewCell>(withCellClass name: T.Type) {
        
        register(T.nib, forCellReuseIdentifier: String(describing: name))
    }
}

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    func registerCellWithNib<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        
        register(T.nib, forCellWithReuseIdentifier: String(describing: name))
    }
}