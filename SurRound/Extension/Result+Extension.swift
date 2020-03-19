//
//  Result+Extension.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/18.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import Foundation

extension Result {
    
    func handle(_ onSuccess: (Success) -> Void) {
        
        handle(onSuccess) { error in
            SRProgressHUD.showFailure(text: error.localizedDescription)
        }
    }
    
    func handle(_ onSuccess: (Success) -> Void, onFailure: (Error) -> Void) {
        
        switch self {
        case .success(let object):
            onSuccess(object)
        case .failure(let error):
            onFailure(error)
        }
    }
}
