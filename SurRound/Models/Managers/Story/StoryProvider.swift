//
//  StoryProvider.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/8.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias StoryCollectionsResult = (Result<[StoryCollection], Error>) -> Void

typealias StoryResult = (Result<Story, Error>) -> Void

class StoryProvider {
    
    private let dataFetcher: DataFetching
    private let storageManager = StorageManager()
    
    var buffer: [StoryCollection] = []
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
}

// MARK: - `Fetch` Functions
extension StoryProvider {
    
    func fetchStoryCollection(completion: @escaping StoryCollectionsResult) {
        
        let query = FirestoreDB.stories.order(by: Story.CodingKeys.createdTime.rawValue, descending: false)
        
        fetch(from: query, completion: completion)
    }
    
    func fetchStoryCollectionFrom(users uids: [String], completion: @escaping StoryCollectionsResult) {
        
        let query = FirestoreDB.stories.whereField(Story.CodingKeys.authorId.rawValue, in: uids)
        
        fetch(from: query, completion: completion)
    }
    
    private func fetch(from query: Query, completion: @escaping StoryCollectionsResult) {
        
        dataFetcher.fetch(from: query) { result in
            
            switch result {
            case .success(let documents):
                guard let stories = GenericParser.parse(documents, of: Story.self) else {
                    completion(.failure(DataFetchingError.parsingError))
                    return
                }
                let entities = self.mapping(stories: stories)
                completion(.success(entities))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapping(stories: [Story]) -> [StoryCollection] {
        
        var buffer = [Author: [Story]]()
        for story in stories {
            if buffer[story.author] == nil {
                buffer[story.author] = [story]
            } else {
                buffer[story.author]!.append(story)
            }
        }
        var entities = [StoryCollection]()
        buffer.forEach { key, value in
            entities.append(StoryCollection(stories: value, author: key))
        }
        return entities
    }
}
