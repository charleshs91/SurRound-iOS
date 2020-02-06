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
    
    deinit {
        debugPrint("$ deinit: StorageManager")
    }
    
    func uploadImage(_ image: UIImage, filename: String, completion: @escaping (URL?) -> Void) {
        
        guard let uploadData = image.jpegData(compressionQuality: 0.9) else { return }
        
        let imageRef = Storage.storage().reference().child("images").child("\(filename).jpg")
        
        imageRef.putData(uploadData, metadata: nil) { (_, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            self.getDownloadURL(imageRef, completion: completion)
            
        }
    }
    
    func getDownloadURL(_ ref: StorageReference, completion: @escaping (URL?) -> Void) {
        ref.downloadURL { (url, error) in
            guard error == nil else {
                print(error!)
                return
            }
            completion(url)
        }
    }
    
}
