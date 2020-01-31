//
//  CreatePostViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
    var currentLocation: Location?
    let cellFields: [NewPostCellType] = [.text, .media, .map]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTableView() {
        newPostTableView.registerHeaderFooterWithNib(withHeaderFooterViewClass: UserInfoSectionHeader.self)
        newPostTableView.registerCellWithNib(withCellClass: NewPostTextViewCell.self)
        newPostTableView.registerCellWithNib(withCellClass: NewPostMediaCell.self)
        newPostTableView.registerCellWithNib(withCellClass: NewPostMapCell.self)
    }
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        guard let text = self.textCell?.textView.text,
            let user = AuthManager.shared.currentUser,
            let currentLocation = LocationProvider.getCurrentLocation() else { return }
        
        let creator = PostCreator()
        
        let post = Post(id: PostCreator.documentID(),
                        category: "chat",
                        author: Post.Author(uid: user.uid, username: user.username, avatar: "123"),
                        createdTime: Date(),
                        text: text,
                        location: currentLocation)
        
        if let imageToUpload = self.mediaCell?.pickedImage {
            SRProgressHUD.showLoading(text: "Creating post")
            creator.createPostWithImage(post: post, image: imageToUpload) { [weak self] result in
                SRProgressHUD.dismiss()
                self?.dismiss(animated: true, completion: nil)
            }
        } else {
            SRProgressHUD.showLoading(text: "Creating post")
            creator.createPost(post) { [weak self] result in
                SRProgressHUD.dismiss()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func displayImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let imagePickerAlertController = UIAlertController(
            title: "Upload image", message: "Select image source from", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "Photo library", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    func handleDeletingImage() {
        // UIAlertController
        self.mediaCell?.pickedImage = nil
    }
}

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
            mapCell.location = LocationProvider.getCurrentLocation()
            self.mapCell = mapCell
        }
        
        return cell
    }
}

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

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        picker.dismiss(animated: true) { [weak self] in
            self?.mediaCell?.pickedImage = image
        }
    }
}
