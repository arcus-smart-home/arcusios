//
//  AlarmStatusPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/20/16.
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
import PromiseKit

protocol AlarmStatusPresenterProtocol {
  var subsystemModel: SubsystemModel { get set }
  weak var delegate: AlarmStatusPresenterDelegate? { get set }
  var alarmStatusModels: [AlarmStatusViewModel] { get set }
  var partialIndicator: Bool { get set }
  var isSwitchingSecurityMode: Bool { get set }

  init(delegate: AlarmStatusPresenterDelegate)
  func fetchAlarmStatus()
  func tearDown()

  func disarmSecurityAlarm()
  func cancelSecurityAlarm()
  func armSecurityAlarm()
  func armBypassSecurityAlarm()
  func armPartialSecurityAlarm()
  func armBypassPartialSecurityAlarm()

  func alarmingColorForAlarmType(_ type: AlarmType) -> UIColor
  func currentAlarmIncident() -> String
  func isNextAlarmAlarming(_ currentType: AlarmType) -> Bool
  func indexOfStatusAlarmModelWithType(_ alarmType: AlarmType) -> Int
  func alarmStatusModelWithType(_ alarmType: AlarmType) -> AlarmStatusViewModel?
}

/// -seealso: AlarmStatusViewController
protocol AlarmStatusPresenterDelegate: class {
  func updateLayout()
  func updateSecurityCell(_ ringViewModel: AlarmStatusRingViewModel)
  func shouldPresentArmBypassWarning()
  func shouldPresentArmFailed(_ errorText: String)
  func shouldPresentDisarmFailed(_ errorText: String)
  func shouldPromptToAddContact()
  func shouldRestoreAlarmButtons()
}

class AlarmStatusPresenter: AlarmSubsystemController, AlarmModelController, AlarmIncidentController {

  // MARK: Public Properties

  weak var delegate: AlarmStatusPresenterDelegate?
  var alarmStatusModels = [AlarmStatusViewModel]()
  var partialIndicator = false
  var isSwitchingSecurityMode = false

  // MARK: Private Properties

  internal var subsystemModel = SubsystemModel()
  fileprivate var gracePeriodCountdown = 0
  fileprivate var gracePeriodTimer: Timer?

  // MARK: Public Functions

  required init(delegate: AlarmStatusPresenterDelegate) {
    self.delegate = delegate

    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      subsystemModel = alarmSubsystem
    }
  }

  // MARK: Private Functions

  @objc fileprivate func handleAlarmUpdate() {

    // Make sure subsystem model is updated before populating alarm status
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      subsystemModel = alarmSubsystem
    }

    populateStatusModels()
    delegate?.updateLayout()
  }

  @objc fileprivate func handleClearUpdate() {
    removeCountdownTimer()
    alarmStatusModels = [AlarmStatusViewModel]()

    delegate?.updateLayout()
  }

  @objc fileprivate func updateSecurityGracePeriod() {
    DispatchQueue.global(qos: .background).async {
      self.gracePeriodCountdown -= 1

      if self.gracePeriodCountdown < 1 {
        // Invalidate timer when it runs out
        self.removeCountdownTimer()
      } else {
        let security = self.alarmStatusModelWithType(.Security)

        if security != nil {
          security!.ringViewModel = self.createRingTimerViewModel(
            security?.ringViewModel?.ringSegments?.count,
            status: self.formatTimerText(self.gracePeriodCountdown))

          self.delegate?.updateSecurityCell(security!.ringViewModel!)
        }
      }
    }
  }

  fileprivate func createRingTimerViewModel(_ count: Int?,
                                            status: NSAttributedString) -> AlarmStatusRingViewModel {
    var deviceCount = 0
    if let count = count {
        deviceCount = count
    }
    let state: AlarmRingState = .segmentedEnabled
    var segments = [ArcusAlarmRingSegmentState]()

    // Segments should be added in order: Offline -> Inactive -> Active
    if deviceCount > 0 {
      for _ in 1...deviceCount {
        segments.append(.inactive)
      }
    }

    return AlarmStatusRingViewModel(state: state,
                                    statusText: status,
                                    segments: segments)
  }
  
}

// MARK: AlarmStatusPresenterProtocol
extension AlarmStatusPresenter: AlarmStatusPresenterProtocol {
  func tearDown() {
    removeCountdownTimer()
  }

  func isNextAlarmAlarming(_ currentType: AlarmType) -> Bool {
    let indexOfCurrentType = indexOfStatusAlarmModelWithType(currentType)

    if indexOfCurrentType != NSNotFound && alarmStatusModels.count > 0 {
      let indexOfNextType = indexOfCurrentType + 1
      let lastIndex = alarmStatusModels.count - 1

      // If the current alarm type is not the last alarm status model then check if
      // the next alarm is alarming.
      if lastIndex > indexOfCurrentType {
        return isAlarmTypeAlarming(alarmStatusModels[indexOfNextType].alarmType)
      }
    }

    return false
  }

  func currentAlarmIncident() -> String {
    let incident = currentIncident(subsystemModel)

    if incident == nil {
      return ""
    } else {
      return incident!
    }
  }

  func alarmingColorForAlarmType(_ type: AlarmType) -> UIColor {
    switch type {
    case .CO:
      return Appearance.smokeAndCORed
    case .Smoke:
      return Appearance.smokeAndCORed
    case .Water:
      return Appearance.waterLeakTeal
    case .Security:
      return Appearance.securityBlue
    case .Panic:
      return Appearance.panicGrey
    }
  }

  func armSecurityAlarm() {
    partialIndicator = false
    callArmingSecurityAlarm()
  }

  func armPartialSecurityAlarm() {
    partialIndicator = true
    callArmingSecurityAlarm()
  }

  func armBypassSecurityAlarm() {
    partialIndicator = false
    callArmingBypassedSecurityAlarm()
  }

  func armBypassPartialSecurityAlarm() {
    partialIndicator = true
    callArmingBypassedSecurityAlarm()
  }

  func disarmSecurityAlarm() {
    callDisarmSecurityAlarm()
  }

  func cancelSecurityAlarm() {
    callDisarmSecurityAlarm()
  }

  func fetchAlarmStatus() {
    // Prompt pro users (only once ever) to add monitoring station contact to their address book
    guard let isProMonitored = RxCornea.shared.settings?.isProMonitoredAccount() else { return }

    if isProMonitored
      && !NavigationBarAppearanceManager.sharedInstance.isInAlarmState()
      && !UserDefaults.standard.bool(forKey: AlarmAddContactConstants.kUserHasBeenPromptedToAddContact) {
      UserDefaults.standard.set(true, forKey: AlarmAddContactConstants.kUserHasBeenPromptedToAddContact)
      self.delegate?.shouldPromptToAddContact()
    } else {
      DispatchQueue.global(qos: .background).async {
        self.observeNotifications()
        self.populateStatusModels()
        self.delegate?.updateLayout()
      }
    }
  }

  func alarmStatusModelWithType(_ alarmType: AlarmType) -> AlarmStatusViewModel? {
    for alarm in alarmStatusModels where alarm.alarmType == alarmType {
      return alarm
    }

    return nil
  }

  func indexOfStatusAlarmModelWithType(_ alarmType: AlarmType) -> Int {
    for (index, alarm) in alarmStatusModels.enumerated() where alarm.alarmType == alarmType {
      return index
    }

    return NSNotFound
  }


}

// MARK: View Model Manipulation
extension AlarmStatusPresenter {
  fileprivate func populateStatusModels() {
    var alarmStatusModels = [AlarmStatusViewModel]()
    let alarmModelList = alarmModels(subsystemModel)

    for alarmModel in alarmModelList {
      guard let name = alarmModel.getAttribute(kMultiInstanceTypeKey)
        as? String else {
          continue
      }

      // Transform the alarm name into a type.
      let alarmType = alarmModelNameToAlarmType(name)

      // Skip through Panic
      if alarmType == AlarmType.Panic {
        continue
      }

      var alarmStatusModel: AlarmStatusViewModel

      if isAlarmTypeAlarming(alarmType) {
        // Alarming

        alarmStatusModel = AlarmStatusViewModelFactory.alarmingStatusViewModel(alarmType)
      } else if devices(alarmModel).count < 1 {
        // Empty

        // Before Security is rendered empty check for Panic having devices
        let panicModel = retrievePanicModel()

        if alarmType == AlarmType.Security && panicModel != nil && devices(panicModel!).count > 0 {
          if isAlarmTypeAlarming(.Panic) {
            alarmStatusModel = AlarmStatusViewModelFactory.alarmingStatusViewModel(.Panic)
          } else {
            alarmStatusModel = AlarmStatusViewModelFactory.statusViewModelPanic()
          }
        } else {
          alarmStatusModel = AlarmStatusViewModelFactory.statusViewModelEmpty(alarmType)
        }
      } else if alarmType == AlarmType.Security {
        // Security

        // If Security is not alarming check if Panic is
        if isAlarmTypeAlarming(.Panic) {
          alarmStatusModel = AlarmStatusViewModelFactory.alarmingStatusViewModel(.Panic)
        } else {
          alarmStatusModel = statusViewModelSecurity(alarmModel)
        }
      } else {
        // Smoke, Water, CO
        let active = activeDevices(alarmModel).count
        let inactive = triggeredDevices(alarmModel).count
        let offline = offlineDevices(alarmModel).count

        alarmStatusModel = AlarmStatusViewModelFactory.statusViewModelGeneric(alarmType,
                                                                              activeDevices: active,
                                                                              triggeredDevices: inactive,
                                                                              offlineDevices: offline)
      }

      // Check if the current alarm has promonitoring available.
      alarmStatusModel.isPromonitored = getMonitored(alarmModel)

      alarmStatusModels.append(alarmStatusModel)
    }

    self.alarmStatusModels = alarmStatusModels
    self.orderViewModels()
  }

  fileprivate func orderViewModels() {
    var orderedViewModels = [AlarmStatusViewModel]()

    let smoke = alarmStatusModelWithType(.Smoke)
    let co = alarmStatusModelWithType(.CO)
    let water = alarmStatusModelWithType(.Water)
    let security = alarmStatusModelWithType(.Security)
    let panic = alarmStatusModelWithType(.Panic)

    if smoke != nil {
      orderedViewModels.append(smoke!)
    } else {
      orderedViewModels.append(AlarmStatusViewModelFactory.statusViewModelEmpty(.Smoke))
    }

    if co != nil {
      orderedViewModels.append(co!)
    } else {
      orderedViewModels.append(AlarmStatusViewModelFactory.statusViewModelEmpty(.CO))
    }

    if water != nil {
      orderedViewModels.append(water!)
    } else {
      orderedViewModels.append(AlarmStatusViewModelFactory.statusViewModelEmpty(.Water))
    }

    if panic != nil {
      orderedViewModels.append(panic!)
    } else if security != nil {
      orderedViewModels.append(security!)
    } else {
      orderedViewModels.append(AlarmStatusViewModelFactory.statusViewModelEmpty(.Security))
    }

    alarmStatusModels = orderedViewModels
  }

  fileprivate func updateArmBypassWarning(_ devices: [String]) {
    let statusModel = alarmStatusModelWithType(AlarmType.Security)!
    statusModel.triggeredDevices = [DeviceModel]()

    for device in devices {
      guard let model = RxCornea.shared.modelCache?.fetchModel(device) as?
        DeviceModel else {
          continue
      }

      statusModel.triggeredDevices.append(model)
    }

    delegate?.shouldPresentArmBypassWarning()
  }

  fileprivate func updateSecurityAlarmStatusWithDelay() {
    let indexOfSecurity = indexOfStatusAlarmModelWithType(AlarmType.Security)

    if indexOfSecurity != NSNotFound {
      alarmStatusModels[indexOfSecurity] =
        statusViewModelSecurity(alarmModels(subsystemModel)[indexOfSecurity])
      delegate?.updateLayout()
    }
  }

  fileprivate func retrievePanicModel() -> AlarmModel? {
    let panicIndex = indexOfAlarmModel(AlarmType.Panic.rawValue)
    let alarmModelList = alarmModels(subsystemModel)

    if panicIndex != NSNotFound {
      return  alarmModelList[panicIndex]
    }

    return nil
  }

  fileprivate func statusViewModelSecurity(_ alarmModel: AlarmModel) -> AlarmStatusViewModel {
    let alarmState = alertState(alarmModel)
    var alarmStatusViewModel: AlarmStatusViewModel!

    if alarmState == kEnumAlarmAlertStateDISARMED || alarmState == kEnumAlarmAlertStateCLEARING {
      // OFF
      removeCountdownTimer()
      if let disarmedDate = getSecurityDisarmedTime(subsystemModel) {
         alarmStatusViewModel = AlarmStatusViewModelFactory
          .statusSecurityOff(disarmedTime: (disarmedDate as NSDate).formatTimeStamp())
      } else {
         alarmStatusViewModel = AlarmStatusViewModelFactory.statusSecurityOff(disarmedTime: nil)
      }


    } else if alarmState == kEnumAlarmAlertStateARMING {
      // ARMING
      if let armTime = securityArmTime(subsystemModel) {
        addGracePeriodTimer(armTime)
      }

      alarmStatusViewModel = AlarmStatusViewModelFactory.statusSecurityArming(
        deviceCount: devices(alarmModel).count,
        countDown: gracePeriodCountdown)
    } else if alarmState == kEnumAlarmAlertStatePREALERT {
      // PRE ALERT
      if let address = currentIncident(subsystemModel),
        let incident = RxCornea.shared.modelCache?.fetchModel(address) as? AlarmIncidentModel,
        let endTime = getPrealertEndtime(incident) {

        // Ensure that the end time is in the furute
        if endTime < Date() {
          gracePeriodCountdown = 0
          removeCountdownTimer()
        } else {
          addGracePeriodTimer(endTime)
        }
      }

      alarmStatusViewModel = AlarmStatusViewModelFactory.statusSecurityPrealerting(
        countDown: gracePeriodCountdown)
    } else {
      // ON / PARTIAL
      removeCountdownTimer()
      var armedTime: String?
      if let armedDate = getSecurityArmedTime(subsystemModel) {
        armedTime = (armedDate as NSDate).formatTimeStamp()
      }
      let active = activeDevices(alarmModel).count
      let inactive = triggeredDevices(alarmModel).count
      let offline = offlineDevices(alarmModel).count
      let securityMode = getSecurityMode(subsystemModel)

      alarmStatusViewModel = AlarmStatusViewModelFactory.statusSecurityOnPartial(armedTime: armedTime,
                                                                                 active: active,
                                                                                 triggered: inactive,
                                                                                 offline: offline,
                                                                                 securityMode: securityMode)
    }

    return alarmStatusViewModel
  }
}

// MARK: Helper Functions
extension AlarmStatusPresenter {
  fileprivate func removeCountdownTimer() {
    DispatchQueue.main.async {
      guard self.gracePeriodTimer != nil else {
        return
      }

      self.gracePeriodTimer?.invalidate()
      self.gracePeriodTimer = nil
      self.gracePeriodCountdown = 0
    }
  }

  fileprivate func isAlarmTypeAlarming(_ type: AlarmType) -> Bool {
    if let alerts = activeAlerts(subsystemModel) as? [String] {
      for alert in alerts {
        if alert == alarmIncidentForType(type) {
          return true
        }
      }
    }

    return false
  }

  fileprivate func alarmIncidentForType(_ type: AlarmType) -> String {
    switch type {
    case .CO:
      return kEnumAlarmIncidentAlertCO
    case .Smoke:
      return kEnumAlarmIncidentAlertSMOKE
    case .Water:
      return kEnumAlarmIncidentAlertWATER
    case .Security:
      return kEnumAlarmIncidentAlertSECURITY
    case .Panic:
      return kEnumAlarmIncidentAlertPANIC
    }
  }

  fileprivate func observeNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlarmStatusPresenter.handleAlarmUpdate),
      name: Notification.Name.subsystemCacheInitialized,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlarmStatusPresenter.handleAlarmUpdate),
      name: Notification.Name.subsystemCacheUpdated,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlarmStatusPresenter.handleClearUpdate),
      name: Notification.Name.subsystemCacheCleared,
      object: nil)
  }

  fileprivate func indexOfAlarmModel(_ alarmName: String) -> Int {
    for (index, alarmModel) in alarmModels(subsystemModel).enumerated() {
      guard let name = alarmModel.getAttribute(kMultiInstanceTypeKey)
        as? String else {
          continue
      }
      if name == alarmName {
        return index
      }
    }
    return NSNotFound
  }

  fileprivate func alarmModelNameToAlarmType(_ alarmName: String) -> AlarmType {
    if alarmName == AlarmType.Security.rawValue {
      return AlarmType.Security
    } else if alarmName == AlarmType.Panic.rawValue {
      return AlarmType.Panic
    } else if alarmName == AlarmType.CO.rawValue {
      return AlarmType.CO
    } else if alarmName == AlarmType.Water.rawValue {
      return AlarmType.Water
    } else {
      return AlarmType.Smoke
    }
  }

  fileprivate func callArmingSecurityAlarm() {
    var mode = "ON"
    if partialIndicator {
      mode = "PARTIAL"
    }

    DispatchQueue.global(qos: .background).async {
      self.isSwitchingSecurityMode = true
      self.delegate?.updateLayout()

      _ = self.arm(self.subsystemModel, mode: mode).swiftThenInBackground({
        modelAnyObject in

        // Re enable the alarm buttons when the promise comes back
        self.isSwitchingSecurityMode = false
        self.delegate?.updateLayout()

        // Error
        if let error = modelAnyObject as? NSDictionary {

          let errorCode = error["code"] as? String
          let errorMessage = error["message"] as? String

          self.handleArmingError(code: errorCode, message: errorMessage)
        }

        return nil
      }).swiftCatch({ error in

        // Re enable the alarm buttons when the promise comes back
        self.isSwitchingSecurityMode = false
        self.delegate?.updateLayout()

        // Error
        if let error = error as? NSError {
          let errorCode = error.userInfo["code"] as? String
          let errorMessage = error.userInfo["message"] as? String

          self.handleArmingError(code: errorCode, message: errorMessage)
        }

        return nil
      })
    }
  }

  fileprivate func callArmingBypassedSecurityAlarm() {
    var mode = "ON"
    if partialIndicator {
      mode = "PARTIAL"
    }
    DispatchQueue.global(qos: .background).async {
      _ = self.armBypassed(self.subsystemModel, mode: mode).swiftThenInBackground({
        modelAnyObject in

        if let error = modelAnyObject as? NSDictionary {

          let errorCode = error["code"] as? String
          let errorMessage = error["message"] as? String

          self.handleArmingError(code: errorCode, message: errorMessage)
        }
        
        return nil
      }).swiftCatch({ error in

        // Re enable the alarm buttons when the promise comes back
        self.isSwitchingSecurityMode = false
        self.delegate?.updateLayout()

        // Error
        if let error = error as? NSError {
          let errorCode = error.userInfo["code"] as? String
          let errorMessage = error.userInfo["message"] as? String

          self.handleArmingError(code: errorCode, message: errorMessage)
        }

        return nil
      })
    }
  }

  private func isProMonitored() -> Bool {
    var isProMonitored: Bool = false
    guard let settings = RxCornea.shared.settings else {
      return false
    }
    return settings.isProMonitoredAccount()
  }

  private func handleArmingError(code: String?, message: String?) {
    if code == "security.triggeredDevices" {
      if let devicesString = message {
        let devices = devicesString.components(separatedBy: ",")
        updateArmBypassWarning(devices)
      } else {
        delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedInsufficientDevicesText)
      }
    } else if code == "security.insufficientDevices" {
      self.delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedInsufficientDevicesText)
    } else if code == "security.invalidState" && isProMonitored() == true {
      self.delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedProMonClearingText)
    } else if code == "security.hubDisarming" {
      self.delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedGenericText)
    } else if code == "UnknownDevice" {
      self.delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedHubOfflineText)
    } else {
      self.delegate?.shouldPresentArmFailed(AlarmStatusMessage.armFailedGenericText)
    }
  }

  fileprivate func callDisarmSecurityAlarm() {
    DispatchQueue.global(qos: .background).async {
      self.isSwitchingSecurityMode = true
      self.delegate?.updateLayout()

      _ = self.disarm(self.subsystemModel).swiftThenInBackground({
        modelAnyObject in

        self.isSwitchingSecurityMode = false
        self.delegate?.updateLayout()

        // Error
        if let error = modelAnyObject as? NSDictionary, error["code"] as? String == "UnknownDevice" {
          self.delegate?.shouldPresentDisarmFailed(AlarmStatusMessage.disarmFailedHubOfflineText)
        }

        self.populateStatusModels()
        self.delegate?.updateLayout()

        return nil
      }).swiftCatch({ error in

        self.isSwitchingSecurityMode = false
        self.delegate?.updateLayout()

        // Error
        if let error = error as? NSError, error.userInfo["code"] as? String == "UnknownDevice" {
          self.delegate?.shouldPresentDisarmFailed(AlarmStatusMessage.disarmFailedHubOfflineText)
        }
        
        return nil
      })
    }
  }

  fileprivate func formatTimerText(_ seconds: Int) -> NSAttributedString {
    let attributes: [String: AnyObject] = [
      NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!,
      NSForegroundColorAttributeName: UIColor(
        red: 255, green: 255, blue: 255, alpha: 0.7),
      NSBaselineOffsetAttributeName: 7.0 as AnyObject
    ]

    let time = NSMutableAttributedString(string: "\(seconds)")
    let s = NSAttributedString(string: " s", attributes:attributes)

    time.append(s)
    return time
  }

  fileprivate func addGracePeriodTimer(_ time: Date) {
    if gracePeriodCountdown > 0 {
      return
    }

    gracePeriodCountdown = Int(round(time.timeIntervalSinceNow))

    DispatchQueue.main.async(execute: { () -> Void in
      self.gracePeriodTimer = Timer.scheduledTimer(
        timeInterval: TimeInterval(1.0),
        target: self,
        selector: #selector(self.updateSecurityGracePeriod),
        userInfo: nil,
        repeats: true)
    })
  }
}
