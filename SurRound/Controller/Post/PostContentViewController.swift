//
//  PostContentViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostContentViewController: UIViewController {
    
    @IBOutlet weak var postContentView: PostContentView!
    
    let sections: [PostDetailSectionType] = [.content, .review]
    let cellItems: [PostBodyCellType] = [.location, .body]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension PostContentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .content:
            return cellItems.count
            
        case .review:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .content:
            
            let cellType = cellItems[indexPath.row]
            let cell = cellType.makeCell(tableView, at: indexPath)
            
            switch cellType {
            case .location:
                
                guard let locationCell = cell as? LocationTableViewCell else { break }
                locationCell.placeLabel.text = "台北市政府"
                
            case .body:
                
                guard let bodyCell = cell as? BodyTableViewCell else { break }
                bodyCell.descriptionLabel.text = "柯Ｐ上班的欸所在"
            }
            
            return cell
            
        case .review:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension PostContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
