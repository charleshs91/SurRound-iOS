//
//  PostManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias PostsResult = (Result<[Post], FirestoreServiceError>) -> Void

class PostManager: DataFetching {
    
    // Ask database for an unique id.
    static func documentID() -> String {
        return Firestore.firestore().collection("posts").document().documentID
    }
    
    private let dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func sendReview(postID: String, author: Author, text: String, completion: @escaping (Error?) -> Void) {
        
        let reviewRef = FirestoreService.posts.document(postID).collection("reviews").document()
        
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
    
    func fetchPostOfUsers(uids: [String], completion: @escaping PostsResult) {

        let query = FirestoreService.posts
            .whereField(Post.CodingKeys.authorId.rawValue, in: uids)
            .order(by: Post.CodingKeys.createdTime.rawValue, descending: false)
        
        dataFetcher.fetch(from: query) { result in
            
            switch result {
            case .success(let documents):
                guard let posts = GenericParser.parse(documents, of: Post.self) else {
                    completion(.failure(.parsingError))
                    return
                }
                completion(.success(posts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllPost(completion: @escaping PostsResult) {
        
        let query = FirestoreService.posts.order(by: "created_time", descending: true)
        
        dataFetcher.fetch(from: query) { result in
            
            switch result {
            case .success(let documents):
                guard let posts = GenericParser.parse(documents, of: Post.self) else {
                    completion(.failure(.parsingError))
                    return
                }
                completion(.success(posts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createPost(_ post: Post, image: UIImage? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let documentRef = Firestore.firestore().collection("posts").document(post.id)
        
        do {
            try documentRef.setData(from: post, merge: true, encoder: Firestore.Encoder()) { error in
                
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                if let user = AuthManager.shared.currentUser {
                    UserDBService.attachPost(user: user, postRef: documentRef)
                }
                if let imageToAttach = image {
                    self.attachImage(to: documentRef, image: imageToAttach)
                }
                
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func attachImage(to documentRef: DocumentReference, image: UIImage) {
        
        StorageManager().uploadImage(image, filename: NSUUID().uuidString) { url in
            guard let url = url else { return }
            
            documentRef.setData([
                "media_type": "image",
                "media_link": url.absoluteString
            ], merge: true)
        }
    }
}
