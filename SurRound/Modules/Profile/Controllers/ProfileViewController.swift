//
//  ProfileViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileViewController: HiddenNavBarViewController, Storyboarded {
    
    // Storyboarded Protocol
    static var storyboard: UIStoryboard {
        return UIStoryboard.profile
    }
    
    var userToDisplay: SRUser!
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    
    private var profileViewModel: ProfileViewModel!
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireUpViewModel()
        setupViews()
        profileHeaderView.setupView(user: userToDisplay)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = profileHeaderView.sizeThatFits(.zero)
        
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: size.height)
        profileHeaderView.layoutIfNeeded()
        
        tableView.contentInset = UIEdgeInsets(top: size.height - view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "\(UserTableViewController.self)" {
            
            guard let destVC = segue.destination as? UserTableViewController,
                let listType = sender as? ProfileUserListModel else {
                    return
            }
            destVC.listType = listType
        }
    }
    
    // MARK: - User Actions
    @IBAction func followUser(_ sender: UIButton) {
        
        if !sender.isSelected {
            guard let currentUser = AuthManager.shared.currentUser else { return }
            
            let manager = ProfileManager()
            
            SRProgressHUD.showLoading()
            manager.followUser(receiverId: userToDisplay.uid, current: currentUser) { result in
                
                SRProgressHUD.dismiss()
                switch result {
                case .success:
                    SRProgressHUD.showSuccess()
                    
                case .failure(let error):
                    SRProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func moreActionButton(_ sender: UIButton) {
        
        userToDisplay.uid == AuthManager.shared.currentUser!.uid
            ? showAccountActions()
            : showUserActions()
    }
    
    @objc func showFollowingUsers(_ sender: UITapGestureRecognizer) {
        
        guard let profile = profileViewModel.userProfile else {
            return
        }
        
        performSegue(withIdentifier: "\(UserTableViewController.self)",
            sender: ProfileUserListModel.following(profile))
    }
    @objc func showFollowers(_ sender: UITapGestureRecognizer) {
        
        guard let profile = profileViewModel.userProfile else {
            return
        }
        
        performSegue(withIdentifier: "\(UserTableViewController.self)",
            sender: ProfileUserListModel.follower(profile))
    }
    
    @objc func handleEditAvatar(_ sender: UIButton) {
        
        let pickerVC = IGImagePickerController.instantiate()
        pickerVC.delegate = self
        navigationController?.show(pickerVC, sender: nil)
    }
    
    // MARK: - Private Methods
    private func fireUpViewModel() {
        
        profileViewModel = ProfileViewModel(userToDisplay: userToDisplay)
        
        profileViewModel.bindUserPost { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        profileViewModel.bindUserProfile { [weak self] userProfile in
            guard let userProfile = userProfile else {
                return
            }
            self?.profileHeaderView.updateProfile(profile: userProfile, postCount: userProfile.posts.count)
        }
    }
    
    private func showAccountActions() {
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Blocked Users", style: .default) { _ in
            print("Blocked user list")
        })
        
        alertVC.addAction(UIAlertAction(title: "Sign Out", style: .default) { [unowned self] _ in
            self.signOut()
        })
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        })
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showUserActions() {
        
        let alertVC = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report", style: .default) { _ in
            SRProgressHUD.showSuccess(text: "We've received your report on the current user.")
        }
        
        let blockAction = UIAlertAction(title: "Block", style: .default) { [unowned self] _ in
            let manager = ProfileManager()
            manager.blockUser(targetUid: self.userToDisplay.uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    SRProgressHUD.showSuccess(text: "Successful")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        [reportAction, blockAction, cancelAction].forEach {
            alertVC.addAction($0)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func signOut() {
        
        let isSuccessSignOut = AuthManager.shared.signOut()
        
        if isSuccessSignOut {
            let authVC = UIStoryboard.auth.instantiateInitialViewController()
            AppDelegate.shared.window?.rootViewController = authVC
        }
    }
    
    private func setupViews() {
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.registerCellWithNib(withCellClass: ImagePostListCell.self)
        tableView.registerCellWithNib(withCellClass: TextPostListCell.self)
        
        let guide = view.safeAreaLayoutGuide
        tableView.anchor(top: guide.topAnchor,
                         leading: guide.leadingAnchor,
                         bottom: guide.bottomAnchor,
                         trailing: guide.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        tableView.tableFooterView = UIView()
        
        profileHeaderView.followingCountLabel.isUserInteractionEnabled = true
        profileHeaderView.followingCountLabel.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(showFollowingUsers(_:))))
        
        profileHeaderView.followerCountLabel.isUserInteractionEnabled = true
        profileHeaderView.followerCountLabel.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(showFollowers(_:))))
        
        profileHeaderView.editAvatarButton.addTarget(self, action: #selector(handleEditAvatar(_:)), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileViewModel.numberOfPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = profileViewModel.getPostListCellViewModelAt(index: indexPath.row)!
        
        let cell = cellViewModel.cellType.makeCell(tableView, at: indexPath)
        guard let postListCell = cell as? PostListCell else {
            return cell
        }
        postListCell.configure(with: cellViewModel)
        return postListCell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard
            let post = profileViewModel.getPostListCellViewModelAt(index: indexPath.row)?.post,
            let nav = UIStoryboard.post.instantiateInitialViewController() as? UINavigationController,
            let postDetailVC = nav.topViewController as? PostContentViewController else { return }
        
        postDetailVC.post = post
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentInset.top + scrollView.contentOffset.y
        profileHeaderView.transform = CGAffineTransform(translationX: 0, y: -yOffset)
    }
}

// MARK: - IGImagePickerControllerDelegate
extension ProfileViewController: IGImagePickerControllerDelegate {
    
    func didSelectImage(_ controller: IGImagePickerController, with image: UIImage) {
        
        let profileManager = ProfileManager()
        
        SRProgressHUD.showLoading()
        
        profileManager.updateAvatar(image, uid: userToDisplay.uid) { [weak self] (error) in
            
            SRProgressHUD.dismiss()
            
            guard error == nil else {
                SRProgressHUD.showFailure(text: error!.localizedDescription)
                return
            }
            self?.profileHeaderView.profileImageView.image = image
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
