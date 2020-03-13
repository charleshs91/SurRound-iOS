//
//  SRTabBarController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/20.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

private enum Tab: CaseIterable {
    
    case home
    case explore
    case create
    case notification
    case profile
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!
        case .explore: controller = UIStoryboard.explore.instantiateInitialViewController()!
        case .notification: controller = UIStoryboard.notification.instantiateInitialViewController()!
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
        case .create: controller = UIStoryboard.newPost.instantiateInitialViewController()!
        }
        
        controller.tabBarItem = tabBarItem()
        
        switch self {
        case .create:
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 2, bottom: -4, right: 2)
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
            
        case .create:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.Icons_Add02),
                selectedImage: UIImage.asset(.Icons_Add02))
            
        case .notification:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.TabBarIcon_Bell),
                selectedImage: UIImage.asset(.TabBarIcon_Bell_Selected))
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(ImageAsset.TabBarIcon_42px_Profile),
                selectedImage: UIImage.asset(.TabBarIcon_42px_Profile_Selected))
        }
    }
}

class SRTabBarController: UITabBarController {
    
    @IBOutlet var newPostSelectorView: UIView!
    
    private let tabs: [Tab] = Tab.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map {
            $0.controller()
        }
        tabBar.tintColor = UIColor.themeColor
        
        delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension SRTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        if let nav = viewController as? UINavigationController,
            nav.viewControllers.first is NewPostViewController {
            
            let newVC = CategorySelectorViewController.instantiate()
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
    
    func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SwipeTransitionAnimator(viewControllers: tabBarController.viewControllers, duration: 0.25)
    }
}
