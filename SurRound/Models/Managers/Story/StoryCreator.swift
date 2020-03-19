//
//  StoryCreator.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/19.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Firebase

class StoryCreator {
    
    struct VideoConvertToDataError: Error {
        
        var localizedDescription: String {
            return "Failed to convert video to Data"
        }
    }
    struct VideoUploadError: Error {
        
        var localizedDescription: String {
            return "Failed to upload video"
        }
    }
    
    private let videoFileURL: URL
    private let place: SRPlace
    private let storageManager = StorageManager()
    private let docRef: DocumentReference
    
    init(_ videoFileURL: URL,
         place: SRPlace,
         docRef: DocumentReference = FirestoreDB.stories.document()) {
        
        self.videoFileURL = videoFileURL
        self.place = place
        self.docRef = docRef
    }
    
    func create(completion: @escaping StoryResult) {
        
        guard let videoData = tryConvertVideoToData(url: videoFileURL) else {
            completion(.failure(VideoConvertToDataError()))
            return
        }
        
        storageManager.uploadVideo(videoData, filename: docRef.documentID) { [weak self] url in
            
            guard let strongSelf = self else { return }
            
            guard let url = url else {
                completion(.failure(VideoUploadError()))
                return
            }
            let story = strongSelf.makeStory(url.absoluteString)
            
            strongSelf.updateDatabase(story, completion: completion)
        }
    }
    
    private func updateDatabase(_ story: Story, completion: @escaping StoryResult) {
        
        do {
            try docRef.setData(from: story, merge: true, encoder: Firestore.Encoder()) { [docRef] error in
                
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                UserService.attachStory(user: AuthManager.shared.currentUser!, storyRef: docRef)
                completion(.success(story))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func makeStory(_ urlString: String) -> Story {
        
        return Story(id: docRef.documentID,
                     author: Author(AuthManager.shared.currentUser!),
                     place: place,
                     link: urlString)
    }
    
    private func tryConvertVideoToData(url: URL) -> Data? {
        
        do {
            let videoData = try Data(contentsOf: url)
            return videoData
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
