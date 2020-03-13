//
//  UIView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        
        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterSuperview() {
        
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    func setConstraints(to layoutGuide: UILayoutGuide,
                        top: CGFloat? = nil, leading: CGFloat? = nil,
                        trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        
        if let top = top {
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor,
                                      constant: top).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,
                                          constant: leading).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor,
                                           constant: trailing).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor,
                                         constant: bottom).isActive = true
        }
    }
    
    func setConstraints(to reference: UIView,
                        top: CGFloat? = nil, leading: CGFloat? = nil,
                        trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        
        if let top = top {
            self.topAnchor.constraint(equalTo: reference.topAnchor,
                                      constant: top).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: reference.leadingAnchor,
                                          constant: leading).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: reference.trailingAnchor,
                                           constant: trailing).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: reference.bottomAnchor,
                                         constant: bottom).isActive = true
        }
    }
    
    func stickToSafeArea(_ superview: UIView) {
        
        self.removeFromSuperview()
        superview.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func stickToView(_ superview: UIView) {
        
        self.removeFromSuperview()
        superview.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func roundToHalfHeight() {
        
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / 2
    }
}

extension CALayer {
    
    func setShadow(radius: CGFloat, offset: CGSize, color: UIColor, opacity: Float) {
        
        shadowRadius = radius
        shadowOffset = offset
        shadowColor = color.cgColor
        shadowOpacity = opacity
    }
}
