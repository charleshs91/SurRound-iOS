//
//  UIView+Extension.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

extension UIView {
    
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
