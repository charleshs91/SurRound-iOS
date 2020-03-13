//
//  FirestoreManager.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/10.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

enum Path {
    
    case collection(String)
    case document(String)
}

enum Action {
    
    case setData([String: Any])
    case fetch
}

enum Condition {
    
    case searchValue(Any, String)
    case containValue(Any, String)
    case sortedByKey(String, descending: Bool)
    
    func apply(_ collectionRef: CollectionReference) -> Query {
        switch self {
        case .searchValue(let value, let key):
            return collectionRef.whereField(key, isEqualTo: value)
        case .containValue(let value, let key):
            return collectionRef.whereField(key, arrayContains: value)
        case .sortedByKey(let key, let isDescending):
            return collectionRef.order(by: key, descending: isDescending)
        }
    }
    
    func apply(_ query: Query) -> Query {
        switch self {
        case .searchValue(let value, let key):
            return query.whereField(key, isEqualTo: value)
        case .containValue(let value, let key):
            return query.whereField(key, arrayContains: value)
        case .sortedByKey(let key, let isDescending):
            return query.order(by: key, descending: isDescending)
        }
    }
}

enum FirestoreManagerError: Error {
    
    case pathError
    case requestError
    case firestoreError(String)
}

protocol Resource {
    
    var paths: [Path] { get }
    var action: Action { get }
    var conditions: [Condition] { get }
}

extension Resource {
    
    func collectionReference() throws -> CollectionReference {
        
        var collectionReference: CollectionReference?
        var documentReference: DocumentReference?
        
        for index in 0 ..< paths.count {
            switch paths[index] {
            case .collection(let path):
                if index == 0 {
                    collectionReference = Firestore.firestore().collection(path)
                } else {
                    collectionReference = documentReference?.collection(path)
                }
            case .document(let path):
                documentReference = collectionReference?.document(path)
            }
        }
        guard collectionReference != nil else {
            throw FirestoreManagerError.pathError
        }
        return collectionReference!
    }
    
    func documentReference() throws -> DocumentReference {
        
        var collectionReference: CollectionReference?
        var documentReference: DocumentReference?
        
        for index in 0 ..< paths.count {
            switch paths[index] {
            case .collection(let path):
                if index == 0 {
                    collectionReference = Firestore.firestore().collection(path)
                } else {
                    collectionReference = documentReference?.collection(path)
                }
            case .document(let path):
                documentReference = collectionReference?.document(path)
            }
        }
        guard documentReference != nil else {
            throw FirestoreManagerError.pathError
        }
        return documentReference!
    }
}

class FirestoreManager {
    
    func request(resource: Resource,
                 completion: @escaping (Result<Data, FirestoreManagerError>) -> Void) throws {
        
        switch resource.action {
        case .fetch:
            if case .collection = resource.paths.last {
                let reference = try resource.collectionReference()
                if resource.conditions.count > 0 {
                    // To-do: Handle conditions
                } else {
                    try fetchCollection(reference: reference, completion: completion)
                }
            } else {
                let reference = try resource.documentReference()
                try fetchDocument(reference: reference, completion: completion)
            }
            
        case .setData(let dict):
            guard case .document = resource.paths.last else {
                throw FirestoreManagerError.requestError
            }
            let reference = try resource.documentReference()
            try setData(reference: reference, dict: dict, completion: completion)
        }
    }
    
    private func fetchCollection(reference: CollectionReference,
                                 completion: @escaping (Result<Data, FirestoreManagerError>) -> Void) throws {
        
        reference.getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completion(.failure(.firestoreError(error!.localizedDescription)))
                return
            }
            let dictArray = querySnapshot!.documents.map { $0.data() }
            do {
                let data = try JSONSerialization.data(withJSONObject: dictArray, options: .fragmentsAllowed)
                completion(.success(data))
            } catch {
                completion(.failure(.firestoreError(error.localizedDescription)))
            }
        }
    }
    
    private func fetchDocument(reference: DocumentReference,
                               completion: @escaping (Result<Data, FirestoreManagerError>) -> Void) throws {
        
        reference.getDocument { (documentSnapshot, error) in
            guard error == nil else {
                completion(.failure(.firestoreError(error!.localizedDescription)))
                return
            }
            let dict = documentSnapshot!.data()!
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
                completion(.success(data))
            } catch {
                completion(.failure(.firestoreError(error.localizedDescription)))
            }
        }
    }
    
    private func setData(reference: DocumentReference, dict: [String: Any],
                         completion: @escaping (Result<Data, FirestoreManagerError>) -> Void) throws {
        
        reference.setData(dict, merge: true) { error in
            guard error == nil else {
                completion(.failure(.firestoreError(error!.localizedDescription)))
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
                completion(.success(data))
            } catch {
                completion(.failure(.firestoreError(error.localizedDescription)))
            }
        }
    }
}
