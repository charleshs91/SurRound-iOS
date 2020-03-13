//
//  Storyboarded.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol Storyboarded {
    
    static var storyboard: UIStoryboard { get }
    
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: Self.self))
        
        guard let downCasted = viewController as? Self else {
            fatalError("Instantiate failure: \(String(describing: Self.self))")
        }
        
        return downCasted
    }
}
