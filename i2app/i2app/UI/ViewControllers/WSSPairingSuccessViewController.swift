//
//  WSSPairingSuccessViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/27/16.
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

struct WSSPairingInfoConstants {
    static let kTitle = "InfoTitle"
    static let kDescription = "InfoDescription"

    static let typeOptionsArray: [[String : String]] =
        [[kTitle: "Cue the Christmas Lights",
            kDescription: "Create a schedule to turn on holiday lights every " +
            "night at sunset."],
         [kTitle: "A Warm Welcome Home",
            kDescription: "Use the Arcus app to turn on a light before arriving home."],
         [kTitle: "Prepare Dinner from Anywhere",
            kDescription: "Start the slow cooker at the office, arrive home to " +
            "a freshly-cooked meal."]]
}

class WSSPairingSuccessViewController: BaseDeviceStepViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    // MARK: View LifeCycle
    class func create() -> WSSPairingSuccessViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "PairDevice", bundle:nil)
        let viewController: WSSPairingSuccessViewController? =
            storyboard.instantiateViewController(withIdentifier: String(
                describing: WSSPairingSuccessViewController.self))
                as? WSSPairingSuccessViewController

        return viewController!
    }

    class func create(_ pairingStep: PairingStep) -> WSSPairingSuccessViewController {
        let viewController: WSSPairingSuccessViewController = WSSPairingSuccessViewController.create()
        viewController.setDeviceStep(pairingStep)

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavBar()
        self.configureBackground()
        self.configureTableView()
    }

    // MARK: UI Configuration
    func configureNavBar() {
        self.navBar(withCloseButtonAndTitle: self.navigationItem.title)
    }

    func configureBackground() {
        self.setBackgroundColorToDashboardColor()
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)
    }

    func configureTableView() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = nil
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
    }

    override func close(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WSSPairingInfoConstants.typeOptionsArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "PersonTypeCell"

        let cell: ArcusTitleDetailTableViewCell? =
            tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
                as? ArcusTitleDetailTableViewCell

        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none

        let optionInfo = WSSPairingInfoConstants.typeOptionsArray[indexPath.row]

        cell?.titleLabel.text = optionInfo[WSSPairingInfoConstants.kTitle]
        cell?.descriptionLabel.text = optionInfo[WSSPairingInfoConstants.kDescription]

        return cell!
    }
}
