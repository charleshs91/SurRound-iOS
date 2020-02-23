//
//  SRRoundedLabel.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRRoundedLabel: UILabel {
    
    var contentInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundToHeight()
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
