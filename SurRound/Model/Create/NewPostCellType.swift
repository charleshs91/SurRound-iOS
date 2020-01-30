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
  
  var cellHeight: CGFloat {
    switch self {
    case .text: return 135
    case .media: return 150
    case .map: return 220
    }
  }
  
  func makeCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
    switch self {
    case .text:
      return tableView.dequeueReusableCell(withIdentifier: NewPostTextViewCell.identifier, for: indexPath)
    case .media:
      return tableView.dequeueReusableCell(withIdentifier: NewPostMediaCell.identifier, for: indexPath)
    case .map:
      return tableView.dequeueReusableCell(withIdentifier: NewPostMapCell.identifier, for: indexPath)
    }
  }
}
