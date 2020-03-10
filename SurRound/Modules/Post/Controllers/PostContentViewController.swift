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
            guard let currentUser = AuthManager.shared.currentUser else { return }
            postContentViewModel = PostContentViewModel(post: post, viewerUser: currentUser)
        }
    }

    var postContentViewModel: PostContentViewModelInterface!
    
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
    
    @IBAction func sendReply(_ sender: UIButton) {
        
        SRProgressHUD.showLoading()
        postContentViewModel.reply(text: replyTextView.text) { [weak self] result in
            
            SRProgressHUD.dismiss()
            switch result {
            case .success:
                SRProgressHUD.showSuccess(text: "Reply Success")
                self?.replyTextView.clear()
                self?.updateReviews {
                    self?.postContentView.tableView.scrollToBottom(animated: true)
                }
            case .failure(let error):
                SRProgressHUD.showFailure(text: "Reply Failure: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Private Methods
    private func showMoreActions() {
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Report", style: .default) { [unowned self] _ in
            self.postContentViewModel.reportPost()
        })
        
        alertVC.addAction(UIAlertAction(title: "Block", style: .default) { [unowned self] _ in
            self.postContentViewModel.blockUser()
        })

        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        
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
                infoCell.configure(with: postContentViewModel)
                infoCell.delegate = self
                
            case .body:
                guard let bodyCell = cell as? PostBodyCell else {
                    break
                }
                bodyCell.configure(with: postContentViewModel)
                bodyCell.delegate = self
            }
            return cell
            
        case .review:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                PostReplyCell.reuseIdentifier, for: indexPath) as? PostReplyCell else {
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

// MARK: - PostInfoTableViewCellDelegate
extension PostContentViewController: PostInfoTableViewCellDelegate {
    
    func didTapOnUser(_ cell: PostInfoTableViewCell, user: SRUser) {
        
        guard
            let nav = UIStoryboard.profile.instantiateInitialViewController() as? UINavigationController,
            let profileVC = nav.topViewController as? ProfileViewController
            else {
                return
        }
        
        profileVC.userToDisplay = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - PostBodyCellDelegate
extension PostContentViewController: PostBodyCellDelegate {
    
    func didTapLikeButton(_ cell: PostBodyCell) {
        
        postContentViewModel.tapLikeButton { result in
            switch result {
            case .success:
                SRProgressHUD.showSuccess()
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    func didTapReplyButton(_ cell: PostBodyCell) {
        
        replyTextView.becomeFirstResponder()
        postContentView.tableView.scrollToBottom(animated: true)
    }
    
    func didTapMoreAction(_ cell: PostBodyCell) {
        
        showMoreActions()
    }
    
}
