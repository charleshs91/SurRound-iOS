//
//  NotificationViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class NotificationViewModel {
    
    var numberOfItems: Int {
        return notificationCellViewModels.value.count
    }
    
    private let notificationManager: NotificationManager
    private var notificationCellViewModels: Observable<[NotificationCellViewModel]> = .init([])
    
    init() {
        self.notificationManager = NotificationManager()
        fetchNotifications()
    }
    
    deinit {
        unbind()
    }
    
    // MARK: Public Methods
    func bind(handler: @escaping ([NotificationCellViewModel]) -> Void) {
        
        notificationCellViewModels.addObserver(onChanged: handler)
    }
    
    func unbind() {
        
        notificationCellViewModels.removeObserver()
    }
    
    func getCellViewModelAt(index: Int) -> NotificationCellViewModel? {
        
        guard index >= 0 && index < self.notificationCellViewModels.value.count else {
            return nil
        }
        return self.notificationCellViewModels.value[index]
    }
    
    // MARK: - Private Methods
    private func fetchNotifications() {
        
        guard let userId = AuthManager.shared.currentUser?.uid else {
            return
        }
        
        notificationCellViewModels.value.removeAll()
        notificationManager.fetchNotifications(userId: userId) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let notifications):
                let cellViewModels = notifications.map { notification in
                    return NotificationCellViewModel(notification: notification)
                }
                strongSelf.notificationCellViewModels.value.append(contentsOf: cellViewModels)
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
}
