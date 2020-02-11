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
}
