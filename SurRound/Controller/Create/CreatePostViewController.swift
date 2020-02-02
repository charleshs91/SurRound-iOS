//
//  CreatePostViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    deinit {
        print("CreatePostViewController deinit()")
    }
    
    @IBOutlet weak var newPostTableView: UITableView! {
        didSet { setupTableView() }
    }
    
    weak var textCell: NewPostTextViewCell?
    weak var mediaCell: NewPostMediaCell?
    weak var mapCell: NewPostMapCell?
    
    var currentLocation: Coordinate?
    
    let cellFields: [NewPostCellType] = [.text, .media, .map]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Post"
    }
    
    // MARK: - User Actions
    @IBAction func post(_ sender: UIBarButtonItem) {
        
        guard let text = self.textCell?.textView.text,
            let user = AuthManager.shared.currentUser,
            let currentCoordinate = PlaceManager.current.coordinate else { return }
        
        let creator = PostCreator()
        
        let post = Post(id: PostCreator.documentID(),
                        category: "chat",
                        author: Post.Author(uid: user.uid, username: user.username, avatar: "123"),
                        createdTime: Date(),
                        text: text,
                        location: currentCoordinate)
        
        SRProgressHUD.showLoading(text: "Creating post")
        creator.createPost(post, image: mediaCell?.pickedImage) { [weak self] result in
            
            switch result {
            case .success:
                self?.postSuccessHandler()
                
            case .failure(let error):
                self?.postFailureHandler(with: error)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        
        newPostTableView.registerHeaderFooterWithNib(withHeaderFooterViewClass: UserInfoSectionHeader.self)
        
        newPostTableView.registerCellWithNib(withCellClass: NewPostTextViewCell.self)
        newPostTableView.registerCellWithNib(withCellClass: NewPostMediaCell.self)
        newPostTableView.registerCellWithNib(withCellClass: NewPostMapCell.self)
    }
    
    private func displayImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let imagePickerAlertController = UIAlertController(title: "Upload image",
                                                           message: "Select image source from",
                                                           preferredStyle: .actionSheet)
        
        imagePickerAlertController.addAction(
            UIAlertAction(title: "Photo library", style: .default) { [weak self] _ in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    imagePicker.sourceType = .photoLibrary
                    self?.present(imagePicker, animated: true, completion: nil)
                }
        })
        
        imagePickerAlertController.addAction(
            UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    self?.present(imagePicker, animated: true, completion: nil)
                }
        })
        
        imagePickerAlertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { _ in
                
                imagePickerAlertController.dismiss(animated: true, completion: nil)
        })
        
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    private func handleDeletingImage() {
        // To-Do: UIAlertController
        self.mediaCell?.pickedImage = nil
    }
    
    private func postSuccessHandler() {
        
        SRProgressHUD.showSuccess(text: "New post created")
        dismiss(animated: true, completion: nil)
    }
    
    private func postFailureHandler(with error: Error) {
        
        SRProgressHUD.showFailure(text: "Failure: \(error.localizedDescription)")
    }
}

// MARK: - UITableViewDataSource
extension CreatePostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: UserInfoSectionHeader.identifier
            ) as? UserInfoSectionHeader else { return UIView() }
        
        if let user = AuthManager.shared.currentUser {
            view.userLabel.text = user.username
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellFields[indexPath.row]
        let cell = cellType.makeCell(tableView, at: indexPath)
        
        switch cellType {
        case .text:
            guard let textViewCell = cell as? NewPostTextViewCell else { return cell }
            
            self.textCell = textViewCell
            
        case .media:
            guard let mediaCell = cell as? NewPostMediaCell else { return cell }
            
            mediaCell.attachHandler = { [weak self] in
                
                self?.displayImagePicker()
            }
            mediaCell.deleteHandler = { [weak self] in
                
                self?.handleDeletingImage()
            }
            self.mediaCell = mediaCell
            
        case .map:
            guard let mapCell = cell as? NewPostMapCell else { return cell }
            
            mapCell.coordinate = PlaceManager.current.coordinate
            self.mapCell = mapCell
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CreatePostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return cellFields[indexPath.row].cellHeight
        }
        
        return 0
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatePostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        picker.dismiss(animated: true) { [weak self] in
            self?.mediaCell?.pickedImage = image
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension CreatePostViewController: UINavigationControllerDelegate {
    
}
