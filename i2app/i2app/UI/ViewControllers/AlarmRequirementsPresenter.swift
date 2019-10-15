//
//  AlarmRequirementsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/10/17.
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

struct AlarmRequirementsConstants {
  static let shopURL = ""
}

struct AlarmRequirementsViewModel {
  /// For Ordering the display of the Two Types
  var requirements: [AlarmRequirementsType] = []

  init(alarmOnCount: Int,
       onCount: Int,
       alarmPartialCount: Int,
       partialCount: Int,
       onMotionSensorCount: Int,
       partialMotionSensorCount: Int) {
    let alarmOn = AlarmRequirementsType("On", alarmOnCount, onCount, onMotionSensorCount)
    let alarmPartial = AlarmRequirementsType("Partial",
                                             alarmPartialCount,
                                             partialCount,
                                             partialMotionSensorCount)
    self.requirements = [alarmOn, alarmPartial]
  }
}

struct AlarmRequirementsType {

  var title: String
  var toTrigger: Int
  var totalDevices: Int
  var motionSensorCount: Int

  var displayToTrigger: String {
    if motionSensorCount == 0 {
      return NSLocalizedString("0", comment: "Zero Participating - Alarm Requirements")
    }
    return "\(toTrigger)"
  }

  var canChange: Bool {
    if totalDevices <= 1 {
      return false
    }
    return true

  }

  init (_ title: String, _ toTrigger: Int, _ totalDevices: Int, _ motionSensorCount: Int) {
    self.title = title
    self.toTrigger = toTrigger
    self.totalDevices = totalDevices
    self.motionSensorCount = motionSensorCount
  }

}

protocol AlarmRequirementsPresenterProtocol {
  var delegate: GenericPresenterDelegate? { get set }
  init(delegate: GenericPresenterDelegate)
  func fetch()
  var data: AlarmRequirementsViewModel { get }

  func setAlarmOnCount(_ count: Int)
  func setPartialOnCount(_ count: Int)
}

protocol AlarmRequirementsPresenterProtocolCommunications: AlarmRequirementsPresenterProtocol {
  var securitySubSystemController: SecuritySubsystemAlertController { get set }
  func observeChangeEvents()
}

class AlarmRequirementsPresenter: AlarmRequirementsPresenterProtocol {

  weak var delegate: GenericPresenterDelegate?

  required init(delegate: GenericPresenterDelegate) {
    self.delegate = delegate
    self.observeChangeEvents()

  }

  func fetch() {
    if let securitySubSystemController = self.securitySubSystemController {
      self.createViewModels(securitySubSystemController)
    }
  }

  var data: AlarmRequirementsViewModel = Stubs.zerosStubData {
    didSet {
      delegate?.updateLayout()
    }
  }

  func setAlarmOnCount(_ count: Int) {
    var alarm = data.requirements[0]
    alarm.toTrigger = count
    data.requirements[0] = alarm
    delegate?.updateLayout()
    DispatchQueue.global(qos: .background).async {
      if let securitySubSystemController = self.securitySubSystemController {
        securitySubSystemController.setAlarmSensitivityOnMode(Int32(count))
      }
    }
  }

  func setPartialOnCount(_ count: Int) {
    var partial = data.requirements[1]
    partial.toTrigger = count
    data.requirements[1] = partial
    delegate?.updateLayout()
    DispatchQueue.global(qos: .background).async {
      if let securitySubSystemController = self.securitySubSystemController {
        securitySubSystemController.setAlarmSensitivityPartialMode(Int32(count))
      }
    }
  }

  func createViewModels(_ securitySubSystemController: SecuritySubsystemAlertController) {
    let alarmOnCount = Int(securitySubSystemController.alarmSensitivityOnDeviceCount())
    let onCount = securitySubSystemController.modeONDevices.count
    let alarmPartialCount = Int(securitySubSystemController.alarmSensitivityPartialDeviceCount())
    let partialCount = securitySubSystemController.modePARTIALDevices.count
    let onMotionSensorCount = Int(securitySubSystemController.numberOfOnMotionSensors)
    let partialMotionSensorCount = Int(securitySubSystemController.numberOfPartialMotionSensors)

    self.data = AlarmRequirementsViewModel(alarmOnCount: alarmOnCount,
                                           onCount: onCount,
                                           alarmPartialCount: alarmPartialCount,
                                           partialCount: partialCount,
                                           onMotionSensorCount: onMotionSensorCount,
                                           partialMotionSensorCount: partialMotionSensorCount)
  }

  // MARK: - SecuritySubsystemAlertController

  var securitySubSystemController: SecuritySubsystemAlertController? =
    SubsystemsController.sharedInstance().securityController

  func observeChangeEvents() {
    let center = NotificationCenter.default
    let changeSelector = #selector(AlarmRequirementsPresenter.securitySubSystemChanged(_:))
    let onEntranceDelaySecNoteName = Model.attributeChangedNotificationName("%@:ON")
    center.addObserver(self, selector: changeSelector, name: onEntranceDelaySecNoteName, object: nil)
    let partialEntranceDelaySecNoteName = Model.attributeChangedNotificationName("%@:PARTIAL")
    center.addObserver(self, selector: changeSelector, name: partialEntranceDelaySecNoteName, object: nil)
    let onExitDelaySecNoteName = Model.attributeChangedNotificationName("%@:ON")
    center.addObserver(self, selector: changeSelector, name: onExitDelaySecNoteName, object: nil)
    let partialExitDelaySecNoteName = Model.attributeChangedNotificationName("%@:PARTIAL")
    center.addObserver(self, selector: changeSelector, name: partialExitDelaySecNoteName, object: nil)
  }

  @objc fileprivate func securitySubSystemChanged(_ note: Notification) {
    guard let securitySubSystemController = SubsystemsController.sharedInstance().securityController else {
      return
    }
    self.securitySubSystemController = securitySubSystemController
    createViewModels(self.securitySubSystemController!)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  class Stubs {
    static let zerosStubData = AlarmRequirementsViewModel(alarmOnCount: 0,
                                                          onCount: 0,
                                                          alarmPartialCount: 0,
                                                          partialCount: 0,
                                                          onMotionSensorCount: 0,
                                                          partialMotionSensorCount: 0)
  }
}
