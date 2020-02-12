//
//  ProfileViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            selectionView.dataSource = self
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    
    var userToDisplay: SRUser?
    
    private let tabTitle = ["My Posts", "Saved"]
    
    private var posts = [Post]()
    
    private var viewModels = [PostListCellViewModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let currentUser = AuthManager.shared.currentUser!
        
        fetchUserProfile(userToDisplay?.uid ?? currentUser.uid)
        fetchUserPost(userToDisplay?.uid ?? currentUser.uid)
        profileHeaderView.setupView(user: userToDisplay ?? currentUser)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = profileHeaderView.sizeThatFits(.zero)
        profileHeaderView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.width, height: size.height)
        tableView.contentInset = UIEdgeInsets(top: size.height, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - User Actions
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        let isSuccessSignOut = AuthManager.shared.signOut()
        
        if isSuccessSignOut {
            let authVC = UIStoryboard.auth.instantiateInitialViewController()
            AppDelegate.shared.window?.rootViewController = authVC
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
        tableView.registerCellWithNib(withCellClass: TextPostListCell.self)
        tableView.registerCellWithNib(withCellClass: VideoPostListCell.self)
        
        let guide = view.safeAreaLayoutGuide
        tableView.anchor(top: guide.topAnchor, left: guide.leftAnchor, bottom: guide.bottomAnchor, right: guide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        tableView.tableFooterView = UIView()
    }
    
    private func fetchUserPost(_ uid: String) {
        
        posts.removeAll()
        viewModels.removeAll()
        
        guard let user = AuthManager.shared.currentUser else { return }
        PostManager().fetchPostOfUsers(uids: [user.uid]) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts.append(contentsOf: posts)
                self?.viewModels.append(contentsOf: ViewModelFactory.viewModelFromPosts(posts))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchUserProfile(_ uid: String) {
        let manager = ProfileManager()
        
        manager.fetchProfile(user: uid) { profile in
            guard let profile = profile else { return }
            
            print(profile)
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModels[indexPath.row]
        
        let cell = viewModel.cellType.makeCell(tableView, at: indexPath)
        guard let postListCell = cell as? PostListCell else {
            return cell
        }
        
        postListCell.layoutCell(with: viewModel)
        return postListCell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

extension ProfileViewController: SelectionViewDataSource {
    
    func numberOfSelectionItems(_ selectionView: SelectionView) -> Int {
        
        return 2
    }
    
    func selectionItemTitle(_ selectionView: SelectionView, for index: Int) -> String {
        
        return tabTitle[index]
    }
    
    func textColor(_ selectionView: SelectionView) -> UIColor {
        
        return .systemGray2
    }
    
    func indicatorLineColor(_ selectionView: SelectionView) -> UIColor {
        return .red
    }
}

extension ProfileViewController: SelectionViewDelegate {
    
}
