//
//  ReviewManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/16.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

typealias ReviewsResult = (Result<[Review], Error>) -> Void

class ReviewManager {
    
    private var dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchAllReviews(postId: String, completion: @escaping ReviewsResult) {
        
        let reviewRef = FirestoreDB.reviews(of: postId)
        
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
    
    func sendReview(postID: String, author: Author, text: String, completion: @escaping (Error?) -> Void) {
        
        let reviewRef = FirestoreDB.reviews(of: postID).document()
        
        let reviewObject = Review(id: reviewRef.documentID,
                                  postId: postID,
                                  author: author,
                                  text: text)
        do {
            try reviewRef.setData(from: reviewObject, merge: true, encoder: .init()) { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
}
