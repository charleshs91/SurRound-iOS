//
//  ESPullToRefreshWrapper.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import ESPullToRefresh

extension UITableView {
    
    func addHeaderRefreshing(refreshingBlock: @escaping () -> Void) {
        
        self.es.addPullToRefresh(handler: refreshingBlock)
    }
    
    func beginHeaderRefreshing() {
        
        self.es.startPullToRefresh()
    }
    
    func endHeaderRefreshing() {
        
        self.es.stopPullToRefresh()
    }
    
    func addFooterRefreshing(refreshingBlock: @escaping () -> Void) {
        
        self.es.addInfiniteScrolling(handler: refreshingBlock)
    }
    
    func endFooterRefreshing() {
        
        self.es.stopLoadingMore()
    }
    
    func endWithNoMoreData() {
        
        self.es.noticeNoMoreData()
    }
    
    func resetNoMoreData() {
        
        self.es.resetNoMoreData()
    }
}

extension UICollectionView {
    
    func addHeaderRefreshing(refreshingBlock: @escaping () -> Void) {
        
        self.es.addPullToRefresh(handler: refreshingBlock)
    }
    
    func beginHeaderRefreshing() {
        
        self.es.startPullToRefresh()
    }
    
    func endHeaderRefreshing() {
        
        self.es.stopPullToRefresh()
    }
    
    func addFooterRefreshing(refreshingBlock: @escaping () -> Void) {
        
        self.es.addInfiniteScrolling(handler: refreshingBlock)
    }
    
    func endFooterRefreshing() {
        
        self.es.stopLoadingMore()
    }
    
    func endWithNoMoreData() {
        
        self.es.noticeNoMoreData()
    }
    
    func resetNoMoreData() {
        
        self.es.resetNoMoreData()
    }
}
