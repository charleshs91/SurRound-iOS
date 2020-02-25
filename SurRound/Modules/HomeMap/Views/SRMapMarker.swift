//
//  SRMapMarker.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class SRMapMarker: UIView {
    
    // MARK: - UIViews
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
        label.backgroundColor = UIColor.themeColor
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Private Properties
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
    
    convenience init(avatar: String,
                     text: String,
                     category icon: UIImage? = nil,
                     placeholder: UIImage? = nil) {
        self.init(frame: .zero)
        
        self.avatarUrlString = avatar
        self.text = text
        self.categoryIcon = icon
        self.placeholder = placeholder
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.layer.cornerRadius = textLabel.frame.height / 2
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        self.addSubview(textLabel)
        self.addSubview(avatarImage)
        
        if categoryIcon != nil {
            self.addSubview(categoryImage)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: avatarImage.topAnchor, constant: -4),
            textLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor, constant: -30),
            textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            avatarImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarImage.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            avatarImage.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            avatarImage.widthAnchor.constraint(equalToConstant: 22),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor)
            //            categoryImage.widthAnchor.constraint(equalToConstant: 20),
            //            categoryImage.heightAnchor.constraint(equalTo: categoryImage.widthAnchor),
        ])
    }
}
