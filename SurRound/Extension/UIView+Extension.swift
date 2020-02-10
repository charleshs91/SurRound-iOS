//
//  UIView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIView {
    
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
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func roundToHeight() {
        
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
