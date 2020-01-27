//
//  AppDelegate.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/15.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // swiftlint:disable force_cast
  static let shared = UIApplication.shared.delegate as! AppDelegate
  // swiftlint:enable force_cast
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    IQKeyboardManager.shared.enable = true
    if AuthManager.shared.currentUserID == nil {
      window?.rootViewController = UIStoryboard.auth.instantiateInitialViewController()
      window?.makeKeyAndVisible()
    }
    return true
  }
}
