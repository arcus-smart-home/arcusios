//
//  AlarmStatusViewModelFactory.swift
//  i2app
//
//  Created by Arcus Team on 9/13/17.
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

class AlarmStatusViewModelFactory {

  // MARK: Public Functions

  static func statusSecurityOnPartial(armedTime: String?,
                                      active: Int,
                                      triggered: Int,
                                      offline: Int, securityMode: String) -> AlarmStatusViewModel {

    let ringText = "\(active)/\(active + triggered + offline)"
    let ringSegments = ringSegmentsForCounts(active, inactive: triggered, offline: offline)
    var securityState: AlarmSecurityStatusState!
    var subtext = ""
    var alarmRing: AlarmStatusRingViewModel
    var statusMessages = [String]()

    if offline > 0 {
      statusMessages.append("\(offline) \(AlarmStatusMessage.offline)")
    }
    if triggered > 0 {
      statusMessages.append(createDetectingMessage(AlarmType.Security,
                                                   count: triggered))
    }
    if statusMessages.count > 0 {
      subtext = statusMessages.joined(separator: ", ")
    }
    if securityMode == kEnumAlarmSubsystemSecurityModePARTIAL {
      securityState = .partial

      if subtext.isEmpty {
        if let time = armedTime {
          subtext = "\(AlarmStatusMessage.securityPartialSince) \(time)"
        } else {
          subtext = "\(AlarmStatusMessage.securityPartialSince)"
        }
      } else {
        if let time = armedTime {
          subtext = "\(subtext)\n\(AlarmStatusMessage.securityPartialSince) \(time)"
        } else {
          subtext = "\(subtext)\n\(AlarmStatusMessage.securityPartialSince)"
        }
      }
    } else {
      securityState = .on

      if subtext.isEmpty {
        if let time = armedTime {
          subtext = "\(AlarmStatusMessage.securityOnSince) \(time)"
        } else {
          subtext = "\(AlarmStatusMessage.securityOnSince)"
        }
      } else {
        if let time = armedTime {
          subtext = "\(subtext)\n\(AlarmStatusMessage.securityOnSince) \(time)"
        } else {
          subtext = "\(subtext)\n\(AlarmStatusMessage.securityOnSince)"
        }
      }
    }

    alarmRing = AlarmStatusRingViewModel(state: .segmentedEnabled,
                                         statusText: formatDeviceCountText(ringText),
                                         segments: ringSegments)

    return AlarmStatusViewModel(alarmType: AlarmType.Security,
                                status: subtext,
                                isEmpty: false,
                                isAlarming: false,
                                securityState: securityState,
                                ringViewModel: alarmRing)
  }

  static func statusSecurityPrealerting(countDown: Int) -> AlarmStatusViewModel {
    let deviceCount = 1
    let subtext = AlarmStatusMessage.securityPrealerting
    let securityState = AlarmSecurityStatusState.prealerting
    let alarmRing = createRingTimerViewModel(
      deviceCount, status: formatTimerText(countDown))

    return AlarmStatusViewModel(alarmType: AlarmType.Security,
                                status: subtext,
                                isEmpty: false,
                                isAlarming: false,
                                securityState: securityState,
                                ringViewModel: alarmRing)
  }

  static func statusSecurityArming(deviceCount: Int, countDown: Int) -> AlarmStatusViewModel {
    let subtext = AlarmStatusMessage.securityArming
    let securityState = AlarmSecurityStatusState.arming
    let alarmRing = createRingTimerViewModel(
      deviceCount, status: formatTimerText(countDown))

    return AlarmStatusViewModel(alarmType: AlarmType.Security,
                                status: subtext,
                                isEmpty: false,
                                isAlarming: false,
                                securityState: securityState,
                                ringViewModel: alarmRing)
  }

  static func statusSecurityOff(disarmedTime: String?) -> AlarmStatusViewModel {
    let securityState = AlarmSecurityStatusState.off
    var subtext: String = ""
    if let time = disarmedTime {
      subtext = "\(AlarmStatusMessage.securityOffSince) \(time)"
    } else {
      subtext = "\(AlarmStatusMessage.securityOffSince) "
    }

    let alarmRing = AlarmStatusRingViewModel(state: .solidDisabled,
                                             statusText: formatGrayedOutText(AlarmStatusMessage.off),
                                             segments: nil)

    return AlarmStatusViewModel(alarmType: AlarmType.Security,
                                status: subtext,
                                isEmpty: false,
                                isAlarming: false,
                                securityState: securityState,
                                ringViewModel: alarmRing)
  }

  static func statusViewModelPanic() -> AlarmStatusViewModel {
    let securityState = AlarmSecurityStatusState.off
    var alarmRing: AlarmStatusRingViewModel

    alarmRing = AlarmStatusRingViewModel(state: .solidEnabled,
                                         statusText: formatReadyText(AlarmStatusMessage.ready),
                                         segments: nil)

    return AlarmStatusViewModel(alarmType: AlarmType.Panic,
                                status: "",
                                isEmpty: false,
                                isAlarming: false,
                                securityState: securityState,
                                ringViewModel: alarmRing)
  }

  static func alarmingStatusViewModel(_ type: AlarmType) -> AlarmStatusViewModel {
    return AlarmStatusViewModel(alarmType: type,
                                status: AlarmStatusMessage.alarming,
                                isEmpty: false,
                                isAlarming: true,
                                ringViewModel: alarmingRing())
  }

  static func statusViewModelGeneric(_ alarmType: AlarmType,
                                     activeDevices: Int,
                                     triggeredDevices: Int,
                                     offlineDevices: Int) -> AlarmStatusViewModel {
    var statusMessages = [String]()
    var ringViewModel: AlarmStatusRingViewModel

    let active = activeDevices
    let inactive = triggeredDevices
    let offline = offlineDevices
    let ringState: AlarmRingState = .segmentedEnabled
    let ringText = "\(active)/\(active + inactive + offline)"
    let ringSegmets = ringSegmentsForCounts(active, inactive: inactive, offline: offline)
    var subtext = ""

    if offline > 0 {
      statusMessages.append("\(offline) \(AlarmStatusMessage.offline)")
    }
    if inactive > 0 {
      statusMessages.append(createDetectingMessage(alarmType, count: inactive))
    }
    if statusMessages.count > 0 {
      subtext = statusMessages.joined(separator: "\n")
    }

    ringViewModel = AlarmStatusRingViewModel(state: ringState,
                                             statusText: formatDeviceCountText(ringText),
                                             segments: ringSegmets)

    return AlarmStatusViewModel(alarmType: alarmType,
                                status: subtext,
                                isEmpty: false,
                                isAlarming: false,
                                ringViewModel: ringViewModel)
  }

  static func statusViewModelEmpty(_ alarmType: AlarmType) -> AlarmStatusViewModel {
    var description = ""

    switch alarmType {
    case AlarmType.CO:
      description = AlarmStatusMessage.emptyCO
    case AlarmType.Security:
      description = AlarmStatusMessage.emptySecurity
    case AlarmType.Smoke:
      description = AlarmStatusMessage.emptySmoke
    case AlarmType.Water:
      description = AlarmStatusMessage.emptyWater
    default:
      description = ""
    }

    return AlarmStatusViewModel(alarmType: alarmType, status: description)
  }

  // MARK: Helpers

  private static func createRingTimerViewModel(_ deviceCount: Int,
                                               status: NSAttributedString) -> AlarmStatusRingViewModel {
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

  private static func formatTimerText(_ seconds: Int) -> NSAttributedString {
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

  private static func formatGrayedOutText(_ statusText: String) -> NSAttributedString {
    let attributes: [String: AnyObject] = [
      NSForegroundColorAttributeName: UIColor.lightGray.withAlphaComponent(0.60)
    ]

    return NSAttributedString(string: statusText, attributes: attributes)
  }

  private static func formatReadyText(_ text: String) -> NSAttributedString {
    let attributes: [String: AnyObject] = [
      NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)!
    ]

    let formattedText = NSAttributedString(string: text, attributes:attributes)

    return formattedText
  }

  private static func alarmingRing() -> AlarmStatusRingViewModel {
    return AlarmStatusRingViewModel(state: .solidEnabled,
                                    statusText: NSAttributedString(string: ""),
                                    segments: nil)
  }

  private static func ringSegmentsForCounts(_ active: Int,
                                            inactive: Int,
                                            offline: Int) -> [ArcusAlarmRingSegmentState] {
    var segments = [ArcusAlarmRingSegmentState]()

    // Segments should be added in order: Offline -> Inactive -> Active
    if offline > 0 {
      for _ in 1...offline {
        segments.append(.offline)
      }
    }
    if inactive > 0 {
      for _ in 1...inactive {
        segments.append(.inactive)
      }
    }
    if active > 0 {
      for _ in 1...active {
        segments.append(.active)
      }
    }

    return segments
  }

  private static func createDetectingMessage(_ alarmType: AlarmType, count: Int) -> String {
    switch alarmType {
    case AlarmType.CO:
      return "\(count) \(AlarmStatusMessage.detectingCO)"
    case AlarmType.Security:
      return "\(count) \(AlarmStatusMessage.detectingSecurity)"
    case AlarmType.Smoke:
      return "\(count) \(AlarmStatusMessage.detectingSmoke)"
    case AlarmType.Water:
      return "\(count) \(AlarmStatusMessage.detectingWater)"
    default:
      return ""
    }
  }

  private static func formatDeviceCountText(_ statusText: String) -> NSAttributedString {
    let stringComponents = statusText.components(separatedBy: "/")

    if stringComponents.count == 2 {
      let attributes: [String: AnyObject] = [
        NSFontAttributeName: UIFont(name: "Avenir Next", size: 14)!,
        NSForegroundColorAttributeName: UIColor(
          red: 255, green: 255, blue: 255, alpha: 0.7),
        NSBaselineOffsetAttributeName: 7.0 as AnyObject
      ]

      let mainText = NSMutableAttributedString(string: stringComponents[0])
      let formattedText = NSAttributedString(string: "/\(stringComponents[1])",
        attributes:attributes)

      mainText.append(formattedText)
      return mainText
    }

    return NSAttributedString(string: statusText)
  }
}
