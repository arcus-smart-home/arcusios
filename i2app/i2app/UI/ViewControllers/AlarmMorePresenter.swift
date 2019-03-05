//
//  AlarmMorePresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/6/17.
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

/// Alarm More Presenter
protocol AlarmMorePresenterProtocol {
  weak var delegate: GenericPresenterDelegate? { get set }
  init(delegate: GenericPresenterDelegate)
  var data: [AlarmMoreSection]? { get }

  /// Fetch the models from the Subsystem
  func fetch()

  /// handles the toggling of certain cells, Record onf Security Alarm and Water Shutoff
  func toggleObject(_ state: Bool, atIndexPath: IndexPath)
}

/// AlarmMorePresenter for injection
protocol AlarmMorePresenterTestable : class {
  var data: [AlarmMoreSection]? { get set }
  /// For Injection of Models to turn it into the correct View Models
  func setViewModelsFromModels()
}

struct AlarmMoreConstants {
  static let discoverMoreUrl = NSURL(string: "")!
}

/// Model of a Section for a Tableview or Collection View
struct AlarmMoreSection {
  var title: String!
  var imageNames: [String]!
  var cells: [AlarmMoreCellViewModel]!

  init (title: String, imageNames: [String], cells: [AlarmMoreCellViewModel]) {
    self.title = title
    self.imageNames = imageNames
    self.cells = cells
  }
}

/// Two major types of Cells
enum AlarmMoreCellType {
  case generic
  case toggle
}

/// ViewModel of a AlarmMoreCell
struct AlarmMoreCellViewModel {

  var type: AlarmMoreCellType
  var title: String
  var subtitle: String
  var destination: AlarmMoreSegueIdentifier

  /// Could be a subclass but this data will be duplicated on every cell even if it isn't toggled
  var toggled: Bool

  init(function: AlarmMoreCellType,
       title: String,
       subtitle: String,
       toggled: Bool,
       destination: AlarmMoreSegueIdentifier) {
    self.type = function
    self.title = title
    self.subtitle = subtitle
    self.toggled = toggled
    self.destination = destination
  }
}

/// Segues originating from the AlarmMoreViewController
/// These Strings must match with Storyboard Segue Identifiers
enum AlarmMoreSegueIdentifier: String {
  case AlarmSounds = "ShowAlarmSounds"
  case NotificationList = "ShowNotificationList"
  case GracePeriod = "ShowGracePeriod"
  case AlarmRequirements = "ShowAlarmRequirements"
  case AlarmRequirementsInfo = "ShowAlarmRequirementsInfo"
  case None = "ErrorIfUsed"

  /// Note the next case is unused since functionality is in the cell itself
  //case WaterShutoffValve = "ShowAlarmSounds"
}

/// Presenter for Alarm More View
class AlarmMorePresenter: AlarmMorePresenterProtocol,
AlarmMorePresenterTestable,
AlarmSubsystemController,
AlarmModelController {

  // MARK: AlarmSubsystemController
  var subsystemModel: SubsystemModel = SubsystemModel() {
    didSet {
      delegate?.updateLayout()
    }
  }

  var safetyController: SafetySubsystemAlertController?

  // MARK: AlarmMorePresenterProtocol
  weak var delegate: GenericPresenterDelegate?

  required init(delegate: GenericPresenterDelegate) {
    self.delegate = delegate
    self.safetyController = SubsystemsController.sharedInstance().safetyController
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
        self.subsystemModel = alarmSubsystem
    }
    self.observeChangeEvents()
  }

  /// Data, View Models publicly visible to the Presenter's Delegate
  /// If no data the Presenter should display more info
  var data: [AlarmMoreSection]? = Sections.emptyData {
    didSet {
      delegate?.updateLayout()
    }
  }

  func fetch() {
    DispatchQueue.global(qos: .background).async {
      self.setViewModelsFromModels()
    }
  }

  func toggleObject(_ state: Bool, atIndexPath: IndexPath) {
    guard let data = data,
      data.count - 1 >= atIndexPath.section,
      data[atIndexPath.section].cells.count - 1 >= atIndexPath.row else {
        return
    }
    let cell = data[atIndexPath.section].cells[atIndexPath.row]
    if cell.title == Sections.securitySettings.cells.last?.title {
      toggleRecordOnSecurityAlarm(state)
    } else if cell.title == Sections.waterLeakSettings.cells.first?.title {
      toggleWaterShutoff(state)
    } else if cell.title == Sections.smokeAndCoSettings.cells[0].title {
      toggleFanShutoffOnSmoke(state)
    } else if cell.title == Sections.smokeAndCoSettings.cells[1].title {
      toggleFanShutoffOnCO(state)
    }
  }

  /// param: turnWaterOff true if a leak turns off the water
  func toggleWaterShutoff(_ turnWaterOff: Bool) {
    DispatchQueue.global(qos: .background).async {
      if let safetyController = self.safetyController {
        var tagName = AnalyticsTags.AlarmsWaterOff
        if turnWaterOff {
          tagName = AnalyticsTags.AlarmsWaterOn
        }
        ArcusAnalytics.tag(named: tagName)
        safetyController.setWaterShutOff(turnWaterOff)
      }
    }
  }

  /// param: turnRecordOn true if an Alarm starts a recording
  func toggleRecordOnSecurityAlarm(_ turnRecordOn: Bool) {
    DispatchQueue.global(qos: .background).async {
      _ = self.setRecordOnSecurity(self.subsystemModel, recordOnSecurity: turnRecordOn)
    }
  }

  /// param: turnRecordOn true if a Fan Should be turned on a Smoke Event
  func toggleFanShutoffOnSmoke(_ turnOnFan: Bool) {
    DispatchQueue.global(qos: .background).async {
      _ = self.setFanShutoffOnSmoke(self.subsystemModel, fanShutoffOnSmoke: turnOnFan)
    }
  }

  /// param: turnOnFan true if a Fan Should be turned on a CO Event
  func toggleFanShutoffOnCO(_ turnOnFan: Bool) {
    DispatchQueue.global(qos: .background).async {
      _ = self.setFanShutoffOnCO(self.subsystemModel, fanShutoffOnCO: turnOnFan)
    }
  }

  func setViewModelsFromModels() {
    let activeAlarmModels = alarmModels(subsystemModel).filter({ model in
      let state = alertState(model)
      switch state {
      case kEnumAlarmSubsystemAlarmStateINACTIVE:
        return false
      default:
        return true
      }
    })

    guard activeAlarmModels.count >= 0 else {
      // data should be `nil` if no Alarm Subsystems are Active
      self.data = nil
      return
    }

    var builtVMs = [AlarmMoreSection]()

    var hasDevices: Bool {
      let allDevices = alarmModels(subsystemModel).flatMap {
        return self.devices( $0 )
      }
      return allDevices.count > 0
    }

    // Global Section
    builtVMs.append(Sections.globalSettings)

    // Security Section
    var hasSecurity: Bool {
      guard let securityModel = securityModel(subsystemModel),
        alertState(securityModel) != kEnumAlarmSubsystemAlarmStateINACTIVE else {
          return false
      }
      return true
    }

    if hasSecurity {
      var securitySections = Sections.securitySettings
      if !recordingSupported(subsystemModel) {
        securitySections.cells.removeLast()
      } else {
        var recordCell = securitySections.cells.last!
        recordCell.toggled = getRecordOnSecurity(subsystemModel)
        securitySections.cells.removeLast()
        securitySections.cells.append(recordCell)
      }
      builtVMs.append(securitySections)
    }

    // Smoke & CO Settings
    if fanShutoffSupported(subsystemModel) {
      var smokeAndCoSection = Sections.smokeAndCoSettings
      smokeAndCoSection.cells.removeAll()
      if let smokeModel = smokeModel(subsystemModel) {
        var smokeCell = Sections.smokeAndCoSettings.cells[0]
        smokeCell.toggled = fanShutoffOnSmoke(subsystemModel)
        if alertState(smokeModel) != kEnumAlarmSubsystemAlarmStateINACTIVE {
          smokeAndCoSection.cells.append(smokeCell)
        }
      }
      if let coModel = coModel(subsystemModel) {
        var coCell = Sections.smokeAndCoSettings.cells[1]
        coCell.toggled = fanShutoffOnCO(subsystemModel)
        
        if alertState(coModel) != kEnumAlarmSubsystemAlarmStateINACTIVE {
          smokeAndCoSection.cells.append(coCell)
        }
      }
      builtVMs.append(smokeAndCoSection)
    }

    // Water Leak Section
    if let safetyController = safetyController {
      var hasWaterSection: Bool {
        guard let waterModel = waterModel(subsystemModel),
          alertState(waterModel) != kEnumAlarmSubsystemAlarmStateINACTIVE
            && safetyController.hasWaterShutOffVales() else {
            return false
        }
        return true
      }
      if hasWaterSection {
        //Display Section
        var waterLeakSection = Sections.waterLeakSettings
        var cell = waterLeakSection.cells.first!
        cell.toggled = safetyController.getWaterShutOff()
        // set because its a struct
        waterLeakSection.cells = [cell]
        builtVMs.append(waterLeakSection)
      }
    }

    self.data = nil
    if hasDevices {
      self.data = builtVMs
    }
  }

  // Mark: Observe change events
  func observeChangeEvents() {
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(AlarmMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheInitialized,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(AlarmMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheUpdated,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(AlarmMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheCleared,
                   object: nil)
  }

  @objc func alarmSubsystemNotification(_ note: Notification) {
    guard let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() else {
      data = nil
      return
    }
    self.subsystemModel = alarmSubsystem
    fetch()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  /// Internal Class to create View Models
  class Sections {

    static let emptyData: [AlarmMoreSection]? = nil

    static let globalSettings: AlarmMoreSection =
      AlarmMoreSection(title: "Global Settings",
                       imageNames: ["security_small", "Smoke", "co", "water_leak"],
                       cells:
        [
          AlarmMoreCellViewModel(
            function: .generic,
            title: "ALARM SOUNDS",
            subtitle: "Control sounds during an alarm",
            toggled: false,
            destination: .AlarmSounds),
          AlarmMoreCellViewModel(
            function: .generic,
            title: "NOTIFICATION LIST",
            subtitle: "Learn How to Alert Others",
            toggled: false,
            destination: .NotificationList)
        ]
    )

    static let securitySettings: AlarmMoreSection =
      AlarmMoreSection(title: "Security Settings", imageNames: ["security_small"], cells:
        [
          AlarmMoreCellViewModel(
            function: .generic,
            title: "GRACE PERIODS",
            subtitle: "Time Needed to Enter & Exit",
            toggled: false,
            destination: .GracePeriod),
          AlarmMoreCellViewModel(
            function: .generic,
            title: "ALARM REQUIREMENTS",
            subtitle: "Number of Motion Sensors that need to be triggered before the Grace Period begins",
            toggled: false,
            destination: .AlarmRequirements),
          AlarmMoreCellViewModel(
            function: .toggle,
            title: "RECORD SECURITY ALARM",
            subtitle: "Initiate a 5 min recording of all Cameras upon a triggered Security Alarm.",
            toggled: false,
            destination: .None)
        ]
    )

    static let smokeAndCoSettings: AlarmMoreSection =
      AlarmMoreSection(title: "Smoke & CO Settings",
                       imageNames: ["Smoke", "co"],
                       cells:
        [
          AlarmMoreCellViewModel(
            function: .toggle,
            title: "SMOKE SAFETY SHUT OFF",
            subtitle: "Set all Thermostats, Fans, and Space Heaters to Off when a Smoke Alarm is triggered",
            toggled: false,
            destination: .None),
          AlarmMoreCellViewModel(
            function: .toggle,
            title: "CO SAFETY SHUTOFF",
            subtitle: "Set all Thermostats, Fans, and Space Heaters to Off when a CO Alarm is triggered",
            toggled: false,
            destination: .None)
        ]
    )

    static let waterLeakSettings: AlarmMoreSection =
      AlarmMoreSection(title: "Water Leak Settings", imageNames: ["water_leak"], cells:
        [
          AlarmMoreCellViewModel(
            function: .toggle,
            title: "WATER SHUT OFF VALVE",
            subtitle: "Turn water off when a leak is detected",
            toggled: true,
            destination: .None)
        ]
    )

    /// Mock of the Data that the user can click
    static let fullData: [AlarmMoreSection] =
      [globalSettings,
       securitySettings,
       smokeAndCoSettings,
       waterLeakSettings]

  }

}
