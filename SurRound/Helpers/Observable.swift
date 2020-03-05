//
//  Observable.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/16.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

class Observable<T: Any> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.onValueChanged?(self.value)
            }
        }
    }
    
    private var onValueChanged: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(fireNow: Bool = true, onChanged: @escaping (T) -> Void) {
        onValueChanged = onChanged
        if fireNow {
            onValueChanged?(value)
        }
    }
    
    func removeObserver() {
        onValueChanged = nil
    }
}
