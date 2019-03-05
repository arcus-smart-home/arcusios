//
//  CameraLocalStreamingSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/10/16.
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

class CameraLocalStreamingSettingsViewController: UIViewController, CameraLocalStreamingCallback {
    @IBOutlet var usernameLabel: ArcusLabel!
    @IBOutlet var passwordLabel: ArcusLabel!
    @IBOutlet var urlLabel: ArcusLabel!
    @IBOutlet var addressLabel: ArcusLabel!

    var cameraLocalStreamingPresenter: CameraLocalStreamingPresenter!

    var deviceModel: DeviceModel!

    class func create(_ deviceModel: DeviceModel) -> CameraLocalStreamingSettingsViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "DeviceDetailSetting", bundle:nil)
        let viewController = storyboard
          .instantiateViewController(withIdentifier: "CameraLocalStreamingSettingsViewController")
            as? CameraLocalStreamingSettingsViewController

        viewController?.deviceModel = deviceModel

        return viewController!
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cameraLocalStreamingPresenter = CameraLocalStreamingPresenter(model: self.deviceModel,
                                                                           callback: self)

        self.setBackgroundColorToLastNavigateColor()
        self.addDarkOverlay(BackgroupOverlayLightLevel)

        self.navBar(withBackButtonAndTitle: NSLocalizedString("LOCAL STREAMING", comment: ""))

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    // MARK: CameraLocalStreamingCallback

    func showStreamingInformation(_ localStream: LocalStream) {

        self.usernameLabel.text = localStream.username
        self.passwordLabel.text = localStream.password
        self.urlLabel.text = localStream.streamUrl
        self.addressLabel.text = localStream.ipAddress
    }

    func showCredentialsFetchError() {
        self.displayGenericErrorMessage()
    }

}
