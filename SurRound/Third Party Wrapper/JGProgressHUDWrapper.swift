//
//  JGProgressHUDWrapper.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/24.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import JGProgressHUD

enum HUDType {
    
    case success(String)
    
    case failure(String)
    
    var text: String {
        switch self {
        case .success(let text), .failure(let text):
            return text
        }
    }
    
    var indicatorView: JGProgressHUDIndicatorView {
        switch self {
        case .success:
            return JGProgressHUDSuccessIndicatorView()
        case .failure:
            return JGProgressHUDErrorIndicatorView()
        }
    }
}

class SRProgressHUD {
    
    static let shared = SRProgressHUD()
    
    let hud = JGProgressHUD(style: .dark)
    
    var view: UIView {
        return AppDelegate.shared.window!.visibleViewController!.view
    }
    
    static func showSuccess(text: String = "Success") {
        show(type: .success(text))
    }
    
    static func showFailure(text: String = "Failure") {
        show(type: .failure(text))
    }
    
    static func show(type: HUDType, delay: TimeInterval = 1.2) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                show(type: type, delay: delay)
            }
        }
        shared.hud.indicatorView = type.indicatorView
        shared.hud.textLabel.text = type.text
        shared.hud.show(in: shared.view)
        shared.hud.dismiss(afterDelay: delay)
    }
    
    static func showLoading(text: String? = nil) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showLoading()
            }
        }
        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        shared.hud.textLabel.text = text
        shared.hud.show(in: shared.view)
    }
    
    static func dismiss() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                dismiss()
            }
        }
        shared.hud.dismiss(animated: true)
    }
}
