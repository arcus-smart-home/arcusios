//
//  AlarmOfflineWarningPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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

import Cornea

/**
 View model for the alarm offline data.
 */
struct AlarmOfflineWarningViewModel {
  var offlineDateTime = ""
  var lastAlarmMode = ""
  var modemText = ""
  var activeIncident = ""
  var isPromonitoring = false
}

protocol AlarmOfflineWarningPresenterDelegate: class {
  
  /**
   Should update the views with the given alarm offline warning data.
   
   - Parameter viewModel: The object containing the data for the update
   */
  func updateViews(forViewModel viewModel: AlarmOfflineWarningViewModel)

  /**
  Notifies the delegate that the hub has come back online
  */
  func hubBecameOnline()
}

protocol AlarmOfflineWarningPresenterProtocol {
  
  /**
   Object containing the subsystem model
   */
  var subsystemModel: SubsystemModel { get }
  
  /**
   Data needed to represent the alarm offline warning
  */
  var viewModel: AlarmOfflineWarningViewModel { get }
  
  // MARK: Extended
  
  /**
   Retrieves the data for the alarm offline warning. Once the data is ready, the presenter delegate will be 
   notified to update it's views.
   */
  func fetchAlarmOfflineWarningData()
}

class AlarmOfflineWarningPresenter: AlarmOfflineWarningPresenterProtocol, AlarmModelController,
  AlarmSubsystemController {

  weak var delegate: AlarmOfflineWarningPresenterDelegate?
  private(set) var subsystemModel = SubsystemModel()
  private(set) var viewModel = AlarmOfflineWarningViewModel()
  
  init(delegate: AlarmOfflineWarningPresenterDelegate) {
    self.delegate = delegate

    // Observe Notifications
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleHubChange),
                                           name: Notification.Name.subsystemUpdated,
                                           object: nil)

    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      subsystemModel = alarmSubsystem
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func handleHubChange() {
    guard let currentHub = RxCornea.shared.settings?.currentHub else { return }
    if currentHub.isDown != true {
      delegate?.hubBecameOnline()
    }
  }
  
  func fetchAlarmOfflineWarningData() {

    var viewModel = AlarmOfflineWarningViewModel()

    if let incident = currentIncident(subsystemModel), !incident.isEmpty {
      viewModel.activeIncident = incident
    } else {
      viewModel.activeIncident = ""
    }

    // Check for a pro monitoring account
    if let isProMonitored = RxCornea.shared.settings?.isProMonitoredAccount() {
      viewModel.isPromonitoring = isProMonitored
    }

    // Get alarm subsystem mode
    let mode = getSecurityMode(subsystemModel)

    switch mode {
    case kEnumAlarmSubsystemSecurityModeINACTIVE:
      viewModel.lastAlarmMode = NSLocalizedString("", comment: "")
    case kEnumAlarmSubsystemSecurityModeDISARMED:
      viewModel.lastAlarmMode = NSLocalizedString("Off", comment: "")
    case kEnumAlarmSubsystemSecurityModeON:
      viewModel.lastAlarmMode = NSLocalizedString("On", comment: "")
    case kEnumAlarmSubsystemSecurityModePARTIAL:
      viewModel.lastAlarmMode = NSLocalizedString("Partial", comment: "")
    default:
      break
    }

    // Data when the hub went offline
    if let offlineDate = RxCornea.shared.settings?.currentHub?.lastChange {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "E MMM d"
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      let formattedDate = dateFormatter.string(from: offlineDate)
      
      let timeFormatter = DateFormatter()
      timeFormatter.dateFormat = "h:mm a"
      timeFormatter.calendar = Calendar(identifier: .gregorian)
      let formattedTime = timeFormatter.string(from: offlineDate)
      
      viewModel.offlineDateTime = "\(formattedTime) on \(formattedDate)"
    }
    
    self.viewModel = viewModel
    
    self.delegate?.updateViews(forViewModel: viewModel)
  }
}
