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
                                width: UIScreen.width,
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
