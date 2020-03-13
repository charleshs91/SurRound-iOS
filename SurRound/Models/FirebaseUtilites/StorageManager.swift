//
//  StorageManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/30.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    func uploadAvatar(_ image: UIImage, userId: String, completion: @escaping (URL?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion(nil)
            return
        }
        
        let imageRef = Storage.storage().reference().child("avatars").child("\(userId).jpg")
        
        uploadData(imageData, ref: imageRef, completion: completion)
    }
    
    func uploadImage(_ image: UIImage,
                     filename: String,
                     completion: @escaping (URL?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            
            completion(nil)
            return
        }
        
        let imageRef = Storage.storage().reference().child("images").child("\(filename).jpg")
        
        uploadData(imageData, ref: imageRef, completion: completion)
    }
    
    func uploadVideo(_ videoData: Data,
                     filename: String,
                     completion: @escaping (URL?) -> Void) {
        
        let videoRef = Storage.storage().reference().child("videos").child("\(filename).mov")
        
        uploadData(videoData, ref: videoRef, completion: completion)
    }
    
    // MARK: - Private Methods
    private func uploadData(_ data: Data,
                            ref: StorageReference,
                            completion: @escaping (URL?) -> Void) {
        ref.putData(data, metadata: nil) { (_, error) in
            guard error == nil else {
                print(error!)
                return
            }
            self.getDownloadURL(ref, completion: completion)
        }
    }
    
    private func getDownloadURL(_ ref: StorageReference,
                                completion: @escaping (URL?) -> Void) {
        
        ref.downloadURL { (url, error) in
            guard error == nil else {
                print(error!)
                return
            }
            completion(url)
        }
    }
}
