//
//  NotificationViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/23.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension NotificationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return .init()
    }
}

extension NotificationViewController: UITableViewDelegate {
    
}
