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
    case .message: controller = UIStoryboard.message.instantiateInitialViewController()!
    case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
    case .create: controller = UIStoryboard.create.instantiateInitialViewController()!
    }
    
    controller.tabBarItem = tabBarItem()
    controller.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 4, bottom: -6, right: 4)
    
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
        image: UIImage.asset(ImageAsset.TabBarIcon_42px_Add),
        selectedImage: UIImage.asset(.TabBarIcon_42px_Add))
    }
  }
}

class SRTabBarController: UITabBarController {
  
  private let tabs: [Tab] = [.home, .explore, .create, .message, .profile]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = tabs.map { $0.controller() }
    tabBar.tintColor = .systemBlue
    delegate = self
  }
}

extension SRTabBarController: UITabBarControllerDelegate {
  
  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController) -> Bool {
    
    if let nav = viewController as? UINavigationController,
      nav.viewControllers.first is CreatePostViewController {
      
      let createPostVC = UIStoryboard.create.instantiateInitialViewController()!
      createPostVC.modalPresentationStyle = .currentContext
      present(createPostVC, animated: true, completion: nil)
      return false
    }
    
    return true
  }
}
