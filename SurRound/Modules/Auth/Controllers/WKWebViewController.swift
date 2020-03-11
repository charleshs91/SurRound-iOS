//
//  WKWebViewController.swift
//  SurRound
//
//  Created by Charles Hsieh on 2020/3/2.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: SRBaseViewController {

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.view.addSubview(webView)
        webView.stickToSafeArea(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPage()
    }
    
    private func loadPage() {
        guard let urlString = urlString,
            let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
