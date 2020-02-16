//
//  StoryCreator.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/8.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias StoryCollectionsResult = (Result<[StoryCollection], FirestoreServiceError>) -> Void
typealias StoryResult = (Result<Story, Error>) -> Void
//typealias StoriesResult = (Result<[Story], Error>) -> Void

struct StoryManagerError: Error {
    
    static let failUploadingVideo = StoryManagerError(message: "Failure uploading video file.")
    
    var localizedDescription: String
    
    init(message: String) {
        self.localizedDescription = message
    }
}

class StoryManager {
    
    static func getDocId() -> String {
        
        return FirestoreService.stories.document().documentID
    }
    
    private let dataFetcher: DataFetching
        
    var buffer: [StoryCollection] = []
    
    init(dataFetcher: DataFetching = GenericFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchStoryCollection(completion: @escaping StoryCollectionsResult) {
        
        let collection = FirestoreService.stories
        
        dataFetcher.fetch(from: collection) { result in
            
            switch result {
            case .success(let documents):
                guard let stories = GenericParser.parse(documents, of: Story.self) else {
                    completion(.failure(.parsingError))
                    return
                }
                let entities = self.mapping(stories: stories)
                completion(.success(entities))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchStoryCollectionFrom(users uids: [String], completion: @escaping StoryCollectionsResult) {
        
        let query = FirestoreService.stories.whereField(Story.CodingKeys.authorId.rawValue, in: uids)
        
        dataFetcher.fetch(from: query) { result in
            
            switch result {
            case .success(let documents):
                guard let stories = GenericParser.parse(documents, of: Story.self) else {
                    completion(.failure(.parsingError))
                    return
                }
                let entities = self.mapping(stories: stories)
                completion(.success(entities))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createStory(_ videoFileURL: URL, at place: SRPlace, completion: @escaping StoryResult) throws {
        do {
            let videoData = try Data(contentsOf: videoFileURL)
            
            let ref = FirestoreService.stories.document()
            
            StorageManager().uploadVideo(videoData, filename: ref.documentID) { url in
                
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
                        UserDBService.attachStory(user: AuthManager.shared.currentUser!,
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
