//
//  UIStoryboard+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/20.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
  
  static let main = "Main"
  static let home = "Home"
  static let explore = "Explore"
  static let message = "Message"
  static let profile = "Profile"
  static let create = "Create"
  static let auth = "Auth"
}

extension UIStoryboard {
  
  static var main: UIStoryboard { return getStoryboard(name: StoryboardCategory.main) }
  
  static var home: UIStoryboard { return getStoryboard(name: StoryboardCategory.home) }
  
  static var explore: UIStoryboard { return getStoryboard(name: StoryboardCategory.explore) }
  
  static var message: UIStoryboard { return getStoryboard(name: StoryboardCategory.message) }
  
  static var profile: UIStoryboard { return getStoryboard(name: StoryboardCategory.profile) }
  
  static var create: UIStoryboard { return getStoryboard(name: StoryboardCategory.create) }
  
  static var auth: UIStoryboard { return getStoryboard(name: StoryboardCategory.auth) }
  
  private static func getStoryboard(name: String) -> UIStoryboard {

      return UIStoryboard(name: name, bundle: nil)
  }
}
