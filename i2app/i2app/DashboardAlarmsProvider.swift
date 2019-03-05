//  DashboardAlarmsProvider.swift
//  i2app
//
//  Created by Arcus Team on 1/5/17.
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

protocol DashboardAlarmsProvider: AlarmSubsystemController,
AlarmModelController,
UpgradeLegacySubsystemProvider {
  var alarmSubsystem: SubsystemModel { get set }

  // MARK: Extended

  func fetchDashboardAlarms()
}

enum StatusText {
  case on
  case off
  case partial
  case okay
  case smoke
  case co
  case water
  case care
  case security
  case panic
  case weather
  case learnMore

  var text: String {
    switch self {
    case .learnMore:
      return NSLocalizedString("Learn More", comment: "Alarm Cell text")
    case .on:
      return NSLocalizedString("On", comment: "On Alarm Cell")
    case .off:
      return NSLocalizedString("Off", comment: "Off Alarm Cell")
    case .partial:
      return NSLocalizedString("Partial", comment: "Partial Alarm Cell")
    case .okay:
      return NSLocalizedString("Okay", comment: "Okay Alarm Cell")
    case .security:
      return NSLocalizedString("Security", comment: "Security Alarm Cell")
    case .panic:
      return NSLocalizedString("Panic", comment: "Panic Alarm Cell")
    case .smoke:
      return NSLocalizedString("Smoke", comment: "Smoke Alarm Cell")
    case .co:
      return NSLocalizedString("CO", comment: "CO Alarm Cell")
    case .water:
      return NSLocalizedString("Water Leak", comment: "Water Leak Alarm Cell")
    case .care:
      return NSLocalizedString("Care", comment: "Care Alarm Cell")
    case .weather:
      return NSLocalizedString("Weather", comment: "Weather Alarm Cell")
    }
  }

  static func forMode(_ mode: String?, _ activeAlerts: [AnyObject]?) -> StatusText {
    if let activeAlerts = activeAlerts as? [String],
      let current = activeAlerts.first {
      switch current {
      case kEnumAlarmIncidentAlertSECURITY:
        return .security
      case kEnumAlarmIncidentAlertPANIC:
        return .panic
      case kEnumAlarmIncidentAlertSMOKE:
        return .smoke
      case kEnumAlarmIncidentAlertCO:
        return .co
      case kEnumAlarmIncidentAlertWATER:
        return .water
      case kEnumAlarmIncidentAlertCARE:
        return .care
      case kEnumAlarmIncidentAlertWEATHER:
        return .weather
      default:
        break
      }
    }
    if mode != nil {
      switch mode! {
      case kEnumAlarmSubsystemSecurityModeINACTIVE:
        return .learnMore
      case kEnumAlarmSubsystemSecurityModeDISARMED:
        return .off
      case kEnumAlarmSubsystemSecurityModeON:
        return .on
      case kEnumAlarmSubsystemSecurityModePARTIAL:
        return .partial
      default:
        return .okay
      }
    } else {
      return .off
    }
  }
}

extension DashboardAlarmsProvider where Self: DashboardProvider {
  func fetchDashboardAlarms() {
    let viewModel = DashboardAlarmsViewModel()
    viewModel.isEnabled = true
    viewModel.status = ""
    
    // #warning Check for Promod not premium
    var isProMonitored = false
    if let isMonitored: Bool = RxCornea.shared.settings?.isProMonitoredAccount() {
      isProMonitored = isMonitored
    }
    if isProMonitored {
      viewModel.proIndicator = true
    } else {
      viewModel.proIndicator = false
    }

    if !self.alarmSubsystem.hasAttributes() {
      self.storeViewModel(viewModel)
      return
    }

    DispatchQueue.global(qos: .background).async {
      let securityMode: String? = self.securityMode(self.alarmSubsystem)

      if self.isSubsystemSuspended(self.alarmSubsystem) {
        viewModel.status = NSLocalizedString("Upgrade", comment: "")
      } else {
        // Format the status text to be displayes in the cell i.e. Learn More, Okay, etc
        
        var status: StatusText = StatusText.forMode(securityMode,
                                                    self.activeAlerts(self.alarmSubsystem) as [AnyObject])
       
        // If the status is learn more, check if the other alarms have any devices before
        // processing it. If they have any devices then the status should change to Okay
        if status == .learnMore {
          if self.numberOfNonSecurityAlarmDevices() > 0 {
            status = .okay
            viewModel.hasSmallText = false
          } else {
            viewModel.hasSmallText = true
          }
        } else {
          viewModel.hasSmallText = false
        }
        
        viewModel.status = status.text
      }
      
      let currentColorScheme: ActiveAlarmIncidentType =
        NavigationBarAppearanceManager.sharedInstance.currentColorScheme
      
      switch currentColorScheme {
      case .none, .care:
        viewModel.backgroundColor = UIColor.clear
      case .panic, .security, .smokeAndCO, .water:
        viewModel.backgroundColor = currentColorScheme.cellTintColor
      }
      
      // Check if local alarms are needed.
      if let currentHub: HubModel = RxCornea.shared.settings?.currentHub,
        currentHub.isDown == true
          && self.provider(self.alarmSubsystem) == kEnumAlarmSubsystemAlarmProviderHUB {
        viewModel.isOfflineMode = true

        if viewModel.backgroundColor == UIColor.clear {
          viewModel.status = NSLocalizedString("Unable to Notify", comment: "")
        }
      } else if RxCornea.shared.settings?.currentHub == nil && self.allSwannCamerasOffline() {
        viewModel.isOfflineMode = true
        
        if viewModel.backgroundColor == UIColor.clear {
          viewModel.status = NSLocalizedString("Unable to Notify", comment: "")
        }
      } else {
        viewModel.isOfflineMode = false
      }
      
      self.storeViewModel(viewModel)
    }
  }
  
  private func allSwannCamerasOffline() -> Bool {
    guard let devices = RxCornea.shared.modelCache?.fetchModels(Constants.deviceNamespace) as? [DeviceModel] else {
      return false
    }
    
    let swannCameras = devices.filter { $0.isSwannCamera }
    let offlineSwannCameras = swannCameras.filter { $0.isDeviceOffline() }
    
    return swannCameras.count > 0 && swannCameras.count == offlineSwannCameras.count
  }
  
  private func numberOfNonSecurityAlarmDevices() -> Int {
    var alarmDevices: Int = 0
    
    if let smokeModel: AlarmModel = smokeModel(alarmSubsystem) {
      alarmDevices += devices(smokeModel).count
    }
    if let coModel: AlarmModel = coModel(alarmSubsystem) {
      alarmDevices += devices(coModel).count
    }
    if let waterModel: AlarmModel = waterModel(alarmSubsystem) {
      alarmDevices += devices(waterModel).count
    }
    if let panicModel: AlarmModel = panicModel(alarmSubsystem) {
      alarmDevices += devices(panicModel).count
    }
    
    return alarmDevices
  }
}
