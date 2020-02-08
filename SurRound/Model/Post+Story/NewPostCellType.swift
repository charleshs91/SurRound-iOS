//
//  NewPostCellType.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

enum NewPostCellType {
    
    case text
    case media
    case map
    
    func makeCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        switch self {
        case .text:
            return tableView.dequeueReusableCell(
                withIdentifier: NewPostTextViewCell.reuseIdentifier, for: indexPath)
            
        case .media:
            return tableView.dequeueReusableCell(
                withIdentifier: NewPostMediaCell.reuseIdentifier, for: indexPath)
            
        case .map:
            return tableView.dequeueReusableCell(
                withIdentifier: NewPostMapCell.reuseIdentifier, for: indexPath)
        }
    }
}
