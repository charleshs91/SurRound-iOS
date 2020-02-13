//
//  SRMapMarker.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRMapMarker: UIView {
    
    lazy var avatarImage: UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.loadImage(self.avatarUrlString ?? "", placeholder: self.placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var categoryImage: UIImageView = {
        
        let imageView = UIImageView(image: self.categoryIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        
        let label = SRRoundedLabel()
        label.contentInsets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = self.text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.bluyGreen
        return label
    }()
    
    private var avatarUrlString: String?
    private var text: String?
    private var categoryIcon: UIImage?
    private var placeholder: UIImage?
    
    private let iconSize = CGSize(width: 20, height: 20)
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(avatar: String, text: String, category icon: UIImage? = nil, placeholder: UIImage? = nil) {
        self.init(frame: .zero)
        
        self.avatarUrlString = avatar
        self.text = text
        self.categoryIcon = icon
        self.placeholder = placeholder
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.center.x = center.x * 1.25
        avatarImage.center.x = center.x
        avatarImage.frame.origin.y =  textLabel.frame.height + 4
    }
    
    private func setupViews() {
        
        self.addSubview(textLabel)
        self.addSubview(avatarImage)
        
        if categoryIcon != nil {
            self.addSubview(categoryImage)
        }
        
        styleTextLabel()
        styleAvatarImage()
        styleCategoryImage()
    }
    
    private func styleTextLabel() {
        
        textLabel.frame.size = CGSize(width: 100, height: 20)
        textLabel.layer.cornerRadius = textLabel.frame.height / 2
        textLabel.layer.masksToBounds = true
    }
    
    private func styleAvatarImage() {
        
        avatarImage.frame.size = CGSize(width: 26, height: 26)
        avatarImage.center = textLabel.center
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    private func styleCategoryImage() {
        
        guard categoryIcon != nil else {
            return
        }
        
        categoryImage.frame.size = iconSize
        categoryImage.center = CGPoint(x: textLabel.frame.minX - iconSize.width / 2 + 2,
                                       y: textLabel.center.y)
    }
}
