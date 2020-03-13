//
//  ReviewManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/16.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias ReviewsResult = (Result<[Review], Error>) -> Void

class ReviewManager {
    
    static let shared = ReviewManager()
    
    private let dataFetcher: DataFetching
    private let notificationManager: NotificationManager
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
        self.notificationManager = NotificationManager()
    }
    
    func fetchAllReviews(postId: String, completion: @escaping ReviewsResult) {
        
        let reviewRef = FirestoreDB.reviews(postId: postId)
            .order(by: Review.CodingKeys.createdTime.rawValue, descending: false)
        
        dataFetcher.fetch(from: reviewRef) { (result) in
            switch result {
            case .success(let documents):
                if let reviews = GenericParser.parse(documents, of: Review.self) {
                    completion(.success(reviews))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendReview(postAuthorId: String, postId: String, replyAuthor: Author, text: String,
                    completion: @escaping (Error?) -> Void) {
        
        let reviewRef = FirestoreDB.reviews(postId: postId).document()
        let review = Review(id: reviewRef.documentID, postId: postId, author: replyAuthor, text: text)
        do {
            try reviewRef.setData(from: review, merge: true, encoder: .init()) { [weak self] (error) in
                if let error = error {
                    completion(error)
                    return
                }
                self?.incrementReplyCount(postId: postId)
                
                // Assert that post's author and reply's author are different
                guard postAuthorId != replyAuthor.uid else {
                    completion(nil)
                    return
                }
                
                let notification = SRNotification(type: "reply",
                                                  senderName: replyAuthor.username,
                                                  senderId: replyAuthor.uid,
                                                  created: Date(),
                                                  postId: postId)
                self?.notificationManager.sendNotification(notification, receiverId: postAuthorId) { (error) in
                    guard error == nil else {
                        completion(error!)
                        return
                    }
                    completion(nil)
                }
            }
        } catch {
            completion(error)
        }
    }
    
    private func incrementReplyCount(postId: String) {
        
        let docRef = FirestoreDB.posts.document(postId)
        docRef.setData([Post.CodingKeys.replyCount.rawValue: FieldValue.increment(Int64(1))], merge: true)
    }
}
