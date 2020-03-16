//
//  FollowingListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class FollowingListViewController: SRBaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellWithNib(withCellClass: TextPostListCell.self)
            tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
            tableView.addHeaderRefreshing { [weak self] in
                self?.refreshPosts()
            }
            tableView.separatorStyle = .none
        }
    }
    
    private var viewModels: [PostListCellViewModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let postFetcher: PostFetchable = PostManager.shared
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts),
                                               name: Constant.NotificationId.newPost, object: nil)
    }
    
    // MARK: - Private Methods
    @objc func refreshPosts() {
        
        guard
            let userProfile = AuthManager.shared.userProfile,
            let viewerUser = AuthManager.shared.currentUser
        else {
            return
        }
        
        viewModels.removeAll()
        
        let listCategory: ListCategory
        
        if userProfile.following.count == 0 {
            listCategory = .none
        } else {
            listCategory = .byAuthor(authorList: userProfile.following)
            tableView.tableHeaderView = nil
        }
        
        postFetcher.fetchPostList(
            listCategory: listCategory,
            blockingUserList: userProfile.blocking
        ) { [weak self] result in
            
            self?.handlePostsResult(result: result, viewerUser: viewerUser)
        }
    }
    
    private func handlePostsResult(result: Result<[Post], DataFetchingError>, viewerUser: SRUser) {
        
        tableView.endHeaderRefreshing()
        
        switch result {
        case .success(let posts):
            viewModels.append(contentsOf: ViewModelFactory.viewModelFromPosts(posts, viewerUser: viewerUser))
            
        case .failure(let error):
            print(error)
            SRProgressHUD.showFailure(text: error.localizedDescription)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension FollowingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModels[indexPath.row]
        
        let cell = viewModel.cellType.makeCell(tableView, at: indexPath)
        guard let postListCell = cell as? PostListCell else {
            return cell
        }
        viewModel.onRequestUserProfile = { [weak self] user in
            
            let profileVC = ProfileViewController.instantiate()
            profileVC.userToDisplay = user
            self?.show(profileVC, sender: nil)
        }
        
        postListCell.configure(with: viewModel)
        return postListCell
    }
}

// MARK: - UITableViewDelegate
extension FollowingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard
            let nav = UIStoryboard.post.instantiateInitialViewController() as? UINavigationController,
            let postDetailVC = nav.topViewController as? PostContentViewController,
            let currentUser = AuthManager.shared.currentUser
        else {
            return
        }
        
        let post = viewModels[indexPath.row].post
        postDetailVC.postContentViewModel = PostContentViewModel(post: post, viewerUser: currentUser)
        postDetailVC.postContentViewModel.didChangeLikeStatus = { [weak self] status in
            self?.viewModels[indexPath.row].isLiked.value = status
            self?.viewModels[indexPath.row].increaseLikeCount(value: status ? 1 : -1)
        }
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
}
