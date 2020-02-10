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
        case .create: controller = UIStoryboard.newPost.instantiateInitialViewController()!
        }
        
        controller.tabBarItem = tabBarItem()
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 6, bottom: 0, right: 6)
        
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
    
    @IBOutlet var newPostSelectorView: UIView!
    
    private let tabs: [Tab] = [.home, .explore, .create, .message, .profile]
    
    lazy var blurView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map {
            $0.controller()
        }
        tabBar.tintColor = UIColor.bluyGreen 
        delegate = self
    }
    
    @IBAction func didTapCloseCategorySelectorView(_ sender: UIButton) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.newPostSelectorView.frame.origin = CGPoint(x: 0, y: UIScreen.height)
                self.blurView.alpha = 0
        }, completion: { _ in
            self.newPostSelectorView.removeFromSuperview()
            self.blurView.removeFromSuperview()
        })
    }
    
    private func displayNewPostView() {
        
        blurView.alpha = 0
        view.addSubview(blurView)
        
        newPostSelectorView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 200)
        view.addSubview(newPostSelectorView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.newPostSelectorView.frame.origin = CGPoint(
                    x: 0, y: UIScreen.height - self.newPostSelectorView.frame.height)
                self.blurView.alpha = 1
        })
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
        return true
    }
}
