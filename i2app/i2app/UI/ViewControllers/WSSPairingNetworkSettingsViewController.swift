//
//  WSSPairingNetworkSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/13/16.
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

import NetworkExtension
//import NetworkExtension.NEHotspotHelper

@objc class WSSPairingNetworkSettingsViewController: BaseDeviceStepViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  UITextFieldDelegate,
  UIScrollViewDelegate,
ArcusInputAccessoryProtocol {
  typealias WifiSelectionCompletionSwift =
    ((_ selectedNetworkIndex: NSNumber?, _ isManualEntry: Bool) -> Void)

  @IBOutlet var tableView: UITableView!
  @IBOutlet var textFieldInputAccessoryView: ArcusInputAccessoryView! {
    didSet {
      textFieldInputAccessoryView.inputDelegate = self
      textFieldInputAccessoryView.doneButton
        .setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white],
                                for: UIControlState())
    }
  }
  @IBOutlet var tableViewBottomSpacingConstraint: NSLayoutConstraint!

  var networkSSIDTextField: AccountTextField? {// TEMP until NEHotspotHelper
    didSet {
      networkSSIDTextField?.inputAccessoryView = textFieldInputAccessoryView
    }

  }
  var networkKeyTextField: AccountTextField? {
    didSet {
      networkKeyTextField?.inputAccessoryView = textFieldInputAccessoryView
    }
  }

  var ssidClearButton: UIButton?
  var keyClearButton: UIButton?

  var networkName: String = ""
  var networkKey: String = ""

  var errorPopUp: PopupSelectionWindow?

  // MARK: View LifeCycle
  class func create() -> WSSPairingNetworkSettingsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "PairDevice", bundle:nil)
    let viewController: WSSPairingNetworkSettingsViewController? =
      storyboard.instantiateViewController(withIdentifier: String(
        describing: WSSPairingNetworkSettingsViewController.self))
        as? WSSPairingNetworkSettingsViewController
    return viewController!
  }

  class func create(_ pairingStep: PairingStep) -> WSSPairingNetworkSettingsViewController {
    let viewController = WSSPairingNetworkSettingsViewController.create()
    viewController.setDeviceStep(pairingStep)

    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureNavBar()
    configureBackground()
    configureTableView()
  }

  @IBAction override func nextButtonPressed(_ sender: Any) {
    if networkSSIDTextField?.isFirstResponder == true {
      networkSSIDTextField?.resignFirstResponder()
    } else if networkKeyTextField?.isFirstResponder == true {
      networkKeyTextField?.resignFirstResponder()
    }

    if networkName.count > 0 {
      createGif()

      if let externalSettingsViewController = DevicePairingManager.sharedInstance().pairingWizard
        .createNextStepObject(true) as? WSSPairingExternalSettingsViewController {
        externalSettingsViewController.ssid = networkName
        externalSettingsViewController.key = networkKey
      }
    } else {
      popupErrorWindow("Wi-Fi Set-up is Required",
                       subtitle: "Please Enter Your Network Name and try again.")
    }
  }

  @IBAction func clearButtonPressed(_ sender: AnyObject) {
    if let clearButton = sender as? UIButton {
      if clearButton == ssidClearButton {
        networkSSIDTextField?.text = ""
      } else if clearButton == keyClearButton {
        networkKeyTextField?.text = ""
      }
      clearButton.isHidden = !clearButton.isHidden
    }
  }

  // MARK: UI Configuration
  func configureNavBar() {
    navBar(withBackButtonAndTitle: navigationItem.title)
  }

  func configureBackground() {
    setBackgroundColorToDashboardColor()
    addWhiteOverlay(BackgroupOverlayMiddleLevel)
  }

  func configureTableView() {
    tableView.backgroundColor = UIColor.clear
    tableView.backgroundView = nil
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
  }

  // MARK - UITableViewDataSource
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      return ssidTextFieldCell(tableView, forRowAtIndexPath: indexPath)
    case 1:
      return passwordTextFieldCell(tableView, forRowAtIndexPath: indexPath)
    default:
      return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
  }

  func ssidTextFieldCell(_ tableVIew: UITableView,
                         forRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell: SettingsTextFieldTableViewCell? = tableView
      .dequeueReusableCell(withIdentifier: "SSIDCell") as? SettingsTextFieldTableViewCell
    cell?.backgroundColor = UIColor.clear

    cell?.textField.tag = indexPath.row
    //        cell?.textField.userInteractionEnabled = false
    cell?.textField.textColor = UIColor.black
    cell?.textField.floatingLabelTextColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.floatingLabelActiveTextColor = UIColor.black
    cell?.textField.activeSeparatorColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.separatorColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.placeholder = "Wifi Network"

    cell?.textField.setupType(AccountTextFieldTypeGeneral,
                              fontType: FontDataType_Medium_18_Black_NoSpace,
                              placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)

    cell?.selectionStyle = .none
    cell?.clearButton.isHidden = (cell!.textField.text?.count == 0)

    networkSSIDTextField = cell!.textField
    ssidClearButton = cell!.clearButton

    return cell!
  }

  func passwordTextFieldCell(_ tableVIew: UITableView,
                             forRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cell: WSSSecuritySettingsTableViewCell? = tableView
      .dequeueReusableCell(withIdentifier: "NetworkKeyCell") as? WSSSecuritySettingsTableViewCell
    cell?.backgroundColor = UIColor.clear

    cell?.textField.tag = indexPath.row
    cell?.textField.textColor = UIColor.black
    cell?.textField.floatingLabelTextColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.floatingLabelActiveTextColor = UIColor.black
    cell?.textField.activeSeparatorColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.separatorColor = UIColor.black.withAlphaComponent(0.4)
    cell?.textField.delegate = self
    cell?.textField.placeholder = "Password"

    cell?.textField.setupType(AccountTextFieldTypeGeneral,
                              fontType: FontDataType_Medium_18_Black_NoSpace,
                              placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)

    cell?.selectionStyle = .none
    cell?.clearButton.isHidden = (cell!.textField.text?.count == 0)

    cell?.configureTapGesture()

    networkKeyTextField = cell!.textField
    keyClearButton = cell!.clearButton

    return cell!
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      //            performSegueWithIdentifier("SelectNetworkModal", sender: self)
      //            performSegueWithIdentifier("ShowManuallyEnterSSID", sender: self)
      break
    case 2:

      break
    default: break

    }
  }

  // MARK: UITextFieldDelegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    tableView.isScrollEnabled = true
    tableViewBottomSpacingConstraint.constant = 100
    tableView.layoutIfNeeded()
    scrollToRowIndex(textField.tag)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == networkKeyTextField {
      networkKey = textField.text!
        .trimmingCharacters(in: CharacterSet.whitespaces)
    } else if textField == networkSSIDTextField {
      networkName = textField.text!
        .trimmingCharacters(in: CharacterSet.whitespaces)
    }

    scrollToRowIndex(0)
    tableView.isScrollEnabled = false
    tableViewBottomSpacingConstraint.constant = 0
    tableView.layoutIfNeeded()
  }

  func scrollToRowIndex(_ index: Int) {
    let indexPath: IndexPath = IndexPath(row: index,
                                         section: 0)
    tableView.scrollToRow(at: indexPath,
                          at: .top,
                          animated: true)
  }

  // MARK: ArcusInputAccessoryProtocol
  func doneToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView) {
    if networkKeyTextField?.isFirstResponder == true {
      networkKeyTextField?.resignFirstResponder()
    } else if networkSSIDTextField?.isFirstResponder == true {
      networkSSIDTextField?.resignFirstResponder()
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SelectNetworkModal" {
      if let wifiSelectionViewController =
        segue.destination as? WifiNetworkSelectionPopupViewController {
        wifiSelectionViewController.selectionCompletion = {
          (selectedNetworkIndex: NSNumber?, isManualEntry: Bool) -> Void in
          if isManualEntry == true {
            self.performSegue(withIdentifier: "ShowManuallyEnterSSID", sender: self)
          }
        }
      }
    } else if segue.identifier == "ManuallyEnterSSID" {
      if let confirmSSIDViewController =
        segue.destination as? WSSConfirmSSIDViewController {
        confirmSSIDViewController.completion = {
          (SSID: String, confirmSSID: String) -> Void in
          self.networkName = SSID
        }
      }
    }
  }
}
