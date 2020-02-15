//
//  PostContentViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class PostContentViewController: UIViewController {
    
    var post: Post!
    
    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.isEnabled = false
        }
    }

    @IBOutlet weak var postContentView: PostContentView!
    
    @IBOutlet weak var replyTextView: KMPlaceholderTextView! {
        didSet {
            replyTextView.placeholder = "輸入回覆內容"
            replyTextView.delegate = self
        }
    }
    
    let sections: [PostDetailSectionType] = [.content, .review]
    let cellItems: [PostBodyCellType] = [.location, .body]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postContentView.layoutView(from: post)
    }
    
    // MARK: - User Actions
    @IBAction func didTapClose(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReply(_ sender: UIButton) {
        
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
            return 10
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
                guard let locationCell = cell as? PostInfoTableViewCell else {
                    break
                }
                locationCell.setupCell(with: post!)
                
            case .body:
                guard let bodyCell = cell as? BodyTableViewCell else {
                    break
                }
                bodyCell.descriptionLabel.text = post?.text
            }
            
            return cell
            
        case .review:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostReplyCell.reuseIdentifier, for: indexPath) as? PostReplyCell else {
                return UITableViewCell()
            }
            cell.usernameLabel.text = "Charles"
            cell.replyTextLabel.text = "Why so serious????????"
            cell.datetimeLabel.text = "\(indexPath.row) days ago"
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension PostContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

extension PostContentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        replyButton.isEnabled = !textView.isEmpty
    }
}
