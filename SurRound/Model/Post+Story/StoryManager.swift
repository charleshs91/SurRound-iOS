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

typealias StoryEntitiesResult = (Result<[StoryEntity], Error>) -> Void
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
        return Firestore.firestore().collection("stories").document().documentID
    }
    
    lazy var storiesCollection = Firestore.firestore().collection("stories")
    
    var buffer: [StoryEntity] = []
    
    func fetchAllStoryEntities(completion: @escaping StoryEntitiesResult) {
        
        storiesCollection.getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else { return }
            
            var stories = [Story]()
            snapshot.documents.forEach { (document) in
                do {
                    if let story = try document.data(as: Story.self, decoder: Firestore.Decoder()) {
                        stories.append(story)
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            let entities = self.mapping(stories: stories)
            completion(.success(entities))
        }
    }
    
    func fetchStoryEntitiesFromUsers(uids: [String], completion: @escaping StoryEntitiesResult) {
        
        let query = storiesCollection.whereField(Story.CodingKeys.authorId.rawValue, isEqualTo: uids)
        
        query.getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            var stories = [Story]()
            snapshot.documents.forEach { (document) in
                do {
                    if let story = try document.data(as: Story.self, decoder: Firestore.Decoder()) {
                        stories.append(story)
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            let entities = self.mapping(stories: stories)
            completion(.success(entities))
        }
    }
    
    func createStory(_ videoFileURL: URL, at place: SRPlace, completion: @escaping StoryResult) throws {
        do {
            let videoData = try Data(contentsOf: videoFileURL)
            
            let ref = storiesCollection.document()
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
    
    private func mapping(stories: [Story]) -> [StoryEntity] {
        
        var buffer = [Author: [Story]]()
        for story in stories {
            if buffer[story.author] == nil {
                buffer[story.author] = [story]
            } else {
                buffer[story.author]!.append(story)
            }
        }
        var entities = [StoryEntity]()
        buffer.forEach { key, value in
            entities.append(StoryEntity(stories: value, author: key))
        }
        return entities
    }
}
