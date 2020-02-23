//
//  SRTabBarController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/20.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

private enum Tab {
    
    case home
    case explore
    case message
    case profile
    case create
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!
        case .explore: controller = UIStoryboard.explore.instantiateInitialViewController()!
        case .message: controller = UIStoryboard.notification.instantiateInitialViewController()!
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
        case .create: controller = UIStoryboard.newPost.instantiateInitialViewController()!
        }
        
        controller.tabBarItem = tabBarItem()
        
        switch self {
        case .create:
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        default:
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 6, bottom: 0, right: 6)
        }
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
        case .home:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.TabBarIcon_42px_Home),
                selectedImage: UIImage.asset(.TabBarIcon_42px_Home_Selected))
            
        case .explore:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.TabBarIcon_42px_Explore),
                selectedImage: UIImage.asset(.TabBarIcon_42px_Explore_Selected))
            
        case .message:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.TabBarIcon_42px_Message),
                selectedImage: UIImage.asset(.TabBarIcon_42px_Message_Selected))
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.TabBarIcon_42px_Profile),
                selectedImage: UIImage.asset(.TabBarIcon_42px_Profile_Selected))
            
        case .create:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.Icons_Add02),
                selectedImage: UIImage.asset(.Icons_Add02))
        }
    }
}

class SRTabBarController: UITabBarController {
    
    @IBOutlet var newPostSelectorView: UIView!
    
    private let tabs: [Tab] = [.home, .explore, .create, .message, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map {
            $0.controller()
        }
        tabBar.tintColor = UIColor.themeColor
        
        delegate = self
    }
}

extension SRTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        
        if let nav = viewController as? UINavigationController,
            nav.viewControllers.first is NewPostViewController {
            
            let newVC = CategorySelectorViewController.storyboardInstance()!
            newVC.modalPresentationStyle = .overCurrentContext
            self.present(newVC, animated: false, completion: nil)
            
            return false
        }
        
        if let nav = viewController as? UINavigationController,
            let profileVC = nav.viewControllers.first as? ProfileViewController {
            
            guard let currentUser = AuthManager.shared.currentUser else {
                let welcomeVC = UIStoryboard.auth.instantiateInitialViewController()!
                self.present(welcomeVC, animated: true, completion: nil)
                return false
            }
            
            profileVC.userToDisplay = currentUser
            return true
        }
        
        return true
    }
}
