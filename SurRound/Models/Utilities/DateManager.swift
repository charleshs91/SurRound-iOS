//
//  DateManager.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    private var dateFormatter = DateFormatter()
    
    func postDateFormatter() -> DateFormatter {
        
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        return dateFormatter
    }
}
