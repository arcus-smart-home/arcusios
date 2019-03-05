//
//  PlaceProMonSettingsViewController.swift
//  i2app
//
//  Arcus Team on 2/14/17.
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

class PlaceProMonSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var placeId = ""
  var isOwned = true
  var presenter: PlaceProMonSettingsProtocol!

  @IBOutlet weak var settingsTableView: UITableView!

  @IBOutlet weak var downloadCertificateButton: ArcusButton!

  @IBAction func downloadCertificatePressed(_ sender: Any) {
    createGif()

    presenter.fetchAlarmCertificate()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter = PlaceProMonSettingsPresenter(delegate: self, placeId: self.placeId)

    downloadCertificateButton.isHidden = !isOwned

    settingsTableView.backgroundColor = UIColor.clear
    settingsTableView.backgroundView = nil
    settingsTableView.dataSource = self
    settingsTableView.delegate = self

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.presenter = PlaceProMonSettingsPresenter(delegate: self, placeId: self.placeId)
  }

  // MARK: UIViewController

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {

      if let vc = segue.destination as? ProMonPermitSettingsViewController,
        identifier == SettingsConstants.permitSetting.segue {
        vc.placeId = self.placeId
      }

      if let vc = segue.destination as? ProMonDirectionsSettingsViewController,
        identifier == SettingsConstants.directionsSetting.segue {
        vc.placeId = self.placeId
      }

      if let vc = segue.destination as? ProMonGateSettingsViewController,
        identifier == SettingsConstants.gateSetting.segue {
        vc.placeId = self.placeId
      }

      if let vc = segue.destination as? ProMonResponderSettingsViewController,
        identifier == SettingsConstants.responderSetting.segue {
        vc.placeId = self.placeId
      }

      if let vc = segue.destination as? ProMonWhoSettingsViewController,
        identifier == SettingsConstants.whoSetting.segue {
        vc.placeId = self.placeId
      }

      if identifier == "PromonSettingsToPreviewPDF" {
        if let destination = segue.destination as? UINavigationController,
          let preview = destination.topViewController as? AlarmCertificatePreviewViewController {
          preview.pdfData = presenter.certificateData
          preview.pdfURL = presenter.certificateURL
        }
      }
    }
  }

  // MARK: UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let touchedSetting = SettingsConstants.settings[indexPath.row]
    performSegue(withIdentifier: touchedSetting.segue, sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SettingsConstants.settings.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "ProMonSettingCell"

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    let setting = SettingsConstants.settings[indexPath.row]

    cell?.backgroundColor = UIColor.clear
    cell?.titleLabel.text = setting.title
    cell?.descriptionLabel.text = setting.description

    return cell!
  }

}

// MARK: PlaceProMonSettingsDelegate 

extension PlaceProMonSettingsViewController: PlaceProMonSettingsDelegate {
  func alarmCertificateRetrieved() {
    DispatchQueue.main.async {
      self.hideGif()

      self.performSegue(withIdentifier: "PromonSettingsToPreviewPDF", sender: self)
    }
  }

  func alarmCertificateFailure() {
    DispatchQueue.main.async {
      self.hideGif()

      let errorMessage = NSLocalizedString(
        "" +
        "Pro Monitoring Info to download.",
        comment: "")

      self.displayErrorMessage(errorMessage, withTitle: NSLocalizedString("UNABLE TO DOWNLOAD", comment: ""))
    }
  }
}

// MARK: Private Helpers

private enum SettingsCellType {
  case permit
  case directions
  case gate
  case responder
  case who
}

private struct Setting {
  let title: String
  let description: String
  let type: SettingsCellType
  let segue: String
}

private struct SettingsConstants {

  static let permitSetting =
    Setting.init(title: NSLocalizedString("Permit", comment: ""),
                 description: NSLocalizedString("Manage your permit code", comment: ""),
                 type: .permit,
                 segue: "segueToPermit")

  static let directionsSetting =
    Setting.init(title: NSLocalizedString("Additional Directions", comment: ""),
                 description: NSLocalizedString("Add additional details about your home", comment: ""),
                 type: .directions,
                 segue: "segueToDirections")

  static let gateSetting =
    Setting.init(title: NSLocalizedString("Gate Access", comment: ""),
                 description: NSLocalizedString("Provide your gate access code", comment: ""),
                 type:  .gate,
                 segue: "segueToGate")

  static let responderSetting =
    Setting.init(title: NSLocalizedString("First Responder Information", comment: ""),
                 description: NSLocalizedString("Add special instructions for first responders", comment: ""),
                 type: .responder,
                 segue: "segueToResponder")

  static let whoSetting =
    Setting.init(title: NSLocalizedString("Who Lives Here?", comment: ""),
                 description: NSLocalizedString("Update the occupants living at this residence", comment: ""),
                 type: .who,
                 segue: "segueToWho")

  static let settings = [permitSetting, directionsSetting, gateSetting, responderSetting, whoSetting]
}
