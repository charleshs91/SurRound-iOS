//
//  AppDelegate.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/15.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        setupGMSServices()
        
        checkAuthStatus()
        
        return true
    }
    
    private func setupGMSServices() {
        
        guard let path = Bundle.main.path(forResource: Constant.Google.googleServiceInfo,
                                          ofType: Constant.Google.plist),
            let dict = NSDictionary(contentsOfFile: path),
            let apiKey = dict[Constant.Google.apiKey] as? String else { return }
        
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }
    
    private func checkAuthStatus() {
        
        if AuthManager.shared.currentUser == nil {
            window?.rootViewController = UIStoryboard.auth.instantiateInitialViewController()
        } else {
            AuthManager.shared.updateProfile()
        }
    }
}
