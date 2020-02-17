//
//  PostContentModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

enum PostDetailSectionType {
    
    case content
    case review
}

enum PostBodyCellType {
    
    case location
    case body
    
    func makeCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        switch self {
        case .location:
            return tableView.dequeueReusableCell(
                withIdentifier: PostInfoTableViewCell.reuseIdentifier, for: indexPath)
            
        case .body:
            return tableView.dequeueReusableCell(
                withIdentifier: PostBodyCell.reuseIdentifier, for: indexPath)
        }
    }
}
