//
//  NotificationManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias NotificationsResult = (Result<[SRNotification], Error>) -> Void

class NotificationManager {
    
    private var dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchNotifications(userId: String, completion: @escaping NotificationsResult) {
        
        let query = FirestoreDB.notifications(userId: userId)
        
        dataFetcher.fetch(from: query) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let documents):
                if let notifications = GenericParser.parse(documents, of: SRNotification.self) {
                    DispatchQueue.main.async {                    
                        completion(.success(notifications))
                    }
                }
            }
        }
    }
}
