//
//  HomeViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation
import GoogleMaps

class HomeViewModel {
    
    var numberOfStoryCollections: Int {
        return storyCollections.value.count
    }
    var storyEntities: [StoryCollection] {
        return storyCollections.value
    }
    
    private var mapPostViewModels: Observable<[MapPostViewModel]> = .init([])
    private var storyCollections: Observable<[StoryCollection]> = .init([])
    
    private let storyManager = StoryManager()
    private let postManager = PostManager.shared
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostHandler),
                                               name: Constant.NotificationId.newPost, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newStoryHandler),
                                               name: Constant.NotificationId.newStory, object: nil)
        fetchStory()
        fetchMapPost()
    }
    
    func bindStory(handlerForStory: (([StoryCollection]) -> Void)?) {
        
        guard let handler = handlerForStory else {
            storyCollections.removeObserver()
            return
        }
        storyCollections.addObserver(fireNow: false, onChanged: handler)
    }
    
    func bindMapPost(handlerForMapPost: (([MapPostViewModel]) -> Void)?) {
        
        guard let handler = handlerForMapPost else {
            mapPostViewModels.removeObserver()
            return
        }
        mapPostViewModels.addObserver(fireNow: false, onChanged: handler)
    }
    
    func unbind() {
        
        storyCollections.removeObserver()
        mapPostViewModels.removeObserver()
    }
    
    func getPostFromMarker(_ marker: GMSMarker) -> Post? {
        
        let matchedMapPost = mapPostViewModels.value.filter { mapPost in
            return marker == mapPost.mapMarker
        }.first
        return matchedMapPost?.post
    }
    
    func getStoryCollectionAt(index: Int) -> StoryCollection? {
        
        guard index >= 0 && index < storyCollections.value.count else {
            return nil
        }
        return storyCollections.value[index]
    }
    
    @objc func newPostHandler() {
        fetchMapPost()
    }
    
    @objc func newStoryHandler() {
        fetchStory()
    }
    
    private func fetchStory() {
        
        storyCollections.value.removeAll()
        storyManager.fetchStoryCollection { [weak self] result in
            
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.storyCollections.value.append(contentsOf: stories)
                }
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func fetchMapPost() {
        
        if AuthManager.shared.currentUser != nil {
            AuthManager.shared.updateProfile(completion: { [weak self] profile in
                self?._fetchMapPost(blockingUsers: profile.blocking)
            })
        } else {
            _fetchMapPost()
        }
    }
    
    private func _fetchMapPost(blockingUsers: [String] = []) {
        
        mapPostViewModels.value.removeAll()
        postManager.fetchAllPostWithBlocking(blockingUsers: blockingUsers) { [weak self] result in
            
            switch result {
            case .success(let posts):
                let viewModels = posts.map { post in
                    MapPostViewModel(post: post)
                }
                DispatchQueue.main.async {
                    self?.mapPostViewModels.value = viewModels
                }
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
}
