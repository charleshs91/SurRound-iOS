//
//  PostFetcher.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias PostsResult = (Result<[Post], Error>) -> Void

class PostFetcher {
    
    deinit { debugPrint("$ deinit: PostFetcher") }
    
    func fetchAllPosts(completion: @escaping PostsResult) {
        
        Firestore.firestore().collection("posts")
            .order(by: "created_time", descending: true)
            .getDocuments { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var posts: [Post] = []
            
            snapshot.documents.forEach { document in
                do {
                    if let post = try document.data(as: Post.self, decoder: Firestore.Decoder()) {
                        posts.append(post)
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            completion(.success(posts))
        }
    }
}
