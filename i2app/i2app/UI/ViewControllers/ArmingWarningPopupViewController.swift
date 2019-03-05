//
//  ArmingWarningPopupViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/24/17.
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

import Foundation
import Cornea

/// This should be a more generic Popup Implementation and located in the group 
/// `i2app/UI/CustomControls/PopupSelection`
/// - seealso: CancelTrackerPopupViewController
class ArmingWarningPopupViewController: PopupSelectionBaseContainer, UITextViewDelegate {

  class var storyboardName: String { return "AlarmStatus" }
  class var storyboardIdentifier: String { return "ArmingWarningPopupViewController"}

  @IBOutlet var titleLabel: ArcusLabel!
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var descriptionTextHeight: NSLayoutConstraint!

  override func getHeight() -> CGFloat {
    return descriptionTextHeight.constant - 141.0 + 265.0
  }

  private var closeHandler: () -> Void = { _ in }

  static func create() -> ArmingWarningPopupViewController? {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    if let viewController = storyboard
      .instantiateViewController(withIdentifier: storyboardIdentifier)
      as? ArmingWarningPopupViewController {
      viewController.view.frame = CGRect(x: viewController.view.frame.origin.x,
                                         y: viewController.view.frame.origin.y,
                                         width: viewController.view.frame.size.width,
                                         height: 255)
      return viewController
    }
    return nil
  }

  // MARK: UI Configuration

  func configureCancelPopup(_ title: String, message: String, closeBlock: @escaping () -> Void) {

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
    let width = textView.frame.size.width
    let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
    var frame = textView.frame
    let insets: UIEdgeInsets = textView.textContainerInset
    frame.size = CGSize(width: width, height: size.height + insets.top + insets.bottom)

    UIView.animate(withDuration: 0.0, animations: {
      self.descriptionTextHeight.constant = frame.size.height
      self.view.layoutIfNeeded()
      }, completion: nil)
  }
}
