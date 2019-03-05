//
//  File.swift
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

@objc protocol ArcusInputAccessoryProtocol {
    @objc optional func previousToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView)
    @objc optional func nextToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView)
    func doneToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView)
}

class ArcusInputAccessoryView: UIView {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var previousButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!

    internal weak var inputDelegate: ArcusInputAccessoryProtocol?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func previousBarButtonItemPressed(_ sender: UIBarButtonItem) {
        self.inputDelegate?.previousToolBarButtonPressed?(self)
    }

    @IBAction func nextBarButtonItemPressed(_ sender: UIBarButtonItem) {
        self.inputDelegate?.nextToolBarButtonPressed?(self)
    }

    @IBAction func doneBarButtonItemPressed(_ sender: UIBarButtonItem) {
        self.inputDelegate?.doneToolBarButtonPressed(self)
    }
}
