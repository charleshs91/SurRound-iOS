//
//  FollowingListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class FollowingListViewController: UIViewController {
    
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
    
    private var posts: [Post] = []
    
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
        
        guard let userProfile = AuthManager.shared.userProfile else {
            return
        }
        posts.removeAll()
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
            
            self?.handlePostsResult(result: result)
        }
    }
    
    private func handlePostsResult(result: Result<[Post], DataFetchingError>) {
        
        tableView.endHeaderRefreshing()
        
        switch result {
        case .success(let posts):
            self.posts.append(contentsOf: posts)
            viewModels.append(contentsOf: ViewModelFactory.viewModelFromPosts(posts))
            
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
        
        postListCell.layoutCell(with: viewModel)
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
            let postDetailVC = nav.topViewController as? PostContentViewController else { return }
        postDetailVC.post = posts[indexPath.row]
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
}
