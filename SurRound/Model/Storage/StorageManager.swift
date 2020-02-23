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
  
  func uploadImage(_ image: UIImage, filename: String, completion: ((URL?) -> Void)?) {
    guard let uploadData = image.pngData() else { return }
    
    let imageRef = Storage.storage().reference().child("images").child("\(filename).png")
    imageRef.putData(uploadData, metadata: nil) { (_, error) in
      guard error == nil else {
        print(error!)
        return
      }
      
      if let closure = completion {
        self.getDownloadURL(imageRef, completion: closure)
      }
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
