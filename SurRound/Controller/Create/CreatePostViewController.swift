//
//  CreatePostViewController.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/25.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
  
  @IBOutlet weak var newPostTableView: UITableView!
  
  weak var textCell: NewPostTextViewCell?
  weak var mediaCell: NewPostMediaCell?
  
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    newPostTableView.registerHeaderFooterWithNib(withHeaderFooterViewClass: UserInfoSectionHeader.self)
    newPostTableView.registerCellWithNib(withCellClass: NewPostTextViewCell.self)
    newPostTableView.registerCellWithNib(withCellClass: NewPostMediaCell.self)
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
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: NewPostTextViewCell.identifier, for: indexPath)
      guard let textViewCell = cell as? NewPostTextViewCell else { return cell }
      self.textCell = textViewCell
      return textViewCell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: NewPostMediaCell.identifier, for: indexPath)
      guard let mediaCell = cell as? NewPostMediaCell else { return cell }
      mediaCell.attachHandler = displayImagePicker
      mediaCell.deleteHandler = handleDeletingImage
      self.mediaCell = mediaCell
      return mediaCell
    default:
      return UITableViewCell()
    }
  }
}

extension CreatePostViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 66
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      switch indexPath.row {
      case 0: return 135
      case 1: return 160
      default: break
      }
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
