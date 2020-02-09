//
//  CategoryButtonCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class CategoryButtonCell: UICollectionViewCell {
    
    let button: MaterialVerticalButton = {
        let btn = MaterialVerticalButton(icon: UIImage(), title: "", font: .systemFont(ofSize: 16, weight: .semibold), foregroundColor: .darkGray, useOriginalImg: true, bgColor: .clear, cornerRadius: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.7
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowRadius = 2
        return btn
    }()
    
    func layoutCell(image: UIImage?, title: String, tag: Int) {
        button.imageView.image = image
        button.label.text = title
        button.tag = tag
        layoutIfNeeded()
    }
    
    private func commonInit() {
        contentView.addSubview(button)
        button.stickToView(contentView)
        contentView.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
