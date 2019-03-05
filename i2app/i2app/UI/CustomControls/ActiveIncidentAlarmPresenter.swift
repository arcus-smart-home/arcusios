//
//  ActiveIncidentAlarmPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/16/17.
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

protocol ActiveIncidentAlarmPresenterProtocol {
  init(delegate: ActiveIncidentAlarmPresenterDelegateProtocol)
  /// All alert types can be in this list. Will at least have .None
  var data: [ActiveAlarmIncidentType] { get }
  var activeIncidentState: IncidentAlertState { get }
}

/// Protocol for consuming the ActiveIncidentAlarmPresenterProtocol as a delegate
protocol ActiveIncidentAlarmPresenterDelegateProtocol: class {
  func updateLayout()
}

enum ActiveAlarmIncidentType: Int {
  case security
  case panic
  case smokeAndCO
  case water
  case care
  case none
}

extension ActiveAlarmIncidentType: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .security:
      return "Security"
    case .panic:
      return "Panic"
    case .smokeAndCO:
      return "SmokeAndCO"
    case .water:
      return "Water"
    case .care:
      return "Care"
    case .none:
      return "None"
    }

  }
}

/// Class to manage the current active Incident that should be displayed to the user
class ActiveIncidentAlarmPresenter: NSObject, ActiveIncidentAlarmPresenterProtocol, AlarmSubsystemController,
AlarmModelController, BatchNotificationObserver {

  weak var delegate: ActiveIncidentAlarmPresenterDelegateProtocol?

  /// All alert types can be in this list. Will at least have .None
  var data: [ActiveAlarmIncidentType] = [.none]

  var activeIncidentState: IncidentAlertState {
    if subsystemModel.hasAttributes() {
      if let alarmState = alarmState(subsystemModel) {
        if let state = IncidentAlertState(rawValue: alarmState) {
          return state
        }
      }
    }
    // Fallback
    return .complete

  }

  required init(delegate incDelegate: ActiveIncidentAlarmPresenterDelegateProtocol) {
    delegate = incDelegate
    data = [.none]
    if let alarmSubsystem: SubsystemModel = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
    super.init()
    self.observeChangeEvents()
  }

  func setViewModelsFromModel() {

    let oldData = self.data

    guard subsystemModel.hasAttributes() else {
      data = [.none]
      delegate?.updateLayout()
      return
    }
    data = activeAlerts(subsystemModel).map { name in
      if let name = name as? String {
        switch name {
        case kEnumAlarmIncidentAlertSECURITY:
          return .security
        case kEnumAlarmIncidentAlertPANIC:
          return .panic
        case kEnumAlarmIncidentAlertSMOKE:
          return .smokeAndCO
        case kEnumAlarmIncidentAlertCO:
          return .smokeAndCO
        case kEnumAlarmIncidentAlertWATER:
          return .water
        case kEnumAlarmIncidentAlertCARE:
          return .care
        default:
          return .none
        }
      }
      return .none
    }

    if let careController = SubsystemsController.sharedInstance().careController,
      careController.isAlarmTriggered {
      data.append(.care)
    }

    if data.count == 0 {
      data = [.none]
    }
    if oldData != data {
      delegate?.updateLayout()
    }
  }

  // MARK: - AlarmSubsystemController

  var subsystemModel: SubsystemModel = SubsystemModel()
  var careSubsystemController: CareSubsystemController? = SubsystemsController.sharedInstance().careController

  func observeChangeEvents() {
    let cacheChangeSelector = #selector(ActiveIncidentAlarmPresenter.alarmSubsystemNotification(_:))
    observeBatchNotifications(subsystemChangedNotifications(), selector: cacheChangeSelector)

    let onLogout = #selector(ActiveIncidentAlarmPresenter.onLogout(_:))
    observeBatchNotifications(cacheClearedNotifications(), selector: onLogout)

    let onActiveAlertsChangeSelector = #selector(ActiveIncidentAlarmPresenter.onActiveAlerts(_:))
    observeBatchNotifications(activeAlertsChangeNotifications(), selector: onActiveAlertsChangeSelector)

    let onCareAlarmChangeSelector = #selector(ActiveIncidentAlarmPresenter.onCareAlarm(_:))
    observeBatchNotifications(careAlertsChangedNotifications(), selector: onCareAlarmChangeSelector)
  }

  private func subsystemChangedNotifications() -> [Notification.Name] {
    return [Notification.Name.subsystemCacheInitialized,
            Notification.Name.subsystemCacheUpdated,
            Notification.Name.subsystemInitialized,
            Notification.Name.subsystemUpdated]
  }

  private func cacheClearedNotifications() -> [Notification.Name] {
    return [Notification.Name.allUserStatesCleared,
            Notification.Name.subsystemCacheCleared]
  }

  private func activeAlertsChangeNotifications() -> [Notification.Name] {
    return [Model.attributeChangedNotificationName(kAttrAlarmSubsystemActiveAlerts)]
  }

  private func careAlertsChangedNotifications() -> [Notification.Name] {
    return [Model.attributeChangedNotificationName(kAttrCareSubsystemAlarmState)]
  }

  @objc func alarmSubsystemNotification(_ note: Notification) {
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
    if let careSubsystemController = SubsystemsController.sharedInstance().careController {
      self.careSubsystemController = careSubsystemController
    }
    setViewModelsFromModel()
  }

  @objc func onActiveAlerts(_ note: Notification) {
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
    setViewModelsFromModel()
  }

  @objc func onCareAlarm(_ note: Notification) {
    if let careSubsystemController = SubsystemsController.sharedInstance().careController {
      self.careSubsystemController = careSubsystemController
    }
    setViewModelsFromModel()
  }

  @objc func onLogout(_ note: Notification) {
    data = [.none]
    delegate?.updateLayout()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
