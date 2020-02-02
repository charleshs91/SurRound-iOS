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
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        PostFetcher().fetchAllPosts { [weak self] result in
            
            switch result {
            case .success(let posts):
                self?.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func setupTableView() {
        
        tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
        
        tableView.separatorStyle = .none
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
        
        self.present(postDetailVC, animated: true, completion: nil)
    }
}
