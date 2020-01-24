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
  
  func showSuccess(text: String = "Success") {
    show(type: .success(text))
  }
  
  func showFailure(text: String = "Failure") {
    show(type: .failure(text))
  }
  
  func show(type: HUDType, delay: TimeInterval = 1.0) {
    if !Thread.isMainThread {
      DispatchQueue.main.async { [weak self] in
        self?.show(type: type, delay: delay)
      }
    }
    hud.indicatorView = type.indicatorView
    hud.textLabel.text = type.text
    hud.show(in: view)
    hud.dismiss(afterDelay: delay)
  }
  
  func showLoading(text: String = "Loading") {
    if !Thread.isMainThread {
      DispatchQueue.main.async { [weak self] in
        self?.showLoading()
      }
    }
    hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
    hud.textLabel.text = text
    hud.show(in: view)
  }
  
  func dismiss() {
    if !Thread.isMainThread {
      DispatchQueue.main.async { [weak self] in
        self?.dismiss()
      }
    }
    hud.dismiss(animated: true)
  }
}
