//
//  PersonChangePinViewController.swift
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

class PersonChangePinViewController: ArcusPinCodeViewController, PersonChangePinControllerDelegate {
  internal var currentPersonId: String = ""
  fileprivate var currentPerson: PersonModel?
  internal var currentPlace: PlaceModel?

  var pinController: PersonChangePinController?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.currentPerson = RxCornea.shared.modelCache?
      .fetchModel(PersonModel.addressForId(currentPersonId)) as? PersonModel

    if self.currentPerson != nil {
      self.createPinController()
    } else {
      self.createGif()
      DispatchQueue.global(qos: .background).async {
        _ = PersonController.listPersons(for: self.currentPlace!)
          .swiftThen { _ in
            self.hideGif()

            self.currentPerson = RxCornea.shared.modelCache?
              .fetchModel(PersonModel.addressForId(self.currentPersonId)) as? PersonModel
            self.createPinController()
            return nil
          }
          .swiftCatch { error in
            guard let error = error as? Error else { return nil }
            self.hideGif()

            self.displayErrorMessage(error.localizedDescription)
            return nil
        }
      }
    }
    self.setBackgroundColorToParentColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if pinController == nil {
      createPinController()
    } else {
      pinController?.delegate = self
    }
  }

  func createPinController() {
    self.pinController = PersonChangePinController.init(person: self.currentPerson!,
                                                        place: self.currentPlace!,
                                                        delegate: self)
  }

  // MARK: IBActions
  @IBAction override func numericButtonPressed(_ sender: UIButton!) {
    super.numericButtonPressed(sender)

    self.pinController?.newPin = self.enteredPin
  }

  // MARK: PersonChangePinControllerDelegate
  func newPinIsValid(_ isValid: Bool) {
    if isValid {
      self.performSegue(withIdentifier: "PersonConfirmPinCodeSegue", sender: self)
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PersonConfirmPinCodeSegue" {
      let confirmPinViewController: PersonConfirmPinViewController? =
        segue.destination as? PersonConfirmPinViewController
      confirmPinViewController?.pinController = self.pinController
    }
  }
}
