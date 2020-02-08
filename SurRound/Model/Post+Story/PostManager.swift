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

typealias PostsResult = (Result<[Post], Error>) -> Void

class PostManager {
    
    // Ask database for an unique id.
    static func documentID() -> String {
        return Firestore.firestore().collection("posts").document().documentID
    }
    
    deinit {
        debugPrint("$ deinit: PostManager")
    }
    
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
