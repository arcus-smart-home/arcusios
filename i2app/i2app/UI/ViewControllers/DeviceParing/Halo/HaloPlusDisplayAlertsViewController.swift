//
//  HaloPlusDisplayAlertsViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/1/16.
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

class HaloPlusDisplayAlertsViewController: UIViewController {

    @objc class func create() -> HaloPlusDisplayAlertsViewController {
        let vc: HaloPlusDisplayAlertsViewController = (UIStoryboard(name: "PairHalo", bundle: nil)
            .instantiateViewController(withIdentifier: "HaloPlusDisplayAlertsViewController")
            as? HaloPlusDisplayAlertsViewController)!

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackgroundColorToDashboardColor()
        self.navBar(withBackButtonAndTitle: "Weather Radio")
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)
    }

    @IBAction func informationButtonPressed(_ sender: AnyObject) {
        let vc: HaloDefaultAlertsViewController = HaloDefaultAlertsViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        DevicePairingManager.sharedInstance().pairingWizard.createNextStepObject(true)
    }

    func back(_ sender: NSObject!) {
        self.navigationController?.popViewController(animated: true)
    }
}
