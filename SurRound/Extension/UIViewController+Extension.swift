//
//  UIViewController+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var contents: UIViewController? {
        if let nav = self as? UINavigationController {
            return nav.topViewController
        } else {
            return self
        }
    }
}
