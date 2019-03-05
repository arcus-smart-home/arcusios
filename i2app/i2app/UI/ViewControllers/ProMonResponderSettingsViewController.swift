//
//  ProMonResponderSettingsViewController.swift
//  i2app
//
//  Arcus Team on 2/15/17.
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
import UIKit
import Cornea

class ProMonResponderSettingsViewController: UIViewController,
  UITextViewDelegate,
ProMonResponderSettingsDelegate {

  internal var placeId: String = ""

  fileprivate var presenter: ProMonResponderSettingsPresenter?
  fileprivate let maxCharCount = 360

  @IBOutlet weak var instructionsField: UITextView!
  @IBOutlet weak var charLimitField: UILabel!

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    instructionsField.delegate = self
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(self.onHideKeyboard)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.presenter = ProMonResponderSettingsPresenter(delegate: self, placeId: self.placeId)
  }

  // MARK: UITextViewDelegate

  func textViewDidChange(_ textView: UITextView) {
    updateCharacterCount()
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {

    // Hide keyboard when user types done/return
    if text == "\n" {
      onHideKeyboard()
      return false
    }

    var currentCharacterCount = 0
    if let count = textView.text?.characters.count {
      currentCharacterCount = count
    }
    if range.length + range.location > currentCharacterCount {
      return false
    }
    let newLength = currentCharacterCount + text.characters.count - range.length
    return newLength <= maxCharCount
  }

  fileprivate func updateCharacterCount() {
    charLimitField.text = "CHARACTER LIMIT \(instructionsField.text.characters.count) / \(maxCharCount)"
  }

  // MARK: ProMonResponderSettingsDelegate

  func showResponderInstructions(_ responderInfo: String?) {
    instructionsField.text = ""
    if let info = responderInfo {
      instructionsField.text = info
    }
    updateCharacterCount()
  }

  func onResponderSaveSuccess() {
    self.navigationController?.popViewController(animated: false)
  }

  func onResponderSaveError() {
    displayGenericErrorMessage()
  }

  func onHideKeyboard() {
    self.instructionsField.resignFirstResponder()
  }

  @IBAction func onSave(_ sender: AnyObject) {
    presenter?.saveResponderInstructions(instructionsField.text)
  }
}
