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
        return _storyCollections.value.count
    }
    var storyCollections: [StoryCollection] {
        return _storyCollections.value
    }
    
    // MARK: - Private iVars
    private var mapPostViewModels: Observable<[MapPostViewModel]> = .init([])
    private var _storyCollections: Observable<[StoryCollection]> = .init([])
    
    private let storyManager = StoryManager()
    private let postManager = PostManager.shared
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(newPostHandler),
                                               name: Constant.NotificationId.newPost, object: nil)
        fetchStory()
        fetchMapPost()
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
            _storyCollections.removeObserver()
            return
        }
        _storyCollections.addObserver(onChanged: handler)
    }
    
    func bindMapPost(handlerForMapPost: (([MapPostViewModel]) -> Void)?) {
        
        guard let handler = handlerForMapPost else {
            mapPostViewModels.removeObserver()
            return
        }
        mapPostViewModels.addObserver(onChanged: handler)
    }
    
    func unbind() {
        
        _storyCollections.removeObserver()
        mapPostViewModels.removeObserver()
    }
    
    func getPostFromMarker(_ marker: GMSMarker) -> Post? {
        
        let matchedMapPost = mapPostViewModels.value.filter { mapPost in
            return marker == mapPost.mapMarker
        }.first
        return matchedMapPost?.post
    }
    
    func getStoryCollectionAt(index: Int) -> StoryCollection? {
        
        guard index >= 0 && index < _storyCollections.value.count else {
            return nil
        }
        return _storyCollections.value[index]
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
        
        _storyCollections.value.removeAll()
        storyManager.fetchStoryCollection { [weak self] result in
            
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?._storyCollections.value.append(contentsOf: stories)
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
