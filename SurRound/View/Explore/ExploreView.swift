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
    
    @IBOutlet weak var followingListView: UIView!
    
    @IBOutlet weak var trendingListView: UIView!
    
    @IBOutlet weak var nearestListView: UIView!
    
    var currentPageType: ExplorePageType = .following
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arrangeViews()
    }
    
    // MARK: - Actions
//    func movePage(to type: ExplorePageType) {
//
//        if currentPageType == type { return }
//
//        let currentView = convertToView(from: currentPageType)
//        let nextView = convertToView(from: type)
//
//        nextView.frame = nextView.frame.insetBy(dx: Constant.maxWidth, dy: 0)
//        bringSubviewToFront(nextView)
//        nextView.isHidden = false
//
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 0.3,
//            delay: 0,
//            options: .curveLinear,
//            animations: {
//                nextView.isHidden = false
//                nextView.frame = nextView.frame.insetBy(dx: -Constant.maxWidth, dy: 0)
//            },
//            completion: { _ in
//                currentView.isHidden = true
//            }
//        )
//    }
    
    func displayPage(with type: ExplorePageType) {
        
        let views: [UIView] = [followingListView, trendingListView, nearestListView]
        let viewToDisplay = convertToView(from: type)
        
        views.forEach { view in
            view.isHidden = view != viewToDisplay
        }
    }
    
    // MARK: - Private Methods
    private func arrangeViews() {
        
        let views: [UIView] = [followingListView, trendingListView, nearestListView]
        let height = safeAreaLayoutGuide.layoutFrame.height - selectionView.frame.height
        
        views.forEach { view in
            view.frame = CGRect(x: 0,
                                y: selectionView.frame.maxY,
                                width: Constant.maxWidth,
                                height: height)
            view.isHidden = true
        }
        
        displayPage(with: currentPageType)
    }
    
    private func convertToView(from type: ExplorePageType) -> UIView {
        
        switch type {
        case .following: return followingListView
        case .trending: return trendingListView
        case .nearest: return nearestListView
        }
    }
}
