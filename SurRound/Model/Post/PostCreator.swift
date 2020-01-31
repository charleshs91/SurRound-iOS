//
//  PostCreator.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostCreator {
    
    static func documentID() -> String {
        
        return Firestore.firestore().collection("posts").document().documentID
    }
    
    func createPost(_ post: Post, image: UIImage? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let documentRef = Firestore.firestore().collection("posts").document(post.id)
        
        do {
            try documentRef.setData(from: post,
                                    merge: true,
                                    encoder: Firestore.Encoder()) { [weak self] error in
                
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                if let imageToAttach = image {
                    self?.attachImage(to: documentRef, image: imageToAttach)
                }
                
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func attachImage(to documentRef: DocumentReference, image: UIImage) {
        
        let manager = StorageManager()
        
        manager.uploadImage(image, filename: NSUUID().uuidString) { url in
            
            guard let url = url else { return }
            
            documentRef.setData([
                "media_type": "image",
                "media_link": url.absoluteString
            ], merge: true)
        }
    }
}
