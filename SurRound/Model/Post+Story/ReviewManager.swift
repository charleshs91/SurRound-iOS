//
//  ReviewManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/16.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

typealias ReviewsResult = (Result<[Review], Error>) -> Void

class ReviewManager {
    
    private var dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
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
    
    func sendReview(postId: String, author: Author, text: String,
                    completion: @escaping (Error?) -> Void) {
        
        let reviewRef = FirestoreDB.reviews(postId: postId).document()
        
        let review = Review(id: reviewRef.documentID,
                            postId: postId,
                            author: author,
                            text: text)
        do {
            try reviewRef.setData(from: review, merge: true, encoder: .init()) { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.incrementReplyCount(postId: postId)
                completion(nil)
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
