//
//  SRRoundedTableViewCell.swift
//  KDLibrary
//
//  Created by Kai-Ta Hsieh on 2020/1/9.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRRoundedTableViewCell: UITableViewCell {
    
    var bgColor: UIColor? {
        get {
            return contentView.backgroundColor }
        set {
            contentView.backgroundColor = newValue }
    }
    
    func setupView() {
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by:
            UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        
        contentView.layer.cornerRadius = 16
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}
