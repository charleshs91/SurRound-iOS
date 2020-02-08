//
//  UITableViewCell+UICollectionViewCell+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol CellConfigurer: AnyObject {
    
    static var reuseIdentifier: String { get }
}

extension CellConfigurer {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellConfigurer { }
extension UICollectionViewCell: CellConfigurer { }
extension UITableViewHeaderFooterView: CellConfigurer { }
