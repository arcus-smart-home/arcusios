//
//  HueFallbackOperationViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/29/17.
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

class HueFallbackOperationViewController: DeviceOperationBaseController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: DeviceOperationBaseController Overrides

  override static func create(withDeviceId deviceId: String) -> DeviceOperationBaseController {
    let controller = self.create()
    controller.deviceId = deviceId

    if let deviceModel = RxCornea.shared.modelCache?
      .fetchModel(DeviceModel.addressForId(deviceId)) as? DeviceModel {
      controller.deviceModel = deviceModel
    }

    return controller
  }

  override static func create() -> DeviceOperationBaseController {
    let storyboard = UIStoryboard(name: "DeviceOperation", bundle: nil)
    let viewController =
      storyboard.instantiateViewController(withIdentifier: "HueFallbackOperationViewController")

    if let viewController = viewController as? HueFallbackOperationViewController {
      return viewController
    }

    return DeviceOperationBaseController()
  }

  override func deviceWillAppear(_ animated: Bool) {
    super.deviceWillAppear(animated)
  }

  override func updateDeviceState(_ attributes: [AnyHashable : Any], initialUpdate isInitial: Bool) {
    showFallbackBanner()
  }

  private func showFallbackBanner() {
    popupLinkAlert("Pairing to Hue Bridge Required",
                   type: AlertBarType.typeWarning,
                   sceneType: AlertBarSceneType.inDevice,
                   grayScale: true,
                   linkText: "Get Support",
                   selector: #selector(handleBannerTap),
                   displayArrow: true)
  }

  @objc private func handleBannerTap() {
    UIApplication.shared.open(NSURL.SupportImproperlyPairedHue)
  }

}
