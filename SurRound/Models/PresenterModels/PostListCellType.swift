//
//  PostListCellProtocol.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostListCell: UITableViewCell {
    
    func layoutCell(with viewModel: PostListCellViewModel) {
        
        fatalError("Class inheritting `PostListCell` must override `layoutCell` method.")
    }
}

enum PostListCellType {
    
    case image
    case text
    case video
    
    func makeCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    
        switch self {
        case .image:
            return tableView.dequeueReusableCell(
                withIdentifier: ImagePostListCell.reuseIdentifier, for: indexPath)
            
        case .text:
            return tableView.dequeueReusableCell(
                withIdentifier: TextPostListCell.reuseIdentifier, for: indexPath)
            
        case .video:
            return tableView.dequeueReusableCell(
                withIdentifier: NewPostMapCell.reuseIdentifier, for: indexPath)
        }
    }
}
