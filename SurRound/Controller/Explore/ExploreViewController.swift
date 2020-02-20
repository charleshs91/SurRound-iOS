//
//  ExploreViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

enum ExplorePageType: Int {
    
    case following = 0
    case trending = 1
    case nearest = 2
    
    var title: String {
        switch self {
        case .following: return "Following"
        case .trending: return "Trending"
        case .nearest: return "Nearest"
        }
    }
}

class ExploreViewController: UIViewController {
    
    let pages: [ExplorePageType] = [.following, .trending, .nearest]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        guard let exploreView = view as? ExploreView else { return }
        exploreView.selectionView.dataSource = self
        exploreView.selectionView.delegate = self
        exploreView.arrangeViews()
        setupGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupGestureRecognizers() {
        
        guard let exploreView = view as? ExploreView else { return }
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureHandler(_:)))
        swipeRight.direction = .right
        exploreView.addGestureRecognizer(swipeLeft)
        exploreView.addGestureRecognizer(swipeRight)
    }
    
    @objc func swipeGestureHandler(_ sender: UISwipeGestureRecognizer) {
        
        guard let exploreView = view as? ExploreView else { return }
        
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

extension ExploreViewController: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelectItemAt index: Int) {
        
        guard let exploreView = view as? ExploreView else { return }
        
        exploreView.animateToPage(type: pages[index])
    }
}
