//
//  PostCategory.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

enum PostCategory: Int {
    
    case food = 0
    case scenary = 1
    case shopping = 2
    case chat = 3
    case question = 4
    case cancel = 5
    
    var text: String {
        
        switch self {
        case .food: return "Food"
        case .scenary: return "Scenary"
        case .shopping: return "Shopping"
        case .chat: return "Chat"
        case .question: return "Question"
        case .cancel: return "Close"
        }
    }
    
    var placeSelectionAllowed: Bool {
        
        switch self {
        case .food, .scenary, .shopping:
            return true
            
        case .chat, .question, .cancel:
            return false
        }
    }
    
    var image: UIImage {
        switch self {
        case .food: return UIImage.asset(.Icons_Category_Food)!
        case .scenary: return UIImage.asset(.Icons_Category_Scenary)!
        case .shopping: return UIImage.asset(.Icons_Category_Shop)!
        case .chat: return UIImage.asset(.Icons_Category_Chat)!
        case .question: return UIImage.asset(.Icons_Category_Ask)!
        case .cancel: return UIImage.asset(.Icons_Close)!
        }
    }
}
