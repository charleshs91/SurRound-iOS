//
//  InvisibleNavController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class InvisibleNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.tintColor = .darkGray
        navigationBar.barStyle = .default
    }
    
}
