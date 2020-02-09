//
//  StoryDetailCollectionCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class StoryDetailCollectionCell: UICollectionViewCell {
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemGray3
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("X", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCloseButton()
        contentView.backgroundColor = .brown
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.roundToHeight()
    }
    
    private func setupCloseButton() {
        contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
