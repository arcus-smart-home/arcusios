//
//  ProMonGateSettingsViewController.swift
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

class ProMonGateSettingsViewController: UIViewController, UITextFieldDelegate, ProMonGateSettingsDelegate {

  fileprivate var presenter: ProMonGateSettingsPresenter?
  internal var placeId: String = ""

  @IBOutlet weak var gateField: AccountTextField!

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    gateField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    gateField.delegate = self

    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(self.onHideKeyboard)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.presenter = ProMonGateSettingsPresenter(delegate: self, placeId: self.placeId)
  }

  // MARK: ProMonGateSettingsDelegate

  func showGate(_ gateCode: String?) {
    guard let gateCode = gateCode else { return }
    gateField.text = gateCode
  }

  func onGateSaveSuccess() {
    self.navigationController?.popViewController(animated: false)
  }

  func onGateSaveError() {
    displayGenericErrorMessage()
  }

  func onHideKeyboard() {
    self.gateField.resignFirstResponder()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    onHideKeyboard()
    return true
  }

  // MARK: IBActions

  @IBAction func onSave(_ sender: AnyObject) {
    if let code = gateField.text {
      presenter?.saveGateCode(code)
    } else {
      presenter?.saveGateCode("")
    }
  }
}
