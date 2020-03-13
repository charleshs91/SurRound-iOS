//
//  StoryCreator.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/8.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias StoryCollectionsResult = (Result<[StoryCollection], DataFetchingError>) -> Void

typealias StoryResult = (Result<Story, Error>) -> Void

struct StoryManagerError: Error {
    
    static let failUploadingVideo = StoryManagerError(message: "Failure uploading video file.")
    
    var localizedDescription: String
    
    init(message: String) {
        self.localizedDescription = message
    }
}

class StoryManager {
    
    static let shared = StoryManager()
    
    private let dataFetcher: DataFetching
    private let storageManager: StorageManager
    
    var buffer: [StoryCollection] = []
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
        self.storageManager = StorageManager()
    }
}

// MARK: - `Fetch` Functions
extension StoryManager {
    
    func fetchStoryCollection(completion: @escaping StoryCollectionsResult) {
        
        let query = FirestoreDB.stories.order(by: Story.CodingKeys.createdTime.rawValue, descending: false)
        
        _fetch(from: query, completion: completion)
    }
    
    func fetchStoryCollectionFrom(users uids: [String], completion: @escaping StoryCollectionsResult) {
        
        let query = FirestoreDB.stories.whereField(Story.CodingKeys.authorId.rawValue, in: uids)
        
        _fetch(from: query, completion: completion)
    }
    
    private func _fetch(from query: Query, completion: @escaping StoryCollectionsResult) {
        
        dataFetcher.fetch(from: query) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let documents):
                guard let stories = GenericParser.parse(documents, of: Story.self) else {
                    completion(.failure(.parsingError))
                    return
                }
                let entities = self.mapping(stories: stories)
                completion(.success(entities))
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

// MARK: - `Create` Functions
extension StoryManager {
    
    func createStory(_ videoFileURL: URL, at place: SRPlace, completion: @escaping StoryResult) throws {
        do {
            let videoData = try Data(contentsOf: videoFileURL)
            
            let ref = FirestoreDB.stories.document()
            
            storageManager.uploadVideo(videoData, filename: ref.documentID) { url in
                
                guard let url = url else {
                    completion(.failure(StoryManagerError.failUploadingVideo))
                    return
                }
                let story = Story(id: ref.documentID,
                                  author: Author(AuthManager.shared.currentUser!),
                                  place: place,
                                  link: url.absoluteString)
                do {
                    try ref.setData(from: story, merge: true, encoder: Firestore.Encoder()) { error in
                        
                        guard error == nil else {
                            completion(.failure(error!))
                            return
                        }
                        UserService.attachStory(user: AuthManager.shared.currentUser!,
                                                  storyRef: ref)
                        completion(.success(story))
                    }
                } catch {
                    // Encoding Error
                    completion(.failure(error))
                }
            }
        } catch {
            // Fail to convert video file to Data
            throw error
        }
    }
}

// MARK: - Static Functions
extension StoryManager {
    
    static func getDocId() -> String {
        
        return FirestoreDB.stories.document().documentID
    }
}
