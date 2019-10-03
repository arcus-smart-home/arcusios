//
//  CancelLegacyAlarmPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/3/17.
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

protocol CancelLegacyAlarmPresenter {
  var delegate: CancelLegacyAlarmDelegate? { get set }
  var alarmState: LegacyAlarmState { get }
  var alarmColor: UIColor { get }
  var alarmTitle: String { get }

  func cancel()
}

protocol CancelLegacyAlarmDelegate: class {
  func alarmWasCancelled()
  func alarmCancellationFailed()
}

struct LegacyAlarmState: OptionSet {
  let rawValue: Int

  static let None = LegacyAlarmState(rawValue: 0)
  static let Security = LegacyAlarmState(rawValue: 1 << 0)
  static let Safety = LegacyAlarmState(rawValue: 1 << 1)
  static let Both  = LegacyAlarmState(rawValue: 1 << 2)

  static func alarmColor(_ state: LegacyAlarmState) -> UIColor {
    switch state {
    case LegacyAlarmState.None:
      return UIColor.clear
    case LegacyAlarmState.Security:
      return Appearance.securityBlue
    case LegacyAlarmState.Safety:
      return Appearance.smokeAndCORed
    case LegacyAlarmState.Both:
      return Appearance.smokeAndCORed
    default:
      return UIColor.clear
    }
  }

  static func alarmTitle(_ state: LegacyAlarmState) -> String {
    var title = ""
    if state.contains(.Safety) {
      title = "Safety Alarm Triggered\n"
    }
    if state.contains(.Security) {
      title += "Security Alarm Triggered"
    }
    return title
  }
}

class CancelAlarmPresenter: CancelLegacyAlarmPresenter, SubsystemStateProvider {
  weak var delegate: CancelLegacyAlarmDelegate?

  var alarmState: LegacyAlarmState {
    return computedAlarmState()
  }

  fileprivate func computedAlarmState() -> LegacyAlarmState {
    var state: LegacyAlarmState = .None

    if SubsystemsController.sharedInstance().securityController != nil {
      if SubsystemsController.sharedInstance().securityController.isAlarmTriggered {
        state = state.union(.Security)
      }
    }

    if SubsystemsController.sharedInstance().safetyController != nil {
      if SubsystemsController.sharedInstance().safetyController.isAlarmTriggered {
        state = state.union(.Safety)
      }
    }

    return state
  }

  var alarmColor: UIColor {
    return LegacyAlarmState.alarmColor(alarmState)
  }

  var alarmTitle: String {
    return LegacyAlarmState.alarmTitle(alarmState)
  }

  fileprivate var cancelAttempts: Int = 5

  required init(delegate: CancelLegacyAlarmDelegate?) {
    self.delegate = delegate
  }

  func cancel() {
    DispatchQueue.global(qos: .background).async {
      self.cancelAttempts = 5
      self.processClearing()
    }
  }

  func processClearing() {
    if alarmState == LegacyAlarmState.None {
      attemptActivation()
      delegate?.alarmWasCancelled()
    }

    if cancelAttempts > 0 {
      if alarmState.contains(.Safety) {
        clearSafety()
      }

      if alarmState.contains(.Security) {
        clearSecurity()
      }
      cancelAttempts -= 1
    } else {
      delegate?.alarmCancellationFailed()
    }
  }

  fileprivate func clearSafety() {
    if SubsystemsController.sharedInstance().safetyController.isAlarmTriggered {
      _ = SubsystemsController.sharedInstance().safetyController.clear().swiftThenInBackground({
        _ in
        self.processClearing()
        return nil
      })
    }
  }

  fileprivate func clearSecurity() {
    if SubsystemsController.sharedInstance().securityController.isAlarmTriggered {
      _ = SubsystemsController.sharedInstance().securityController.disArm().swiftThenInBackground({
        _ in
        self.processClearing()
        return nil
      })
    }
  }

  fileprivate func attemptActivation() {
    DispatchQueue.global(qos: .background).async {
      if let alarmSubsytem = SubsystemCache.sharedInstance.alarmSubsystem() {
        _ = self.activateSubsystem(alarmSubsytem)
      }
    }
  }
}
