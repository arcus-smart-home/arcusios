//
//  HaloTestingViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/6/16.
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

class HaloTestingViewController: UIViewController {

  var deviceModel: DeviceModel!

  @IBOutlet var detailsView: UIView!
  @IBOutlet weak var lastTestedLabel: UILabel!
  @IBOutlet weak var successLabel: ArcusLabel!
  @IBOutlet weak var failureDescriptionLabel: UILabel!
  @IBOutlet weak var reviewLabel: UILabel!
  @IBOutlet weak var getSupportButton: ArcusButton!
  @IBOutlet weak var successLineTopConstraint: NSLayoutConstraint!

  class func create(_ deviceModel: DeviceModel) -> HaloTestingViewController {
    let viewController: HaloTestingViewController? = UIStoryboard(name: "DeviceDetailSettingHalo", bundle:nil)
      .instantiateViewController(withIdentifier: "HaloTestingViewController")
      as? HaloTestingViewController
    viewController?.deviceModel = deviceModel
    return viewController!
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToLastNavigateColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: NSLocalizedString("Testing", comment: ""))

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(remoteTestResultStateChanged(_:)),
                   name: Model.attributeChangedNotificationName(kAttrHaloRemotetestresult),
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(remoteTestResultStateChanged(_:)),
                   name: Model.attributeChangedNotificationName(kAttrTestLastTestTime),
                   object: nil)

    self.failureDescriptionLabel.isHidden = true
    self.getSupportButton.isHidden = true
    self.reviewLabel.isHidden = true

    updateLastTestingStatus()
  }

  func updateLastTestingStatus() {
    let testStatus =  HaloCapability.getRemotetestresultFrom(self.deviceModel)
    if testStatus == "SUCCESS" {
      self.successLabel.text = "SUCCESS"
      self.failureDescriptionLabel.isHidden = true
      self.reviewLabel.isHidden = true
      self.successLineTopConstraint.constant = 15
    } else {
      self.successLabel.text = "FAILED"
      self.failureDescriptionLabel.isHidden = false
      self.reviewLabel.isHidden = false
      self.getSupportButton.isHidden = false
      self.successLineTopConstraint.constant = 35

      if testStatus == kEnumHaloRemotetestresultFAIL_ION_SENSOR ||
        testStatus == kEnumHaloRemotetestresultFAIL_PHOTO_SENSOR ||
        testStatus == "FAIL_SMOKE_SENSOR" {
        self.failureDescriptionLabel.text = NSLocalizedString("FAIL_SMOKE_SENSOR", comment: "")
      } else if testStatus ==
        kEnumHaloRemotetestresultFAIL_CO_SENSOR {
        self.failureDescriptionLabel.text =
          NSLocalizedString(kEnumHaloRemotetestresultFAIL_CO_SENSOR, comment: "")
      } else if testStatus == kEnumHaloRemotetestresultFAIL_TEMP_SENSOR {
        self.failureDescriptionLabel.text =
          NSLocalizedString(kEnumHaloRemotetestresultFAIL_TEMP_SENSOR, comment: "")
      } else if testStatus ==
        kEnumHaloRemotetestresultFAIL_WEATHER_RADIO {
        self.failureDescriptionLabel.text =
          NSLocalizedString(kEnumHaloRemotetestresultFAIL_WEATHER_RADIO, comment: "")
      } else {
        self.failureDescriptionLabel.text =
          NSLocalizedString(kEnumHaloRemotetestresultFAIL_OTHER, comment: "")
      }
    }
    let date = TestCapability.getLastTestTime(from: self.deviceModel)
    if let date = date {
      self.lastTestedLabel.text = "Last Tested: " + (date as NSDate).formatDateStampWithYear()
    }
  }

  func remoteTestResultStateChanged(_ notification: Notification) {
    DispatchQueue.main.async(execute: {
      self.hideGif()
      self.updateLastTestingStatus()
    })
  }

  @IBAction func testNowPressed(_ sender: AnyObject) {
    DispatchQueue.global(qos: .background).async {
      DispatchQueue.global(qos: .background).async {
        _ = HaloCapability.startTest(on: self.deviceModel).swiftThen ({ _ in
          self.createGif()
          self.popupMessageWindow(NSLocalizedString("Test", comment: ""),
                                  subtitle: NSLocalizedString("A test signal sent to the device.",
                                                              comment: ""))
          return nil
        })
      }
    }
  }

  @IBAction func getSupportPressed(_ sender: AnyObject) {
    UIApplication.shared.openURL(NSURL.SupportDeviceTroubleshooting)
  }

}
