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
    
    var post: Post! {
        didSet {
            postBodyViewModel = PostBodyViewModel(post: post, onReply: { [weak self] in
                self?.replyTextView.becomeFirstResponder()
                self?.postContentView.tableView.scrollToBottom(animated: true)
            })
        }
    }
    
    var postBodyViewModel: PostBodyViewModel!
    
    var reviews = [Review]() {
        didSet {
            DispatchQueue.main.async {
                self.postContentView.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var postContentView: PostContentView!
    
    @IBOutlet weak var replyTextView: KMPlaceholderTextView! {
        didSet {
            replyTextView.placeholder = "輸入回覆內容"
            replyTextView.isScrollEnabled = false
            replyTextView.delegate = self
            replyTextView.layer.cornerRadius = 8
        }
    }
    
    let sections: [PostDetailSectionType] = [.content, .review]
    
    let cellItems: [PostBodyCellType] = [.location, .body]
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postContentView.layoutView(from: post)
        
        updateReviews()
    }
    
    // MARK: - User Actions
    @IBAction func didTapClose(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReply(_ sender: UIButton) {
        
        guard let currentUser = AuthManager.shared.currentUser else {
            return
        }
        
        let author = Author(currentUser)
        let manager = ReviewManager()
        
        SRProgressHUD.showLoading()
        manager.sendReview(postId: post.id, author: author, text: replyTextView.text) { [weak self] (error) in
            
            SRProgressHUD.dismiss()
            
            if error == nil {
                SRProgressHUD.showSuccess(text: "留言成功")
                self?.replyTextView.clear()
                self?.updateReviews {
                    self?.postContentView.tableView.scrollToBottom(animated: true)
                }
            }
        }
    }
    
    // MARK: Private Methods
    private func updateReviews(completion: (() -> Void)? = nil) {
        
        ReviewManager().fetchAllReviews(postId: post.id) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
                
            case .success(let reviews):
                self?.reviews = reviews
                completion?()
            }
        }
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
            return reviews.count
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
                guard let bodyCell = cell as? PostBodyCell else {
                    break
                }
                bodyCell.configure(with: postBodyViewModel)
            }
            
            return cell
            
        case .review:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostReplyCell.reuseIdentifier, for: indexPath) as? PostReplyCell else {
                return UITableViewCell()
            }
            
            cell.updateCell(reviews[indexPath.row])
            
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

// MARK: - UITextViewDelegate
extension PostContentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        replyButton.isEnabled = !textView.isEmpty
    }
}
