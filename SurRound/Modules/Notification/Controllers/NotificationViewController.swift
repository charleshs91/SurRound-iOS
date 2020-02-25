//
//  NotificationViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    private let manager = NotificationManager()
    
    private var data: [SRNotification] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData()
    }
    
    private func fetchData() {
        
        guard let userId = AuthManager.shared.currentUser?.uid else { return }
        
        data.removeAll()
        
        manager.fetchNotifications(userId: userId) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
                
            case .success(let notifications):
                self?.data.append(contentsOf: notifications)
            }
        }
    }
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            NotificationCell.reuseIdentifier, for: indexPath)
        guard let notificationCell = cell as? NotificationCell else { return cell }
        if indexPath.row % 2 == 0 {
            notificationCell.postImageView.isHidden = true
        }
        return notificationCell
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
