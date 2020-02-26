//
//  UIStoryboard+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/20.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    static let home = "Home"
    static let explore = "Explore"
    static let notification = "Notification"
    static let profile = "Profile"
    static let newPost = "NewPost"
    static let auth = "Auth"
    static let post = "Post"
    static let story = "Story"
    static let guest = "Guest"
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return getStoryboard(name: StoryboardCategory.main) }
    
    static var home: UIStoryboard { return getStoryboard(name: StoryboardCategory.home) }
    
    static var explore: UIStoryboard { return getStoryboard(name: StoryboardCategory.explore) }
    
    static var notification: UIStoryboard { return getStoryboard(name: StoryboardCategory.notification) }
    
    static var profile: UIStoryboard { return getStoryboard(name: StoryboardCategory.profile) }
    
    static var newPost: UIStoryboard { return getStoryboard(name: StoryboardCategory.newPost) }
    
    static var auth: UIStoryboard { return getStoryboard(name: StoryboardCategory.auth) }
    
    static var post: UIStoryboard { return getStoryboard(name: StoryboardCategory.post) }
    
    static var story: UIStoryboard { return getStoryboard(name: StoryboardCategory.story) }
    
    static var guest: UIStoryboard { return getStoryboard(name: StoryboardCategory.guest) }
    
    private static func getStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
