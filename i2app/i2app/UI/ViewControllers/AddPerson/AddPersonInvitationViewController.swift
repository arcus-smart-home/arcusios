//
//  AddPersonInvitationViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/2/16.
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
import Cornea

class AddPersonInvitationViewController: UIViewController,
  UITextViewDelegate,
ArcusInputAccessoryProtocol {
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var sendButton: ArcusButton!
  @IBOutlet var invitationTextViewInputAccessoryView: ArcusInputAccessoryView! {
    didSet {
      self.invitationTextViewInputAccessoryView.inputDelegate = self
      self.invitationTextViewInputAccessoryView.doneButton
        .setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white],
                                for: UIControlState())
    }
  }
  @IBOutlet var invitationTextView: UITextView! {
    didSet {
      self.invitationTextView.inputAccessoryView = self.invitationTextViewInputAccessoryView
    }
  }
  @IBOutlet var textCountLabel: UILabel!
  @IBOutlet var headerLabel: ArcusLabel! {
    didSet {
      self.headerLabel.text = self.defaultInvitationMessage()
    }
  }
  @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint!

  internal var addPersonModel: AddPersonModel? {
    didSet {
      self.addPersonModel?.invitationMessage = self.defaultInvitationMessage()
    }
  }

  let maxTextLength: Int = 360
  var textLength: Int = 0 {
    didSet {
      self.updateTextCountLabel()
    }
  }

  let placeHolder: String = "Tap here to add to the above message."

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)

    if ObjCMacroAdapter.isPhone5() {
      self.invitationTextView.isScrollEnabled = true
    }

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardWillShow(_:)),
                                           name: Notification.Name.UIKeyboardWillShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardWillHide(_:)),
                                           name: Notification.Name.UIKeyboardWillHide,
                                           object: nil)

  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: IBActions
  @IBAction func sendInvitationButtonPressed(_ sender: ArcusButton) {
    sender.isEnabled = false

    if self.invitationTextView.isFirstResponder {
      self.invitationTextView.resignFirstResponder()
    }

    self.addPersonModel?.sendFullAccessInvitation({ (success, _) in
      if success {
        self.performSegue(withIdentifier: "AddPersonFullAccessSuccessSegue", sender: self)
      } else {
        sender.isEnabled = true
      }
    })
  }

  func defaultInvitationMessage() -> String {
    guard let ownerId = AccountCapability.getOwnerFrom(RxCornea.shared.settings?.currentAccount)
      else { return "" }
    
    let personModel = RxCornea.shared.modelCache?
      .fetchModel(PersonModel.addressForId(ownerId)) as? PersonModel
    var firstName: String = "Someone"
    if let name = RxCornea.shared.settings?.currentPerson?.firstName {
      firstName = name
    }
    var currentAccount: String = "an Arcus User"
    if let account = personModel?.firstName {
      currentAccount = account
    }
    var placeName: String = "Unknown"
    if let place = RxCornea.shared.settings?.currentPlace?.name {
      placeName = place
    }
    return "Great News! " + firstName + " has added you to " + currentAccount +
      "'s smart home at the place called " + placeName
  }

  // MARK: UI Configuration
  func updateTextCountLabel() {
    self.textCountLabel.text =
      "Character Limit " + String(self.textLength) + "/" + String(self.maxTextLength)
  }

  // MARK: Keyboard Handling
  func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue? =
      userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue
    let keyboardRectangle = keyboardFrame?.cgRectValue
    let keyboardHeight = keyboardRectangle?.height

    self.bottomLayoutConstraint.constant = keyboardHeight!
    self.scrollView.layoutIfNeeded()
    self.view.layoutIfNeeded()
  }

  func keyboardWillHide(_ notification: Notification) {
    self.bottomLayoutConstraint.constant = 0
    self.scrollView.layoutIfNeeded()
    self.view.layoutIfNeeded()
  }

  // MARK: UITextViewDelegate
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    self.textLength =
      textView.text.count + (text.count - range.length)

    return self.textLength < self.maxTextLength
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = self.placeHolder
    } else {
      if textView.text != self.placeHolder {
        self.addPersonModel?.personalizedMessage = textView.text
      }
    }

    self.scrollView.scrollRectToVisible(CGRect.zero, animated: true)
    self.scrollView.isScrollEnabled = false
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == self.placeHolder {
      textView.text = ""
    }

    self.scrollView.isScrollEnabled = true

    let scrollRect: CGRect = CGRect(x: self.textCountLabel.frame.origin.x,
                                    y: self.textCountLabel.frame.origin.y,
                                    width: self.textCountLabel.frame.size.width,
                                    height: 200)
    self.scrollView.scrollRectToVisible(scrollRect,
                                        animated: true)

  }

  // MARK: ArcusInputAccessoryProtocol
  func doneToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView) {
    self.invitationTextView.resignFirstResponder()
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonFullAccessSuccessSegue" {
      let successViewController: AddPersonSuccessViewController? =
        segue.destination as? AddPersonSuccessViewController
      successViewController?.addPersonModel = self.addPersonModel
    }
  }
}
