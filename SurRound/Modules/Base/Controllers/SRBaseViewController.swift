//
//  SRBaseViewController.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBackButtonTitle()
    }
    
    func hideNavigationBackButtonTitle() {
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
    }
}
