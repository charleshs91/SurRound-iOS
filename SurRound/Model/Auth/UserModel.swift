//
//  UserModel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

struct SRUser: Codable {
  
  let uid: String
  let email: String
  let username: String
  var avatar: String?
}
