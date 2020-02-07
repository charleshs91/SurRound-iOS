//
//  PostCategory.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/6.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

enum PostCategory: Int {
    
    case food = 0
    case scenary = 1
    case shopping = 2
    case chat = 3
    case question = 4
    
    var text: String {
        
        switch self {
        case .food: return "Food"
        case .scenary: return "Scenary"
        case .shopping: return "Shopping"
        case .chat: return "Chat"
        case .question: return "Question"
        }
    }
    
    var placeSelectionAllowed: Bool {
        
        switch self {
        case .food, .scenary, .shopping:
            return true
            
        case .chat, .question:
            return false
        }
    }
}
