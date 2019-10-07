//
//  AddPersonCustomInvitationViewController.swift
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

class AddPersonCustomInvitationViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var invitationTextView: UITextView!
    @IBOutlet var textCountLabel: UILabel!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    internal var addPersonModel: AddPersonModel?

    let maxTextLength: Int = 360
    var textLength: Int = 0 {
        didSet {
            self.updateTextCountLabel()
        }
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.textLength = self.addPersonModel!.personalizedMessage!.count
        self.invitationTextView.text = self.addPersonModel?.invitationMessage

        self.invitationTextView.becomeFirstResponder()

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: UI Configuration
    func updateTextCountLabel() {
        self.textCountLabel.text =
            "Character Limit " + String(self.textLength) + "/" + String(self.maxTextLength)
    }

    // MARK: IBActions
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.invitationTextView.resignFirstResponder()
    }

    // MARK: UITextViewDelegate
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        self.textLength =
            textView.text.count + (text.count - range.length)

        return textLength < maxTextLength
    }

    func textViewDidChange(_ textView: UITextView) {
        let size: CGSize = CGSize(width: textView.frame.size.width,
                                  height: 400)
        self.textViewHeightConstraint.constant = textView.sizeThatFits(size).height
        textView.layoutIfNeeded()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.addPersonModel?.invitationMessage = textView.text
        self.dismiss(animated: true, completion: {})
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Here" {
            textView.text = ""
        }
    }
}
