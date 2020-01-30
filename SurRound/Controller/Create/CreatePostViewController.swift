//
//  CreatePostViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
  
  @IBOutlet weak var newPostTableView: UITableView! {
    didSet { setupTableView() }
  }
  weak var textCell: NewPostTextViewCell?
  weak var mediaCell: NewPostMediaCell?
  weak var mapCell: NewPostMapCell?
  
  let imagePicker = UIImagePickerController()
  
  let cellFields: [NewPostCellType] = [.text, .media, .map]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  private func setupTableView() {
    newPostTableView.registerHeaderFooterWithNib(withHeaderFooterViewClass: UserInfoSectionHeader.self)
    newPostTableView.registerCellWithNib(withCellClass: NewPostTextViewCell.self)
    newPostTableView.registerCellWithNib(withCellClass: NewPostMediaCell.self)
    newPostTableView.registerCellWithNib(withCellClass: NewPostMapCell.self)
  }
  
  @IBAction func post(_ sender: UIBarButtonItem) {
    
  }
  
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    if presentingViewController != nil {
      self.dismiss(animated: true, completion: nil)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  func displayImagePicker() {
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    self.present(imagePicker, animated: true, completion: nil)
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
      mediaCell.attachHandler = displayImagePicker
      mediaCell.deleteHandler = handleDeletingImage
      self.mediaCell = mediaCell
      
    case .map:
      guard let mapCell = cell as? NewPostMapCell else { return cell }
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
