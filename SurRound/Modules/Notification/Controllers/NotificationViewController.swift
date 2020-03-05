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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fireUpViewModel()
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
        
        viewModel.postImage == nil
            ? notificationCell.hidePostImage()
            : notificationCell.showPostImage()
        
        notificationCell.setupCell(viewModel)
        
        return notificationCell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
