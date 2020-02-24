//
//  ProfileViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/2/4.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    static func storyInstance() -> ProfileViewController? {
        return UIStoryboard.profile.instantiateViewController(
            identifier: "\(ProfileViewController.self)") as? ProfileViewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            selectionView.dataSource = self
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    
    var userToDisplay: SRUser!
    
    var profile: SRUserProfile? {
        didSet {
            guard profile != nil else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.headerUpdateSemaphore.wait()
                self?.profileHeaderView.updateProfile(profile: self!.profile!,
                                                      postCount: self!.viewModels.count)
            }
        }
    }
    
    private let headerUpdateSemaphore = DispatchSemaphore(value: 0)
    
    private let tabTitle = ["All posts", "Saved"]
    
    private var posts = [Post]()
    
    private var viewModels = [PostListCellViewModel]() {
        didSet {
            headerUpdateSemaphore.signal()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        updateUserProfile()
        
        fetchUserPost()
        
        profileHeaderView.setupView(user: userToDisplay)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = profileHeaderView.sizeThatFits(.zero)
        
        profileHeaderView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: UIScreen.width,
                                         height: size.height)
        profileHeaderView.layoutIfNeeded()
        
        tableView.contentInset = UIEdgeInsets(top: size.height - view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "\(UserTableViewController.self)" {
            
            guard let destVC = segue.destination as? UserTableViewController,
                let listType = sender as? UserListType else {
                    return
            }
            destVC.listType = listType
        }
    }
    
    // MARK: - User Actions
    @IBAction func followUser(_ sender: UIButton) {
        
        if !sender.isSelected {
            guard let currentUser = AuthManager.shared.currentUser else { return }
            profileHeaderView.followButtonStartAnimating()
            let manager = ProfileManager()
            manager.followUser(receiverId: userToDisplay.uid, current: currentUser) { [weak self] error in
                guard error == nil else {
                    return
                }
                self?.profileHeaderView.followButtonStopAnimating()
            }
        }
    }
    
    @IBAction func moreActionButton(_ sender: UIButton) {
        
        if userToDisplay.uid == AuthManager.shared.currentUser!.uid {
            showAccountActions()
        } else {
            showUserActions()
        }
    }
    
    @objc func showFollowingUsers(_ sender: UITapGestureRecognizer) {
        
        guard let profile = profile else {
            return
        }
        
        performSegue(withIdentifier: "\(UserTableViewController.self)",
            sender: UserListType.following(profile))
    }
    @objc func showFollowers(_ sender: UITapGestureRecognizer) {
        
        guard let profile = profile else {
            return
        }
        
        performSegue(withIdentifier: "\(UserTableViewController.self)",
            sender: UserListType.follower(profile))
    }
    
    @objc func handleEditAvatar(_ sender: UIButton) {
        
        guard let pickerVC = IGImagePickerController.storyboardInstance() else {
            return
        }
        pickerVC.delegate = self
        navigationController?.show(pickerVC, sender: nil)
    }
    
    // MARK: - Private Methods
    private func showAccountActions() {
        
        let alertVC = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportListAction = UIAlertAction(title: "封鎖列表", style: .default) { _ in
            print("Blocked user list")
        }
        
        let signOutAction = UIAlertAction(title: "登出", style: .default) { [unowned self] _ in
            self.signOut()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        [reportListAction, signOutAction, cancelAction].forEach {
            alertVC.addAction($0)
        }
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func showUserActions() {
        
        let alertVC = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "檢舉", style: .default) { _ in
            SRProgressHUD.showSuccess(text: "我們已收到您的檢舉")
        }
        
        let blockAction = UIAlertAction(title: "封鎖", style: .default) { [unowned self] _ in
            let manager = ProfileManager()
            manager.blockUser(target: self.userToDisplay) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    SRProgressHUD.showSuccess(text: "封鎖成功")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
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
        tableView.registerCellWithNib(withCellClass: VideoPostListCell.self)
        
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
    
    private func fetchUserPost() {
        
        guard let user = userToDisplay else {
            return
        }
        
        posts.removeAll()
        viewModels.removeAll()
        
        PostManager().fetchPostOfUsers(uids: [user.uid]) { [weak self] result in
            
            switch result {
            case .success(let posts):
                self?.posts.append(contentsOf: posts)
                self?.viewModels.append(contentsOf: ViewModelFactory.viewModelFromPosts(posts))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUserProfile() {
        
        let manager = ProfileManager()
        
        manager.fetchProfile(user: userToDisplay.uid) { [weak self] profile in
            
            guard let profile = profile else {
                return
            }
            self?.profile = profile
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModels[indexPath.row]
        
        let cell = viewModel.cellType.makeCell(tableView, at: indexPath)
        
        guard let postListCell = cell as? PostListCell else {
            return cell
        }
        
        postListCell.layoutCell(with: viewModel)
        return postListCell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let postDetailVC = UIStoryboard.post.instantiateInitialViewController() as? PostContentViewController else { return }
        
        postDetailVC.post = posts[indexPath.row]
        
        present(postDetailVC, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentInset.top + scrollView.contentOffset.y
        
        profileHeaderView.transform = CGAffineTransform(translationX: 0, y: -yOffset)
    }
}

// MARK: - SelectionViewDataSource
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
