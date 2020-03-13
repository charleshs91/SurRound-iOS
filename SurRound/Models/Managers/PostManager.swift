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

// MARK: - Protocols
protocol PostCreatable {
    
    func createPost(_ post: Post, image: UIImage?,
                    completion: @escaping (Result<Void, Error>) -> Void)
}

protocol PostLikable {
    
    func likePost(postId: String, userId: String,
                  completion: @escaping (Result<Void, Error>) -> Void)
    
    func dislikePost(postId: String, userId: String,
                     completion: @escaping (Result<Void, Error>) -> Void)
}

protocol PostFetchable {
    
    func fetchSinglePost(_ postId: String,
                         completion: @escaping (Result<Post, Error>) -> Void)
    
    func fetchPostList(listCategory: ListCategory, blockingUserList: [String],
                       completion: @escaping PostsResult)
}

enum ListCategory {
    
    case none
    case byAuthor(authorList: [String])
    case byLikedCounts
    case byLeastDistance(coordinate: Coordinate)
}

typealias PostsResult = (Result<[Post], DataFetchingError>) -> Void

class PostManager {
    
    static let shared = PostManager()
    
    private let dataFetcher: DataFetching
    private let storageManager: StorageManager
    
    private init(dataFetcher: DataFetching = GenericFetcher()) {
        
        self.dataFetcher = dataFetcher
        self.storageManager = StorageManager()
    }
}

// MARK: - PostLikable
extension PostManager: PostLikable {
    
    func likePost(postId: String, userId: String,
                  completion: @escaping (Result<Void, Error>) -> Void) {
        
        executeLikeAction(postId: postId, userId: userId, isLiking: true, completion: completion)
    }
    
    func dislikePost(postId: String, userId: String,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        
        executeLikeAction(postId: postId, userId: userId, isLiking: false, completion: completion)
    }
    
    private func executeLikeAction(postId: String, userId: String, isLiking: Bool,
                                   completion: @escaping (Result<Void, Error>) -> Void) {
        
        let docRef = FirestoreDB.posts.document(postId)
        
        let value = isLiking ? 1 : -1
        
        docRef.setData([
            Post.CodingKeys.likedBy.rawValue: FieldValue.arrayRemove([userId]),
            Post.CodingKeys.likeCount.rawValue: FieldValue.increment(Int64(value))
        ], merge: true) { (error) in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(()))
        }
    }
}

// MARK: - PostFetchable
extension PostManager: PostFetchable {
    
    func fetchPostList(listCategory: ListCategory, blockingUserList: [String],
                       completion: @escaping PostsResult) {
        
        let collection = FirestoreDB.posts
        
        switch listCategory {
        case .none:
            let query = collection.order(by: Post.CodingKeys.createdTime.rawValue, descending: true)
            fetchData(from: query, blockingUsers: blockingUserList, completion: completion)
            
        case .byAuthor(let authorList):
            let query = collection.whereField(Post.CodingKeys.authorId.rawValue, in: authorList)
                                  .order(by: Post.CodingKeys.createdTime.rawValue, descending: true)
            fetchData(from: query, blockingUsers: blockingUserList, completion: completion)
            
        case .byLikedCounts:
            fetchTrendingPost(completion: completion)
            
        case .byLeastDistance(let coordinate):
            fetchNearestPost(coordinate: coordinate, completion: completion)

        }
    }
    
    func fetchSinglePost(_ postId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        
        let docRef = FirestoreDB.posts.document(postId)
        
        dataFetcher.fetch(from: docRef) { (result) in
            
            switch result {
            case .success(let document):
                guard let post = GenericParser.parse(document, of: Post.self) else {
                    completion(.failure(DataFetchingError.parsingError))
                    return
                }
                completion(.success(post))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchNearestPost(coordinate: Coordinate, completion: @escaping PostsResult) {
        
        let query = FirestoreDB.posts
            .whereField(Post.CodingKeys.latitude.rawValue, isGreaterThanOrEqualTo: coordinate.latitude - 1)
            .whereField(Post.CodingKeys.latitude.rawValue, isLessThanOrEqualTo: coordinate.latitude + 1)
        
        fetchData(from: query) { (result) in
            switch result {
            case .success(let posts):
                let sortedPosts = PostManager.sortByDistance(reference: coordinate, posts: posts)
                completion(.success(sortedPosts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchTrendingPost(completion: @escaping PostsResult) {
        
        let query = FirestoreDB.posts
            .order(by: Post.CodingKeys.likeCount.rawValue, descending: true)
        
        fetchData(from: query) { (result) in
            
            switch result {
            case .success(let posts):
                let filteredPosts = posts.filter { (post) -> Bool in
                    return post.mediaLink != nil
                }
                completion(.success(filteredPosts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchData(from query: Query, blockingUsers: [String] = [], completion: @escaping PostsResult) {
        
        dataFetcher.fetch(from: query) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let documents):
                guard let posts = GenericParser.parse(documents, of: Post.self) else {
                    DispatchQueue.main.async {
                        completion(.failure(.parsingError))
                    }
                    return
                }
                
                let processedPosts = strongSelf.filterByUserList(originalPosts: posts, userList: blockingUsers)
                DispatchQueue.main.async {
                    completion(.success(processedPosts))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func filterByUserList(originalPosts: [Post], userList: [String]) -> [Post] {
        
        guard userList.count > 0 else {
            return originalPosts
        }
        
        let filteredPosts = originalPosts.filter { post in
            return !userList.contains(post.authorId)
        }
        return filteredPosts
    }
}

// MARK: - PostCreatable
extension PostManager: PostCreatable {
    
    func createPost(_ post: Post,
                    image: UIImage? = nil,
                    completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard AuthManager.shared.currentUser != nil else { return }
        var post = post
        if image != nil {
            storageManager.uploadImage(image!, filename: post.id) { [weak self] (url) in
                guard let url = url else { return }
                post.mediaType = "image"
                post.mediaLink = url.absoluteString
                self?._create(post, completion: completion)
            }
        } else {
            _create(post, completion: completion)
        }
    }
    
    private func _create(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let user = AuthManager.shared.currentUser else { return }
        let documentRef = FirestoreDB.posts.document(post.id)
        do {
            try documentRef.setData(from: post, merge: true, encoder: Firestore.Encoder()) { error in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                UserService.attachPost(user: user, postRef: documentRef)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Static Functions
extension PostManager {
    
    static func documentID() -> String {
        
        return FirestoreDB.posts.document().documentID
    }
    
    static func sortByDistance(reference: Coordinate, posts: [Post]) -> [Post] {
        
        var distanceMap: [Post: Double] = [:]
        posts.forEach { post in
            let distance = PlaceManager.calculateDistance(post.place.coordinate, reference: reference)
            distanceMap[post] = distance
        }
        let sortedMap = distanceMap.sorted { (lhs, rls) -> Bool in
            return lhs.value <= rls.value
        }
        let sortedPosts = sortedMap.map { $0.key }
        
        return sortedPosts
    }
}
