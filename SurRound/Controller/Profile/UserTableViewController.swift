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
    }
    
    func fetchUserList() {
        
        let manager = ProfileManager()
        
        manager.fetchUserList(uids: listType.uids) { [weak self] srUsers in
            
            self?.userList = srUsers
        }
        
    }
}

extension UserTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let userCell = cell as? UserListTableViewCell else {
            return cell
        }
        
        let user = userList[indexPath.row]
        
        userCell.setupCell(user: user)
        
        return userCell
    }
}
