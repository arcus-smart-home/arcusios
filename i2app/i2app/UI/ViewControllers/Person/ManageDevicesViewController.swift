//
//  ManageDevicesViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/16/16.
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

class ManageDevicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var mobileDevicesArray: [MobileDeviceModel]? = []
  var currentDevice: MobileDeviceModel?

  @IBOutlet weak var ownerPhoneLabel: UILabel!
  @IBOutlet weak var ownerPhoneDescriptionLabel: UILabel!
  @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLineView: UIView!

  @IBOutlet var tableView: UITableView! {
    didSet {
      self.tableView.backgroundColor = UIColor.clear
      self.tableView.estimatedRowHeight = 80
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.alwaysBounceVertical = false
    }
  }
  // MARK: View LifeCycle
  class func create() -> ManageDevicesViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "AccountSettings", bundle:nil)
    let viewController = storyboard
      .instantiateViewController(withIdentifier: String(describing: ManageDevicesViewController.self))
      as? ManageDevicesViewController

    return viewController!
  }

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
    self.navBar(withTitle: "Push Notifications", andRightButtonText: self.tableView.isEditing ?
      "Done" : "Edit", with: #selector(editDoneButtonPressed))
    self.addBackButtonItemAsLeftButtonItem()

    self.createGif()

    downloadDeviceList()
  }

  func downloadDeviceList() {
    DispatchQueue.global(qos: .background).async {
      _ = PersonController.getMobileDevicesList (RxCornea.shared.settings?.currentPerson)
        .swiftThen { deviceArray in
          self.mobileDevicesArray = deviceArray as? [MobileDeviceModel]
          if self.mobileDevicesArray!.count > 0 {
            // Register the header nib
            self.tableView.register(
              UINib(nibName:"ArcusTwoLabelTableViewSectionHeader", bundle:nil),
              forHeaderFooterViewReuseIdentifier:"sectionHeader")
            // find the current device
            let identifier: String! = AccountController.getDeviceUDID()
            var currentDevices: Array = self.mobileDevicesArray!.filter({
              if let deviceId = $0.getAttribute(kAttrMobileDeviceDeviceIdentifier) {
                return deviceId as? String == identifier
              } else {
                return false
              }
            })
            if currentDevices.count > 0 {
              self.currentDevice = currentDevices[0]
              if self.currentDevice != nil {
                self.ownerPhoneLabel.text = self.getMobilePhoneOsType(self.currentDevice!)
                self.ownerPhoneDescriptionLabel.text =
                  self.getMobilePhoneType(self.currentDevice!)
                if let index = self.mobileDevicesArray?.index(of: self.currentDevice!),
                  let count = self.mobileDevicesArray?.count {
                  if index >= 0 && index < count {
                    self.mobileDevicesArray?.remove(at: index)
                  }
                }
              } else {
                self.headerViewHeightConstraint.constant = 125
              }
            } else {
              self.titleLineView.isHidden = true
              self.headerViewHeightConstraint.constant = 125
            }
            self.tableView.reloadData()
          } else {
            self.titleLineView.isHidden = true
            self.headerViewHeightConstraint.constant = 125
            let vc: AccountNotificationViewController = AccountNotificationViewController.create()
            self.present(vc, animated: true, completion: nil)
          }
          self.hideGif()
          return nil
        }.swiftCatch { error in
          self.hideGif()
          self.displayGenericErrorMessageWithError(error as? NSError)
          return nil
      }
    }
  }
  // MARK: IBActions
  @IBAction func editDoneButtonPressed(_ sender: ArcusButton) {
    self.tableView.setEditing(!self.tableView.isEditing, animated:true)
    if self.tableView.isEditing {
      self.navBar(withTitle: "Push Notifications",
                  andRightButtonText: "Done",
                  with: #selector(editDoneButtonPressed))
    } else {
      self.navBar(withTitle: "Push Notifications",
                  andRightButtonText: "Edit",
                  with: #selector(editDoneButtonPressed))
    }
  }

  // MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    if self.mobileDevicesArray?.count == 0 {
      return 0
    }
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let countArray = self.mobileDevicesArray {
      return countArray.count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var header: ArcusTwoLabelTableViewSectionHeader? =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        as? ArcusTwoLabelTableViewSectionHeader
    if header == nil {
      header = ArcusTwoLabelTableViewSectionHeader(reuseIdentifier: "sectionHeader")
    }

    header?.hasBlurEffect = true
    header?.backingView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

    header?.mainTextLabel.text = "Other Devices"
    header?.mainTextLabel.textColor = UIColor.white

    header?.accessoryTextLabel.text = ""

    return header
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let CellIdentifier = "ArcusTitleDetailTableViewCell"
    let cell: ArcusTitleDetailTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        as? ArcusTitleDetailTableViewCell
    cell?.backgroundColor = UIColor.clear
    let mobileDevice = self.mobileDevicesArray?[indexPath.row]
    cell?.titleLabel.text = self.getMobilePhoneOsType(mobileDevice!)
    cell?.descriptionLabel.text = self.getMobilePhoneType(mobileDevice!)
    cell?.selectionStyle = UITableViewCellSelectionStyle.none

    return cell!
  }

  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      //numbers.removeAtIndex(indexPath.row)
      DispatchQueue.global(qos: .background).async {
        let mobileDevice = self.mobileDevicesArray![indexPath.row]
        PersonController
          .deleteMobileDevice(RxCornea.shared.settings?.currentPerson,
                              with: MobileDeviceCapability.getDeviceIndex(from: mobileDevice),
                              completion: { (success: Bool, error: Error?) in
                                DispatchQueue.main.async(execute: {
                                  if success && error == nil {
                                    self.mobileDevicesArray?.remove(at: indexPath.row)
                                    self.tableView.beginUpdates()
                                    if self.tableView.numberOfRows(inSection: indexPath.section) > 1 {
                                      self.tableView!.deleteRows(at: [indexPath],
                                                                 with: UITableViewRowAnimation.automatic)
                                    } else {
                                      self.tableView.deleteSections(IndexSet(integer: indexPath.section),
                                                                    with: .automatic)
                                    }
                                    self.tableView.endUpdates()
                                    self.popupMessageWindow("Heads Up", subtitle:
                                      "If you log in again, this device will start" +
                                      "\nreceiving push notifications.")
                                  } else {
                                    self.displayGenericErrorMessageWithError(error)
                                  }
                                })
          })
      }
    }
  }

  func getMobilePhoneOsType(_ mobileDevice: MobileDeviceModel) -> String {
    let osString = MobileDeviceCapability.getOsType(from: mobileDevice)
    var versionString = MobileDeviceCapability.getOsVersion(from: mobileDevice)
    if osString == "ios" {
      let words: Array = versionString!.components(separatedBy: " ")
      versionString = words[1] as String
    } else if osString == "Android" {
      let words: Array = versionString!.components(separatedBy: " ")
      versionString = words[2] as String
    }
    return osString!.uppercased() + " " + versionString!
  }

  func getMobilePhoneType(_ mobileDevice: MobileDeviceModel) -> String {
    return "Device Type: " + MobileDeviceCapability.getDeviceModel(from: mobileDevice)
  }
}
