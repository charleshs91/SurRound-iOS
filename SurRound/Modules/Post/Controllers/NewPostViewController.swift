//
//  NewPostViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit
import GooglePlaces

class NewPostViewController: UIViewController {

    // MARK: iVars
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var newPostTableView: UITableView! {
        didSet {
            newPostTableView.registerHeaderFooterWithNib(
                withHeaderFooterViewClass: UserInfoSectionHeader.self)
            newPostTableView.registerCellWithNib(withCellClass: NewPostTextViewCell.self)
            newPostTableView.registerCellWithNib(withCellClass: NewPostMediaCell.self)
            newPostTableView.registerCellWithNib(withCellClass: NewPostMapCell.self)
        }
    }
    
    var postCategory: PostCategory!
    
    private weak var textCell: NewPostTextViewCell?
    private weak var mediaCell: NewPostMediaCell?
    private weak var mapCell: NewPostMapCell?
    
    private var postPlace: SRPlace?
    private let cellFields: [NewPostCellType] = [.text, .media, .map]
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coordinate = PlaceManager.current.location?.coordinate {
            postPlace = SRPlace(coordinate)
        }
        
        navigationItem.title = "New Post"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - User Actions
    @IBAction func post(_ sender: UIBarButtonItem) {
        
        guard
            let text = self.textCell?.textView.text,
            let srUser = AuthManager.shared.currentUser,
            let place = self.postPlace else { return }
        
        let post = Post(id: PostManager.documentID(),
                        category: postCategory.text,
                        author: Author(srUser),
                        text: text,
                        place: place)
        
        SRProgressHUD.showLoading(text: "Creating post")
        PostManager.shared.createPost(post, image: mediaCell?.pickedImage) { [weak self] result in
            
            SRProgressHUD.dismiss()
            switch result {
            case .success:
                self?.postSuccessHandler()
                
            case .failure(let error):
                self?.postFailureHandler(with: error)
            }
        }
    }
    
    @objc func handleLocationSelection(_ sender: UIButton) {
        
        let newVC = SelectLocationViewController.instantiate()
        newVC.delegate = self
        navigationController?.show(newVC, sender: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
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
        
        self.mediaCell?.pickedImage = nil
    }
    
    private func postSuccessHandler() {
        
        NotificationCenter.default.post(name: Constant.NotificationId.newPost, object: nil)
        SRProgressHUD.showSuccess(text: "New post created")
        dismiss(animated: true, completion: nil)
    }
    
    private func postFailureHandler(with error: Error) {
        
        SRProgressHUD.showFailure(text: "Failure: \(error.localizedDescription)")
    }
}

// MARK: - UITableViewDataSource
extension NewPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: UserInfoSectionHeader.reuseIdentifier
            ) as? UserInfoSectionHeader else { return UIView() }
        
        let user = AuthManager.shared.currentUser
        view.updateView(category: postCategory, user: user)
        view.layoutIfNeeded()
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return cellFields.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = cellFields[indexPath.row]
        let cell = cellType.makeCell(tableView, at: indexPath)
        
        switch cellType {
        case .text:
            guard let textViewCell = cell as? NewPostTextViewCell else { return cell }
            textViewCell.textView.delegate = self
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
            mapCell.canChangeLocation = postCategory.placeSelectionAllowed
            mapCell.chooseLocationBtn.addTarget(self, action: #selector(handleLocationSelection(_:)),
                                                for: .touchUpInside)
            self.mapCell = mapCell
        }
        return cell
    }
}

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        postButton.isEnabled = !textView.isEmpty
    }
}

// MARK: - UITableViewDelegate
extension NewPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NewPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        picker.dismiss(animated: true) { [weak self] in
            self?.mediaCell?.pickedImage = image
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension NewPostViewController: UINavigationControllerDelegate {
    
}

// MARK: - SelectLocationViewControllerDelegate
extension NewPostViewController: SelectLocationViewControllerDelegate {
    
    func didSelectLocation(_ controller: SelectLocationViewController, with place: SRPlace) {
        
        self.postPlace = place
        self.mapCell?.setPlace(with: place)
    }
}
