//
//  UserListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

enum UserListType {
    
    case following(SRUserProfile)
    
    case follower(SRUserProfile)
    
    var uids: [String] {
        
        switch self {
            
        case .follower(let profile):
            return profile.follower
            
        case .following(let profile):
            return profile.following
        }
    }
    
    var title: String {
        switch self {
        case .follower:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}

class UserTableViewController: UITableViewController {
    
    var listType: UserListType!
    
    private var userList: [SRUser] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        fetchUserList()
        
        navigationItem.title = listType.title
    }
    
    func fetchUserList() {
        
        guard listType.uids.count > 0 else {
            return
        }
        
        let manager = ProfileManager()
        
        manager.fetchUserList(uids: listType.uids) { [weak self] srUsers in
            
            self?.userList = srUsers
        }
    }
    
    private func onCellTapMoreButton(_ cell: UserListTableViewCell) {
        
        let alertVC = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { _ in
            print("檢舉你")
        }
        
        let blockAction = UIAlertAction(title: "Block", style: .default) { _ in
            print("封鎖你")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        [reportAction, blockAction, cancelAction].forEach {
            alertVC.addAction($0)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension UserTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        guard let userCell = cell as? UserListTableViewCell else { return cell }
        
        let user = userList[indexPath.row]
        userCell.setupCell(user: user)
        return userCell
    }
}

// MARK: - UITableViewDelegate
extension UserTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let profileVC = ProfileViewController.storyInstance() else { return }
        
        let selectedUser = userList[indexPath.row]
        profileVC.userToDisplay = selectedUser
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
