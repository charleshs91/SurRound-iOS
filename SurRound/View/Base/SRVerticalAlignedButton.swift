//
//  VerticallyCenteredButton.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/5.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRVerticalAlignedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentHorizontalAlignment = .center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.adjustImageAndTitleOffsetsForButton(spacing: 12)
    }

    func adjustImageAndTitleOffsetsForButton (spacing: CGFloat = 6.0) {
        
        guard let label = titleLabel, let img = imageView else { return }
        
        let imageSize = img.frame.size
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -imageSize.width,
                                       bottom: -(imageSize.height + spacing),
                                       right: 0)
        
        let titleSize = label.frame.size
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing),
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width) }
}
