//
//  VideoProvider.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import Alamofire

typealias VideoDataBlock = (Data?) -> Void

class VideoProvider {
    
    func downloadVideo(_ urlString: String, completion: @escaping VideoDataBlock) {
        
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url).responseData(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
}
