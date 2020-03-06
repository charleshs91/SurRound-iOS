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
    
    // MARK: - Public iVars
    var numberOfStoryCollections: Int {
        return storyCollections.value.count
    }

    // MARK: - Private iVars
    private var mapPostViewModels: Observable<[MapPostViewModel]> = .init([])
    private var storyCollections: Observable<[StoryCollection]> = .init([])
    
    private let isLoggedIn: Bool
    private let storyManager: StoryManager
    private let postManager: PostManager
    
    init(isLoggedIn: Bool = true) {
        self.isLoggedIn = isLoggedIn
        self.storyManager = StoryManager()
        self.postManager = PostManager.shared
        NotificationCenter.default.addObserver(self, selector: #selector(newPostHandler),
                                               name: Constant.NotificationId.newPost, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    func start() {
        
        fetchStory()
        fetchMapPost()
    }
    
    func bindStory(handlerForStory: (([StoryCollection]) -> Void)?) {
        
        guard let handler = handlerForStory else {
            storyCollections.removeObserver()
            return
        }
        storyCollections.addObserver(onChanged: handler)
    }
    
    func bindMapPost(handlerForMapPost: (([MapPostViewModel]) -> Void)?) {
        
        guard let handler = handlerForMapPost else {
            mapPostViewModels.removeObserver()
            return
        }
        mapPostViewModels.addObserver(onChanged: handler)
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
    
    func getStoryCollections() -> [StoryCollection] {
        
        return storyCollections.value
    }
    
    func sendStory(videoURL: URL?) {
        
        guard let url = videoURL,
              let place = PlaceManager.current.place else {
                return
        }
        do {
            SRProgressHUD.showLoading()
            try storyManager.createStory(url, at: place) { [weak self] result in
                
                SRProgressHUD.dismiss()
                switch result {
                case .success:
                    SRProgressHUD.showSuccess()
                    self?.fetchStory()
                    
                case .failure(let error):
                    SRProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
        } catch {
            SRProgressHUD.showFailure(text: "Fail to convert video to Data")
        }
    }
    
    // MARK: - Selectors
    @objc func newPostHandler() {
        
        fetchMapPost()
    }
    
    // MARK: - Private Methods
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
        
    private func fetchMapPost(blockingUsers: [String] = []) {
        
        if isLoggedIn {
            guard AuthManager.shared.userProfile != nil else {
                
                AuthManager.shared.updateProfile { [weak self] userProfile in
                    
                    guard let userProfile = userProfile else {
                        return
                    }
                    self?.fetchMapPost(blockingUsers: userProfile.blocking)
                }
                return
            }
        }
        
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
