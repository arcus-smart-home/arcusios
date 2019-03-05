//
//  CancelTrackerPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/10/17.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import UIKit

class CancelTrackerPopupViewController: PopupSelectionBaseContainer, UITextViewDelegate {
  @IBOutlet var titleLabel: ArcusLabel!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var descriptionTextHeight: NSLayoutConstraint!

  override func getHeight() -> CGFloat {
    return descriptionTextHeight.constant - 141.0 + 265.0
  }

  private var closeHandler: () -> Void = { _ in }

  static func create() -> CancelTrackerPopupViewController? {
    let storyboard = UIStoryboard(name: "AlarmTracker", bundle: nil)
    if let viewController = storyboard
      .instantiateViewController(withIdentifier: "CancelTrackerPopupViewController")
      as? CancelTrackerPopupViewController {
      viewController.view.frame = CGRect(x: viewController.view.frame.origin.x,
                                         y: viewController.view.frame.origin.y,
                                         width: viewController.view.frame.size.width,
                                         height: 255)
      return viewController
    }
    return nil
  }

  // MARK: UI Configuration

  func configureCancelPopup(title: String, message: String, closeBlock: @escaping () -> Void) {

    view.layoutIfNeeded()

    titleLabel.text = title

    descriptionTextView.text = message
    textViewDidChange(descriptionTextView)

    closeHandler = closeBlock
  }

  // MARK: IBAction

  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    closeHandler()
  }

  // MARK: UITextViewDelegate

  func textViewDidChange(_ textView: UITextView) {
    let insets: UIEdgeInsets = textView.textContainerInset
    let size: CGSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                    height: CGFloat(MAXFLOAT)))
    let height = size.height + insets.top + insets.bottom + 16 // + 16 for clickable phone number
    UIView.animate(withDuration: 0.0, animations: {
      self.descriptionTextHeight.constant = height
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}
