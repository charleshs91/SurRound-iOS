//
//  FirestoreService.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirestoreServiceError: Error {
    
    case fetchingError
    case parsingError
}

class FirestoreDB {
    
    struct CollectionId {
        static let users = "users"
        static let posts = "posts"
        static let stories = "stories"
        static let reviews = "reviews"
        static let userPosts = "user_posts"
        static let userStories = "user_stories"
        static let notifications = "notifications"
    }

    static var users: CollectionReference {
        
        return Firestore.firestore().collection(CollectionId.users)
    }
    
    static var posts: CollectionReference {
        
        return Firestore.firestore().collection(CollectionId.posts)
    }
    
    static var stories: CollectionReference {
        
        return Firestore.firestore().collection(CollectionId.stories)
    }
    
    static func reviews(postId: String) -> CollectionReference {
        
        return posts.document(postId).collection(CollectionId.reviews)
    }
    
    static func userPosts(userId: String) -> CollectionReference {
        
        return users.document(userId).collection(CollectionId.userPosts)
    }
    
    static func userStories(userId: String) -> CollectionReference {
        
        return users.document(userId).collection(CollectionId.userStories)
    }
    
    static func notifications(userId: String) -> CollectionReference {
        
        return users.document(userId).collection(CollectionId.notifications)
    }
}
