//
//  SelectionView.swift
//  delegate-practice
//
//  Created by Kai-Ta Hsieh on 2020/1/13.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

protocol SelectionViewDataSource: AnyObject {
    
    func selectionItemTitle(_ selectionView: SelectionView, for index: Int) -> String
    
    func numberOfSelectionItems(_ selectionView: SelectionView) -> Int
    
    func indicatorLineColor(_ selectionView: SelectionView) -> UIColor
    
    func textColor(_ selectionView: SelectionView) -> UIColor
    
    func textFont(_ selectionView: SelectionView) -> UIFont
}

extension SelectionViewDataSource {
    
    func numberOfSelectionItems(_ selectionView: SelectionView) -> Int {
        
        return 2
    }
    
    func indicatorLineColor(_ selectionView: SelectionView) -> UIColor {
        
        return UIColor.blue
    }
    
    func textColor(_ selectionView: SelectionView) -> UIColor {
        
        return UIColor.white
    }
    
    func textFont(_ selectionView: SelectionView) -> UIFont {
        
        return UIFont.preferredFont(forTextStyle: .body).withSize(18)
    }
    
}

@objc protocol SelectionViewDelegate: AnyObject {
    
    @objc optional func selectionView(_ selectionView: SelectionView, didSelectItemAt index: Int)
    
    @objc optional func selectionView(_ selectionView: SelectionView, shouldSelectItemAt index: Int) -> Bool
}

class SelectionView: UIView {
    
    // MARK: - Public Properties
    weak var dataSource: SelectionViewDataSource? {
        didSet { setupView() }
    }
    
    weak var delegate: SelectionViewDelegate?
    
    var indexSelected: Int = 0
    
    // MARK: - Private Properties
    private var indicatorCenterX: NSLayoutConstraint?
    
    private var buttons = [UIButton]()
    
    private let indicator: UIView = {
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    // MARK: - UIControl Actions
      @objc private func didSelectItem(_ sender: UIButton) {
          
          guard let index = buttons.firstIndex(of: sender) else { return }
          
          let isSelectable = delegate?.selectionView?(self, shouldSelectItemAt: index) ?? true
          
          if isSelectable {
              indexSelected = index
              moveIndicator(sender)
              delegate?.selectionView?(self, didSelectItemAt: index)
          }
      }
      
      private func moveIndicator(_ reference: UIButton) {
          
          UIViewPropertyAnimator.runningPropertyAnimator(
              withDuration: 0.3,
              delay: 0,
              options: .curveLinear,
              animations: { [weak self] in
                  
                  self?.indicatorCenterX?.isActive = false
                  self?.indicatorCenterX = self?.indicator.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
                  self?.indicatorCenterX?.isActive = true
                  self?.layoutIfNeeded()
              },
              completion: nil)
      }
    
    // MARK: - Private Methods
    private func setupView() {
        
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        self.addSubview(stackView)
        self.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            indicator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        setupButtons()
        layoutButtons()
        layoutIndicator()
    }
    
    private func setupButtons() {
        
        guard let dataSource = self.dataSource else { return }
        
        buttons.removeAll()
        
        for _ in 0 ..< dataSource.numberOfSelectionItems(self) {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            buttons.append(btn)
            stackView.addArrangedSubview(btn)
        }
    }
    
    private func layoutButtons() {
        
        guard let dataSource = self.dataSource else { return }
        
        let btnTextFont = dataSource.textFont(self)
        let btnTextColor = dataSource.textColor(self)
        
        for index in 0 ..< buttons.count {
            let title = dataSource.selectionItemTitle(self, for: index)
            let btn = buttons[index]
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(btnTextColor, for: .normal)
            btn.titleLabel?.font = btnTextFont
        }
    }
    
    private func layoutIndicator() {
        
        guard let dataSource = self.dataSource else { return }
        
        indicator.backgroundColor = dataSource.indicatorLineColor(self)
        
        let calculatedWidth = frame.size.width / CGFloat(buttons.count) - CGFloat(stackView.spacing)
        let optimizedWidth = min(calculatedWidth, 100)
        indicator.widthAnchor.constraint(equalToConstant: optimizedWidth).isActive = true
        indicatorCenterX = indicator.centerXAnchor.constraint(equalTo: buttons.first!.centerXAnchor)
        indicatorCenterX?.isActive = true
    }
}
