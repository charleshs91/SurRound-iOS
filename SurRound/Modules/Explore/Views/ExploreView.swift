//
//  ExploreView.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ExploreView: UIView {

    @IBOutlet weak var selectionView: SelectionView!
    
    @IBOutlet var followingListView: UIView!
    
    @IBOutlet var trendingListView: UIView!
    
    @IBOutlet var nearestListView: UIView!
    
    var currentPageType: ExplorePageType = .following
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
        displayPage(with: currentPageType)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Actions
    func animateToPage(type: ExplorePageType) {
        
        if type == currentPageType { return }
        
        let direction: CGFloat = type.rawValue > currentPageType.rawValue ? 1 : -1
        
        let currentView = convertToView(from: currentPageType)
        let viewToDisplay = convertToView(from: type)
        
        viewToDisplay.transform = CGAffineTransform(translationX: direction * viewToDisplay.frame.width, y: 0)
        bringSubviewToFront(viewToDisplay)
        self.currentPageType = type

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                viewToDisplay.transform = .identity
                currentView.transform = CGAffineTransform(translationX: -direction * currentView.frame.width, y: 0)
        }, completion: { _ in
            currentView.transform = .identity
        })
    }
    
    func displayPage(with type: ExplorePageType) {
        
        let viewToDisplay = convertToView(from: type)
        
        bringSubviewToFront(viewToDisplay)
        
        self.currentPageType = type
    }
    
    // MARK: - Private Methods
    func arrangeViews(tabBarHeight: CGFloat) {
        
        let views: [UIView] = [followingListView, trendingListView, nearestListView]
        let height = safeAreaLayoutGuide.layoutFrame.height - tabBarHeight - selectionView.frame.height
        
        views.forEach { view in
            view.frame = CGRect(x: 0,
                                y: selectionView.frame.maxY - selectionView.frame.height,
                                width: UIScreen.width,
                                height: height)
        }
    }
    
    private func convertToView(from type: ExplorePageType) -> UIView {
        
        switch type {
        case .following: return followingListView
        case .trending: return trendingListView
        case .nearest: return nearestListView
        }
    }
}
