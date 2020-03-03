//
//  createClosure.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/3.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

func create<T>(_ setup: ((T) -> Void)) -> T where T: NSObject {
    
    let object = T()
    setup(object)
    return object
}
