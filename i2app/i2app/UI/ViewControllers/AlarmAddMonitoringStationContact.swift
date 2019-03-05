//
//  AlarmAddMonitoringStationContact.swift
//  i2app
//
//  Arcus Team on 4/7/17.
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

public class AlarmAddMonitoringStationContact: UIViewController, AlarmAddContactDelegate {

  private var presenter: AlarmAddContactPresenterProtocol?
  private var popupWindow: PopupSelectionWindow?

  public override func viewDidLoad() {
    super.viewDidLoad()

    configureBackgroundGradient()
    navBarWithCloseButtonAndTitleImage()

    presenter = AlarmAddContactPresenter(delegate: self)
  }

  // MARK: UI COnfiguration
  func configureBackgroundGradient() {
    let gradientLayer = CAGradientLayer()

    let green = UIColor(red: 0x21/255.0,
                         green: 0xB0/255.0,
                         blue: 0x9C/255.0,
                         alpha: 1.0).cgColor as CGColor

    let blue = UIColor(red: 0x23/255.0,
                         green: 0x8D/255.0,
                         blue: 0xC2/255.0,
                         alpha: 1.0).cgColor as CGColor

    gradientLayer.frame = view.bounds
    gradientLayer.colors = [green, blue]
    gradientLayer.locations = [0.0, 1.0]

    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  func onContactAdded() {
    self.navigationController?.popViewController(animated: true)
  }

  func onCantAccessContact() {
    onErrorAddingContact()
  }

  func onErrorAddingContact() {
    displayPopUp(title: "CANNOT ACCESS CONTACTS",
                 subtitle: "Go to your iOS Settings > Privacy > Contacts to allow "
                  + "\"Arcus\" to access your contacts.")
  }

  func displayPopUp(title: String, subtitle: String) {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }

    let buttonView: PopupSelectionButtonsView =
      PopupSelectionButtonsView.create(withTitle: title,
                                       subtitle: subtitle,
                                       buttons: [])
    buttonView.owner = self

    popupWindow = PopupSelectionWindow.popup(view,
                                             subview: buttonView,
                                             owner: self,
                                             close: #selector(closePopup(_:)),
                                             style: PopupWindowStyleCautionWindow)
  }

  func closePopup(_: AnyObject) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func onLearnMore(_ sender: AnyObject) {
    UIApplication.shared.openURL(AlarmAddContactConstants.supportUrl)
  }

  @IBAction func onAddContact(_ sender: AnyObject) {
    presenter!.addMonitoringStationContact()
  }

}
