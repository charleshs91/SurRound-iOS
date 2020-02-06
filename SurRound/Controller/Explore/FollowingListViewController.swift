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
        didSet { setupTableView() }
    }
    
    var posts: [Post] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.beginHeaderRefreshing()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        
        tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
        
        tableView.addHeaderRefreshing { [weak self] in
            
            self?.refreshPosts {
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            }
        }
        
        tableView.separatorStyle = .none
    }
    
    private func refreshPosts(callback: @escaping () -> Void) {
        
        posts.removeAll()
        
        PostFetcher().fetchAllPosts { [weak self] result in
            
            switch result {
            case .success(let posts):
                self?.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    callback()
                }
                
            case .failure(let error):
                print(error)
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
}

extension FollowingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagePostListCell.identifier,
            for: indexPath) as? ImagePostListCell else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        let viewModel = PostListCellViewModel(post)
        cell.layoutCell(viewModel)
        
        return cell
    }
}

extension FollowingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let postDetailVC = UIStoryboard.post.instantiateInitialViewController() as? PostContentViewController else { return }
        
        postDetailVC.post = posts[indexPath.row]
        
        present(postDetailVC, animated: true, completion: nil)
    }
}
