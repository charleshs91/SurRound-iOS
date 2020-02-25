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
    
    func fetchNotifications(userId: String,
                            completion: @escaping NotificationsResult) {
        
        let query = FirestoreDB.notifications(userId: userId)
        
        dataFetcher.fetch(from: query) { (result) in
            
            switch result {
            case .success(let documents):
                guard let notifications = GenericParser.parse(documents,
                                                              of: SRNotification.self) else {
                    completion(.failure(DataFetchingError.parsingError))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(notifications))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendNotification(_ notification: SRNotification,
                          receiverId: String,
                          completion: @escaping (Error?) -> Void) {
        
        let docRef = FirestoreDB.notifications(userId: receiverId)
        do {
            _ = try docRef.addDocument(from: notification, encoder: .init()) { (error) in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}
