//
//  NewPostTextViewCell.swift
//  SurRound
//
//  Created by Kai-Ta Hsieh on 2020/1/27.
//  Copyright © 2020 Kai-Ta Hsieh. All rights reserved.
//

import UIKit

class NewPostTextViewCell: UITableViewCell {
  
  static var identifier: String {
    return String(describing: NewPostTextViewCell.self)
  }
  
  @IBOutlet weak var textView: UITextView!
  
  private let kPlaceholder = "Write Something..."
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textView.delegate = self
    displayPlaceholder(in: textView)
  }
  
  private func displayPlaceholder(in textView: UITextView) {
    textView.text = kPlaceholder
    textView.textColor = .lightGray
    textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                    to: textView.beginningOfDocument)
  }
  
}

extension NewPostTextViewCell: UITextViewDelegate {
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // Combine the textView text and the replacement text
    // to create the updated text string
    let currentText: String = textView.text
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
    
    // If updated text view will be empty, add the placeholder
    // and set the cursor to the beginning of the text view
    if updatedText.isEmpty {
      
      textView.text = kPlaceholder
      textView.textColor = UIColor.lightGray
      
      textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
      
    // Else if the text view's placeholder is showing and the
    // length of the replacement string is greater than 0, set
    // the text color to black then set its text to the
    // replacement string
    else if textView.textColor == UIColor.lightGray && !text.isEmpty {
      textView.textColor = UIColor.black
      textView.text = text
    }
      
    // For every other case, the text should change with the usual
    // behavior...
    else {
      return true
    }
    
    // ...otherwise return false since the updates have already
    // been made
    return false
  }

}
