//
//  PostFetcher.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/11.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum DataFetchingError: Error {
    
    case fetchingError
    case parsingError
}

typealias DocumentCollectionResult = (Result<[QueryDocumentSnapshot], DataFetchingError>) -> Void

typealias DocumentResult = (Result<DocumentSnapshot, DataFetchingError>) -> Void

protocol DataFetching: AnyObject {
        
    func fetch(from collection: CollectionReference, completion: @escaping DocumentCollectionResult)
    
    func fetch(from query: Query, completion: @escaping DocumentCollectionResult)
    
    func fetch(from document: DocumentReference, completion: @escaping DocumentResult)
}

extension DataFetching {
    
    func fetch(from collection: CollectionReference, completion: @escaping DocumentCollectionResult) {
        
        collection.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.fetchingError))
                print(error!)
                return
            }
            
            completion(.success(snapshot.documents))
        }
    }
    
    func fetch(from query: Query, completion: @escaping DocumentCollectionResult) {
        
        query.getDocuments { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(.fetchingError))
                print(error!)
                return
            }
            
            completion(.success(snapshot.documents))
        }
    }
    
    func fetch(from document: DocumentReference, completion: @escaping DocumentResult) {

        document.getDocument { document, error in
            
            guard let document = document, error == nil else {
                completion(.failure(.fetchingError))
                print(error!)
                return
            }
            
            completion(.success(document))
        }
    }
}

class GenericFetcher: DataFetching {
    
}
