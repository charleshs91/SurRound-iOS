//
//  ProfileViewModel.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    var userProfile: SRUserProfile? {
        return _userProfile.value
    }
    
    var numberOfPosts: Int {
        return userPostViewModels.value.count
    }
    
    private let thisUser: SRUser
    
    private var userPostViewModels: Observable<[PostListCellViewModel]> = .init([])
    private var _userProfile: Observable<SRUserProfile?> = .init(nil)
    
    private let profileManager: ProfileManager
    private let postManager: PostManager
    
    init(userToDisplay: SRUser) {
        self.thisUser = userToDisplay
        self.profileManager = ProfileManager()
        self.postManager = PostManager.shared
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchUserPost),
            name: Constant.NotificationId.newPost, object: nil
        )
        
        fetchUserPost()
        fetchUserProfile()
    }
    
    deinit {
        unbind()
    }
    
    func bindUserProfile(handler: @escaping (SRUserProfile?) -> Void) {
        
        _userProfile.addObserver(onChanged: handler)
    }
    
    func bindUserPost(handler: @escaping ([PostListCellViewModel]) -> Void) {
        
        userPostViewModels.addObserver(onChanged: handler)
    }
    
    func unbind() {
        
        _userProfile.removeObserver()
        userPostViewModels.removeObserver()
    }
    
    func getPostListCellViewModelAt(index: Int) -> PostListCellViewModel? {
        
        guard index >= 0 && index < userPostViewModels.value.count else {
            return nil
        }
        return userPostViewModels.value[index]
    }
    
    func fetchUserProfile() {
        
        profileManager.fetchProfile(user: thisUser.uid) { [weak self] profile in
            self?._userProfile.value = profile
        }
    }
    
    @objc private func fetchUserPost() {
        
        userPostViewModels.value.removeAll()
        
        postManager.fetchPostList(
            listCategory: .byAuthor(authorList: [thisUser.uid]),
            blockingUserList: []
        ) { [weak self] result in
            
            switch result {
            case .success(let posts):
                self?.userPostViewModels.value =  ViewModelFactory.viewModelFromPosts(posts)
                
            case .failure(let error):
                SRProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
}
