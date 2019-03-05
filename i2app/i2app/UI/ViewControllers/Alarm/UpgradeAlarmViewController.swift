//
//  UpgradeAlarmViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/3/17.
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

class UpgradeAlarmViewController: UIViewController, ContactSupportHandler {
  var presenter: UpgradeAlarmPresenter?
  var popupWindow: PopupSelectionWindow?

  static func configureWithSegue(_ segue: UIStoryboardSegue) {
    if let upgradeAlarmViewController = segue.destination as? UpgradeAlarmViewController {
      if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
        upgradeAlarmViewController.presenter =
          UpgradePresenter(delegate: upgradeAlarmViewController, alarmSubsystem: alarmSubsystem)
      }
    }
  }

  @IBAction func upgradeAlarmPressed(_ sender: AnyObject) {
    presenter?.upgradeAlarm()
  }

  @IBAction func contactSupport(_ sender: AnyObject) {
    contactCustomerSupport()
  }

  @IBAction func closeButtonPressed(_ sender: AnyObject) {
    dismiss()
  }

  // MARK: Popup Handling

  func displayPopUp(_ title: String, subtitle: String, isError: Bool) {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }

    var buttons: [PopupSelectionButtonModel]?
    var style = PopupWindowStyleMessageWindow

    if isError == true {
      buttons = [PopupSelectionButtonModel.create(customerSupportNumber(),
                                                  event: #selector(contactSupport(_:)))]
      style = PopupWindowStyleCautionWindow
    }

    let buttonView: PopupSelectionButtonsView =
      PopupSelectionButtonsView.create(withTitle: title,
                                       subtitle: subtitle,
                                       buttons: buttons)
    buttonView.owner = self

    popupWindow = PopupSelectionWindow.popup(view,
                                             subview: buttonView,
                                             owner: self,
                                             displyCloseButton: true,
                                             close: #selector(closePopup(_:)),
                                             style: style)
  }

  func closePopup(_ sender: AnyObject) {
    if presenter?.upgradeSuccessul == true {
      dismiss()
    }
  }

  func dismiss() {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

extension UpgradeAlarmViewController: UpgradeAlarmDelegate {
  func alarmUpgradeSuccessful() {
    DispatchQueue.main.async(execute: {
      self.displayPopUp("Upgrade Successful",
                        subtitle: "Your Alarm System has been upgraded.",
                        isError: false)
    })
  }

  func alarmUpgradeFailed() {
    DispatchQueue.main.async(execute: {
      self.displayPopUp("Upgrade Failed",
                        subtitle: "Please contact the support team for assistance.",
                        isError: true)
    })
  }
}
