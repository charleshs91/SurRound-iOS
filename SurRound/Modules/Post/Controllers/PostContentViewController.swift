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
    
    deinit {
        print("$ PostContentViewController deinit")
    }
    
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
            DispatchQueue.main.async { [weak self] in
                self?.postContentView.tableView.reloadData()
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
            replyTextView.delegate = self
            replyTextView.layer.cornerRadius = 8
        }
    }
    
    private let manager = ProfileManager()
    
    private let sections: [PostDetailSectionType] = [.content, .review]
    
    private let cellItems: [PostBodyCellType] = [.info, .body]
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postContentView.layoutView(from: post)
        navigationController?.navigationBar.isHidden = true
        updateReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - User Actions
    @IBAction func didTapClose(_ sender: UIButton) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReply(_ sender: UIButton) {
        
        guard let currentUser = AuthManager.shared.currentUser else { return }
        let author = Author(currentUser)
        
        SRProgressHUD.showLoading()
        ReviewManager.shared.sendReview(postAuthorId: post.author.uid, postId: post.id, replyAuthor: author, text: replyTextView.text) { [weak self] (error) in
            
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
    private func showMoreActions() {
        
        let alertVC = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { [unowned self] _ in
            
            SRProgressHUD.showLoading()
            self.manager.blockUser(targetUid: self.post.authorId) { (result) in
                SRProgressHUD.dismiss()
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    SRProgressHUD.showSuccess(text: "We've received your report on the current user.")
                }
            }
        }
        
        let blockAction = UIAlertAction(title: "Block", style: .default) { [unowned self] _ in
            
            SRProgressHUD.showLoading()
            self.manager.blockUser(targetUid: self.post.authorId) { (result) in
                SRProgressHUD.dismiss()
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    SRProgressHUD.showSuccess(text: "Successful. You'll no longer see content from this user.")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        [reportAction, blockAction, cancelAction].forEach {
            alertVC.addAction($0)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
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
    
    func tapOnUser(userToDisplay: SRUser) {
        
        guard
            let nav = UIStoryboard.profile.instantiateInitialViewController() as? UINavigationController,
            let profileVC = nav.topViewController as? ProfileViewController
            else {
                return
        }
        
        profileVC.userToDisplay = userToDisplay
        navigationController?.pushViewController(profileVC, animated: true)
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
            case .info:
                guard let infoCell = cell as? PostInfoTableViewCell else {
                    break
                }
                infoCell.setupCell(with: post!, userProfileHandler: { [weak self] user in
                    
                    self?.tapOnUser(userToDisplay: user)
                })
                
            case .body:
                guard let bodyCell = cell as? PostBodyCell else {
                    break
                }
                bodyCell.configure(with: postBodyViewModel)
                bodyCell.onMoreActionTapped = { [weak self] in
                    self?.showMoreActions()
                }
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
