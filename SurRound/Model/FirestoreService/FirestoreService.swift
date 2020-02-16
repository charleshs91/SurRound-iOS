//
//  FirestoreService.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum FirestoreServiceError: Error {
    
    case fetchingError
    case parsingError
}

class FirestoreService {
    
    struct Collection {
        static let users = "users"
        static let posts = "posts"
        static let stories = "stories"
        static let reviews = "reviews"
        static let userPosts = "user_posts"
        static let userStories = "user_stories"
        static let notifications = "notifications"
    }
    
    class var users: CollectionReference {
        return Firestore.firestore().collection(Collection.users)
    }
    
    class var posts: CollectionReference {
        return Firestore.firestore().collection(Collection.posts)
    }
    
    class var stories: CollectionReference {
        return Firestore.firestore().collection(Collection.stories)
    }
    
    class func reviews(of postId: String) -> CollectionReference {
        
        return posts.document(postId).collection(Collection.reviews)
    }
    
    class func userPosts(of userId: String) -> CollectionReference {
        
        return users.document(userId).collection(Collection.userPosts)
    }
    
    class func userStories(of userId: String) -> CollectionReference {
        
        return users.document(userId).collection(Collection.userStories)
    }
    
    class func notifications(of userId: String) -> CollectionReference {
        
        return users.document(userId).collection(Collection.notifications)
    }
}
