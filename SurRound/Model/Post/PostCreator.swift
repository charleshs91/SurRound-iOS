//
//  PostCreator.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PostCreator {
  
  static func documentID() -> String {
    return Firestore.firestore().collection("posts").document().documentID
  }
  
  func createPost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
    
    let ref = Firestore.firestore().collection("posts").document(post.id)
    // Create post in DB
    do {
      try ref.setData(from: post, merge: true, encoder: Firestore.Encoder()) { (error) in
        guard error == nil else {
          completion(.failure(error!))
          return
        }
        completion(.success(()))
      }
    } catch {
      completion(.failure(error))
    }
  }
  
  func createPostWithImage(post: Post, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
    
    let ref = Firestore.firestore().collection("posts").document(post.id)
    // Upload image
    let manager = StorageManager()
    manager.uploadImage(image, filename: NSUUID().uuidString) { (url) in
      guard let url = url else { return }
      ref.setData([
        "media_type": "image",
        "media_link": url.absoluteString
      ], merge: true)
    }
    // Create post in DB
    do {
      try ref.setData(from: post, merge: true, encoder: Firestore.Encoder()) { (error) in
        guard error == nil else {
          completion(.failure(error!))
          return
        }
        completion(.success(()))
      }
    } catch {
      completion(.failure(error))
    }
  }
  
}
