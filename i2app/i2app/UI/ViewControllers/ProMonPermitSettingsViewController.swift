//
//  ProMonPermitSettingsViewController.swift
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

class ProMonPermitSettingsViewController: UIViewController,
  ProMonPermitSettingsDelegate,
UITextFieldDelegate {

  internal var placeId: String = ""
  fileprivate var presenter: ProMonPermitSettingsPresenter?

  @IBOutlet weak var permitField: AccountTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    permitField.delegate = self
    permitField.setAccountFieldStyle(AccountTextFieldStyleWhite)

    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(self.onHideKeyboard)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.presenter = ProMonPermitSettingsPresenter(delegate: self, placeId: self.placeId)
  }


  func showPermit(_ permit: String?) {
    if let permit = permit {
      permitField.text = permit
    } else {
      permitField.text = ""
    }
  }

  func onPermitSaveSuccess() {
    self.navigationController?.popViewController(animated: false)
  }

  func onPermitSaveError() {
    displayGenericErrorMessage()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    onHideKeyboard()
    return true
  }

  func onHideKeyboard() {
    permitField.resignFirstResponder()
  }

  @IBAction func onSave(_ sender: AnyObject) {
    presenter?.savePermit(permitField.text ?? "")
  }
}
