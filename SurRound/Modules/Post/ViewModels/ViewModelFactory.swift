//
//  ViewModelFactory.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class ViewModelFactory {
    
    static func viewModelFromPosts(_ posts: [Post], viewerUser: SRUser) -> [PostListCellViewModel] {
        
        var viewModels: [PostListCellViewModel] = []
        
        posts.forEach { post in
            switch post.mediaType {
            case nil:
                viewModels.append(TextPostListCellViewModel(post, viewerUser: viewerUser))
            case "image":
                viewModels.append(ImagePostListCellViewModel(post, viewerUser: viewerUser))
            default:
                return
            }
        }
        return viewModels
    }
}
