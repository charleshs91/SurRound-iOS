//
//  ExploreViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    let pages: [String] = ["Following", "Trending", "Nearest"]
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            self.selectionView.dataSource = self
            self.selectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ExploreViewController: SelectionViewDataSource {
    
    func selectionItemTitle(_ selectionView: SelectionView, for index: Int) -> String {
        
        return pages[index]
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
        
        return UIFont.preferredFont(forTextStyle: .body).withSize(18)
    }
}

extension ExploreViewController: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelectItemAt index: Int) {
        
    }
}
