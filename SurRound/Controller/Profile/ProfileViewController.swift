//
//  ProfileViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            selectionView.dataSource = self
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    
    private let tabTitle = ["My Posts", "Saved"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = profileHeaderView.sizeThatFits(.zero)
        profileHeaderView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: UIScreen.width, height: size.height)
        tableView.contentInset = UIEdgeInsets(top: size.height, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - User Actions
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        let isSuccessSignOut = AuthManager.shared.signOut()
        
        if isSuccessSignOut {
            let authVC = UIStoryboard.auth.instantiateInitialViewController()
            AppDelegate.shared.window?.rootViewController = authVC
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        
        tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
        tableView.registerCellWithNib(withCellClass: TextPostListCell.self)
        tableView.registerCellWithNib(withCellClass: VideoPostListCell.self)
        
        let guide = view.safeAreaLayoutGuide
        tableView.anchor(top: guide.topAnchor, left: guide.leftAnchor, bottom: guide.bottomAnchor, right: guide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagePostListCell.reuseIdentifier, for: indexPath)
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: SelectionViewDataSource {
    
    func numberOfSelectionItems(_ selectionView: SelectionView) -> Int {
        
        return 2
    }
    
    func selectionItemTitle(_ selectionView: SelectionView, for index: Int) -> String {
        
        return tabTitle[index]
    }
    
    func textColor(_ selectionView: SelectionView) -> UIColor {
        
        return .systemGray2
    }
    
    func indicatorLineColor(_ selectionView: SelectionView) -> UIColor {
        return .red
    }
}

extension ProfileViewController: SelectionViewDelegate {
    
}
