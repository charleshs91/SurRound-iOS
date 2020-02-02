//
//  NearestListViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/31.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NearestListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet { setupTableView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    
    private func setupTableView() {
        
        tableView.registerCellWithNib(withCellClass: PlaceItemListCell.self)
        
        tableView.separatorStyle = .none
    }
}

extension NearestListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceItemListCell.identifier, for: indexPath)
        
        return cell
    }
}

extension NearestListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 500
    }
    
}
