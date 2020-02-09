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

typealias StoryResult = (Result<Story, Error>) -> Void
typealias StoriesResult = (Result<[Story], Error>) -> Void

struct StoryManagerError: Error {
    
    static let failUploadingVideo = StoryManagerError(message: "Failure uploading video file.")
    
    var localizedDescription: String
    
    init(message: String) {
        self.localizedDescription = message
    }
}

class StoryManager {
    
    func fetchAllStory(completion: @escaping StoriesResult) {
        
        Firestore.firestore().collection("stories").getDocuments { (snapshot, error) in
            
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
            
            completion(.success(stories))
        }
    }
    
    func createStory(_ videoURL: URL, at place: SRPlace, completion: @escaping StoryResult) throws {
        
        do {
            let videoData = try Data(contentsOf: videoURL)
            
            let ref = Firestore.firestore().collection("stories").document()
            StorageManager().uploadVideo(videoData, filename: ref.documentID) { url in
                
                guard let url = url else {
                    completion(.failure(StoryManagerError.failUploadingVideo))
                    return
                }
                let story = Story(id: ref.documentID,
                                  author: Author(user: AuthManager.shared.currentUser!),
                                  createdTime: Date(),
                                  place: place,
                                  movieLink: url.absoluteString)
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
}
