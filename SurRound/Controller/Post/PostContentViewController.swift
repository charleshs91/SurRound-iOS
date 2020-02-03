//
//  PostContentViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class PostContentViewController: UIViewController {
    
    var post: Post? {
        didSet {
            guard let postView = self.postContentView else { return }
            postView.layoutView(from: post)
            
            guard let tableView = postView.tableView else { return }
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var postContentView: PostContentView! {
        didSet {
            self.postContentView.layoutView(from: post)
        }
    }
    
    let sections: [PostDetailSectionType] = [.content, .review]
    let cellItems: [PostBodyCellType] = [.location, .body]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didTapClose(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - User Actions
    @IBAction func didTapClose(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
                
                locationCell.placeLabel.text = "Somewhere"
                
            case .body:
                
                guard let bodyCell = cell as? BodyTableViewCell else { break }
                
                bodyCell.descriptionLabel.text = post?.text
            }
            
            return cell
            
        case .review:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension PostContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat.zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
