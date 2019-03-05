//
//  AlarmOfflinePopup.swift
//  i2app
//
//  Created by Arcus Team on 8/2/17.
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

class AlarmOfflineWarningViewController: UIViewController, GradientColorable {
  
  // MARK: IBOutlets
  
  @IBOutlet weak var offlineDate: ArcusLabel!
  @IBOutlet weak var alarmMode: ArcusLabel!
  @IBOutlet weak var callAuthoritiesTextContainer: UIView!
  @IBOutlet weak var topContainerDivider: UIView!
  @IBOutlet weak var alarmModeContainer: UIView!
  @IBOutlet weak var alarmInfoContainer: UIView!
  @IBOutlet weak var offlineSinceContainer: UIView!
  @IBOutlet weak var supportButton: ArcusButton!

  // MARK: Properties

  private var presenter: AlarmOfflineWarningPresenterProtocol?

  // MARK: IBActions
  
  @IBAction func returnToDashboardPressed(_ sender: Any) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      dismiss(animated: true, completion: nil)
      ApplicationRoutingService.defaultService.showDashboard()
    }
  }
  
  @IBAction func getSupportPressed(_ sender: Any) {
    if let presenter = presenter {
      let incident = presenter.viewModel.activeIncident
      
      if incident.isEmpty {
        UIApplication.shared.openURL(NSURL.SupportHub)
      } else {
        // Navigate to the alarm tracket if there is an incident
        dismiss(animated: true, completion: nil)
        ApplicationRoutingService.defaultService.showDashboard()
        ApplicationRoutingService.defaultService.showAlarmIncident(presenter.subsystemModel,
                                                                   incidentId: incident)
      }
    }
  }

  // MARK: Lifecycle 
  
  override func viewDidLoad() {
    super.viewDidLoad()

    presenter = AlarmOfflineWarningPresenter(delegate: self)
    presenter?.fetchAlarmOfflineWarningData()

    // Add gradient
    addBackgroundGradient(inView: view,
                          topColor: GradientPresetColors.pinkLight,
                          bottomColor: GradientPresetColors.pinkDark)
  }
}

// MARK: AlarmOfflineWarningPresenterDelegate

extension AlarmOfflineWarningViewController: AlarmOfflineWarningPresenterDelegate {
  func hubBecameOnline() {
    dismiss(animated: true, completion: nil)
  }

  func updateViews(forViewModel viewModel: AlarmOfflineWarningViewModel) {
    DispatchQueue.main.async {
      
      if viewModel.offlineDateTime.isEmpty {
        self.offlineSinceContainer.isHidden = true
      } else {
        self.offlineSinceContainer.isHidden = false
        self.offlineDate.text = viewModel.offlineDateTime
      }
      
      if viewModel.lastAlarmMode.isEmpty || !viewModel.activeIncident.isEmpty {
        self.alarmModeContainer.isHidden = true
      } else {
        self.alarmMode.text = viewModel.lastAlarmMode
        self.alarmModeContainer.isHidden = false
      }
      
      self.topContainerDivider.isHidden = self.offlineSinceContainer.isHidden && self.alarmModeContainer.isHidden
      
      if viewModel.activeIncident.isEmpty {
        self.supportButton.setTitle(NSLocalizedString("GET SUPPORT", comment: ""), for: .normal)
        self.alarmInfoContainer.isHidden = true
      } else {
        self.supportButton.setTitle(NSLocalizedString("VIEW ALARM TRACKER™", comment: ""), for: .normal)
        self.alarmInfoContainer.isHidden = false
      }
      
      self.callAuthoritiesTextContainer.isHidden = !viewModel.isPromonitoring
    }
  }
}
