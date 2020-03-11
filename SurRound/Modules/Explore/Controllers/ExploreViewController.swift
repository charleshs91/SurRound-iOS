//
//  ExploreViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ExploreViewController: SRBaseViewController {
    
    private let pages: [ExplorePageType] = [.following, .trending, .nearest]
    
    private var exploreView: ExploreView! {
        return view as? ExploreView
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        navigationController?.navigationBar.isHidden = true
        
        exploreView.selectionView.dataSource = self
        exploreView.selectionView.delegate = self
        
        let tabBarHeight = tabBarController?.tabBar.frame.height
        exploreView.arrangeViews(tabBarHeight: tabBarHeight ?? 0)
        
        setupGestureRecognizers()
    }
    
    // MARK: - Private Methods
    private func setupGestureRecognizers() {
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(_:)))
        swipeRight.direction = .right
        
        exploreView.addGestureRecognizer(swipeLeft)
        exploreView.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeGestureHandler(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .left:
            exploreView.selectionView.selectNext()
        case .right:
            exploreView.selectionView.selectPrevious()
        default:
            return
        }
    }
}

// MARK: - SelectionViewDataSource
extension ExploreViewController: SelectionViewDataSource {
    
    func selectionItemTitle(_ selectionView: SelectionView, for index: Int) -> String {
        
        return pages[index].title
    }
    
    func numberOfSelectionItems(_ selectionView: SelectionView) -> Int {
        
        return pages.count
    }
    
    func indicatorLineColor(_ selectionView: SelectionView) -> UIColor {
        
        return UIColor.hexStringToUIColor(hex: "39375B")
    }
    
    func textColor(_ selectionView: SelectionView) -> UIColor {
        
        return .darkGray
    }
    
    func textFont(_ selectionView: SelectionView) -> UIFont {
        
        return UIFont.preferredFont(forTextStyle: .headline).withSize(16)
    }
}

// MARK: - SelectionViewDelegate
extension ExploreViewController: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelectItemAt index: Int) {
        
        exploreView.animateToPage(type: pages[index])
    }
}
