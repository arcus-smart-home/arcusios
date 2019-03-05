//
//  RemovePersonAlertView.swift
//  i2app
//
//  Created by Arcus Team on 5/19/16.
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

@objc protocol RemovePersonAlertDelegate {
    func confirmButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView)
    func cancelButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView)
    @objc optional func closeButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView)
}

class RemovePersonAlertView: UIView {
    @IBOutlet var titleLabel: ArcusLabel!
    @IBOutlet var descriptionLabel: ArcusLabel!
    @IBOutlet var descriptionSubtextLabel: ArcusLabel!
    @IBOutlet var confirmButton: ArcusButton!
    @IBOutlet var cancelButton: ArcusButton!
    @IBOutlet var closeButton: ArcusButton!

    weak var delegate: RemovePersonAlertDelegate?

    @IBAction func confirmButtonPressed(_ sender: ArcusButton) {
        if self.delegate != nil {
            self.delegate?.confirmButtonPressed(sender, alertView: self)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: ArcusButton) {
        if self.delegate != nil {
            self.delegate?.cancelButtonPressed(sender, alertView: self)
        }
    }

    @IBAction func closeButtonPressed(_ sender: ArcusButton) {
        if self.delegate != nil {
            self.delegate?.closeButtonPressed?(sender, alertView: self)
        }
    }
}
