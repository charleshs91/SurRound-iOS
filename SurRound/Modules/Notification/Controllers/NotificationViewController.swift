//
//  NotificationViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    var notificationViewModel: NotificationViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let notificationManager = NotificationManager()
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireUpViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func fireUpViewModel() {
        
        notificationViewModel = NotificationViewModel()
        
        notificationViewModel.bind { [weak self] _ in
            
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return notificationViewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath)
        
        guard
            let notificationCell = cell as? NotificationCell,
            let viewModel = notificationViewModel.getCellViewModelAt(index: indexPath.row)
        else {
            return cell
        }
        
        notificationCell.setupCell(viewModel)
        notificationCell.delegate = self
        
        return notificationCell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NotificationViewController: NotificationCellDelegate {
    
    func didTapOnAvatar(_ cell: NotificationCell, viewModel: NotificationCellViewModel) {
        
        let user = SRUser(uid: viewModel.uid, email: "", username: viewModel.username, avatar: viewModel.avatarImage.value)
        let profileVC = ProfileViewController.instantiate()
        profileVC.userToDisplay = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func didTapOnPostImage(_ cell: NotificationCell, viewModel: NotificationCellViewModel) {
        
        print("tapOnPostImage")
    }
}
