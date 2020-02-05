//
//  MJRefreshWrapper.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    func addHeaderRefreshing(refreshingBlock: @escaping () -> Void) {
        
        mj_header = MJRefreshHeader(refreshingBlock: refreshingBlock)
    }
    
    func beginHeaderRefreshing() {
        
        mj_header?.beginRefreshing()
    }
    
    func endHeaderRefreshing() {
        
        mj_header?.endRefreshing()
    }
    
    func addFooterRefreshing(refreshingBlock: @escaping () -> Void) {
        
        mj_footer = MJRefreshFooter(refreshingBlock: refreshingBlock)
    }
    
    func endFooterRefreshing() {
        
        mj_footer?.endRefreshing()
    }
    
    func endWithNoMoreData() {
        
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() {
        
        mj_footer?.resetNoMoreData()
    }
}

extension UICollectionView {
    
        func addHeaderRefreshing(refreshingBlock: @escaping () -> Void) {
        
        mj_header = MJRefreshHeader(refreshingBlock: refreshingBlock)
    }
    
    func beginHeaderRefreshing() {
        
        mj_header?.beginRefreshing()
    }
    
    func endHeaderRefreshing() {
        
        mj_header?.endRefreshing()
    }
    
    func addFooterRefreshing(refreshingBlock: @escaping () -> Void) {
        
        mj_footer = MJRefreshFooter(refreshingBlock: refreshingBlock)
    }
    
    func endFooterRefreshing() {
        
        mj_footer?.endRefreshing()
    }
    
    func endWithNoMoreData() {
        
        mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() {
        
        mj_footer?.resetNoMoreData()
    }
}
