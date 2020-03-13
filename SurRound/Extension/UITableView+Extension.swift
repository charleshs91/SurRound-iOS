//
//  UITableView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

// MARK: - Properties
extension UITableView {
    
    /// Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

    /// Index of last section in tableView.
    var lastSection: Int? {
        
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }
}

// MARK: - Methods
extension UITableView {
    
    /// IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        
        guard numberOfSections > 0, section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    /// Safely scroll to possibly invalid IndexPath
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to
    ///   - scrollPosition: Scroll position
    ///   - animated: Whether to animate or not
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
