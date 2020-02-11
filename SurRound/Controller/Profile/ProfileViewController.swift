//
//  ProfileViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - User Actions
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        let isSuccessSignOut = AuthManager.shared.signOut()
        
        if isSuccessSignOut {
            
            let authVC = UIStoryboard.auth.instantiateInitialViewController()
            AppDelegate.shared.window?.rootViewController = authVC
        }
    }
}
