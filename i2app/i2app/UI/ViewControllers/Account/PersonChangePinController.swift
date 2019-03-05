//
//  PersonChangePinController.swift
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

import Foundation
import Cornea

@objc protocol PersonChangePinControllerDelegate {
    @objc optional func newPinIsValid(_ isValid: Bool)
    @objc optional func confirmPinIsValid(_ isValid: Bool)
    @objc optional func pinChangeDidFinish(_ success: Bool, error: NSError?)
}

class PersonChangePinController: NSObject {
    weak var delegate: PersonChangePinControllerDelegate!
    var currentPerson: PersonModel!
    var currentPlace: PlaceModel!

    let pinLength: Int = 4 // Default to 4,

    var changeInProgress: Bool = false

    var newPin: String? {
        didSet {
            let isValid: Bool = (self.newPin?.characters.count == self.pinLength)

            self.delegate.newPinIsValid?(isValid)
        }
    }

    var confirmPin: String? {
        didSet {
            let isValid: Bool = (self.confirmPin?.characters.count == self.pinLength)
                && (self.confirmPin! == self.newPin!)

            self.delegate.confirmPinIsValid?(isValid)
        }
    }

    // MARK: Initialization
    required init(person: PersonModel, place: PlaceModel, delegate: PersonChangePinControllerDelegate) {
        super.init()
        self.currentPerson = person
        self.currentPlace = place
        self.delegate = delegate
    }

    // MARK: Data I/O
    func changePin() {
        if self.changeInProgress == false {
            DispatchQueue.global(qos: .background).async {
                self.changeInProgress = true
                PersonController.setPin(self.newPin,
                    placeId: self.currentPlace.modelId as String!,
                personModel: self.currentPerson) {
                    (success: Bool, error: Error?) in
                    self.changeInProgress = false
                    self.delegate.pinChangeDidFinish?(success, error: error as NSError?)
                }
            }
        }
    }
}
