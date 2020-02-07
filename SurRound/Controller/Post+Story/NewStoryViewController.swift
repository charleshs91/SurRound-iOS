//
//  NewStoryViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/7.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NewStoryViewController: UIViewController {

    static func storyboardInstance() -> NewStoryViewController? {
        
        return UIStoryboard.newPost.instantiateViewController(identifier:
            String(describing: NewStoryViewController.self)) as? NewStoryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
