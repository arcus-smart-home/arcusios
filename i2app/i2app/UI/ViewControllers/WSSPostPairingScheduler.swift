//
//  WSSPostPairingScheduler.swift
//  i2app
//
//  Created by Arcus Team on 8/11/16.
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

enum PostPairingSchedulerStepType: Int {
  case startTime = 0
  case endTime = 1
  case days = 2
}

struct PostPairingSchedulerStep {
  static let titleArray: [String] = ["Start Time", "Stop Time", "Days"]

  static func titleForStepType(_ type: PostPairingSchedulerStepType) -> String {
    return PostPairingSchedulerStep.titleArray[type.rawValue]
  }

  var type: PostPairingSchedulerStepType
  var title: String

  init(stepType: PostPairingSchedulerStepType) {
    type = stepType
    title = PostPairingSchedulerStep.titleForStepType(stepType)
  }
}

class WSSPostPairingScheduler {
  var deviceModel: DeviceModel
  var startEvent: ScheduledEventModel? {
    didSet {
      startEvent?.messageType = kCmdSetAttributes
      startEvent?.attributes = ["swit:state": "ON"]
    }
  }
  var stopEvent: ScheduledEventModel? {
    didSet {
      stopEvent?.messageType = kCmdSetAttributes
      stopEvent?.attributes = ["swit:state": "OFF"]
    }
  }

  var days: [String]?

  let scheduleType: String = "LIGHT"

  required init(_ deviceModel: DeviceModel) {
    self.deviceModel = deviceModel
  }

  func processSchedulerStep(_ step: PostPairingSchedulerStep,
                            value: AnyObject,
                            completionHandler: ((_ success: Bool, _ error: NSError?) -> Void)) {
    var success: Bool = false
    var error: NSError? = nil

    switch step.type {
    case .startTime:
      if let dateTime = value as? ArcusDateTime {
        startEvent = ScheduledEventModel.create()
        startEvent?.eventTime = dateTime
        success = true
      } else {
        error = NSError(domain: "ArcusDomain",
                        code: 1000,
                        userInfo: [NSLocalizedDescriptionKey: "Value must be ArcusDateTime for StartEvent"])
      }
    case .endTime:
      if let dateTime = value as? ArcusDateTime {
        success = true
        stopEvent = ScheduledEventModel.create()
        stopEvent?.eventTime = dateTime
      } else {
        error = NSError(domain: "ArcusDomain",
                        code: 1000,
                        userInfo: [NSLocalizedDescriptionKey: "Value must be ArcusDateTime for StopEvent"])
      }
    case .days:
      if let daysArray = value as? [String] {
        if daysArray.count > 0 {
          success = true
          days = formattedDaysArray(daysArray)
        } else {
          error = NSError(domain: "ArcusDomain",
                          code: 1000,
                          userInfo:
            [NSLocalizedDescriptionKey: "At least one day must be selected to create a schedule."])
        }
      } else {
        error = NSError(domain: "ArcusDomain",
                        code: 1000,
                        userInfo: [NSLocalizedDescriptionKey: "Value must be [String] for Days"])
      }
    }

    completionHandler(success, error)
  }

  func scheduleEvents(_ completionHandler: @escaping (_ success: Bool) -> Void) {
    if startEvent != nil
      && stopEvent != nil {
      createSchedule(deviceModel,
                     eventModel: startEvent!,
                     type: scheduleType,
                     days: days!,
                     completion: {
                      success in
                      if success == true {
                        self.createSchedule(self.deviceModel,
                                            eventModel: self.stopEvent!,
                                            type: self.scheduleType,
                                            days: self.days!,
                                            completion: {
                                              success in
                                              completionHandler(success)
                        })
                      } else {
                        completionHandler(success)
                      }
      })
    }
  }

  func createSchedule(_ deviceModel: DeviceModel,
                      eventModel: ScheduledEventModel,
                      type: String,
                      days: [String],
                      completion: @escaping (_ success: Bool) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let mode: String = self.modeForEvent(eventModel)
      let time: String = self.formattedTime(eventModel)

      _ = SchedulerService
        .scheduleWeeklyCommand(withTarget: deviceModel.address as String!,
                               withSchedule: type,
                               withDays: days,
                               withMode: mode,
                               withTime: time,
                               withOffsetMinutes: eventModel.eventTime.offsetMinutes,
                               withMessageType: eventModel.messageType,
                               withAttributes: eventModel.attributes as [NSObject : AnyObject])
        .swiftThen {
          _ in
          completion(true)
          return nil
        }
        .swiftCatch {
          _ in
          completion(false)
          return nil
      }
    }
  }

  func modeForEvent(_ event: ScheduledEventModel) -> String {
    var mode: String = kScheduleTimeModeAbsolute
    if event.eventTime.currentTimeType == .sunrise {
      mode = kScheduleTimeModeSunrise
    } else if event.eventTime.currentTimeType == .sunset {
      mode = kScheduleTimeModeSunset
    }
    return mode
  }

  func formattedDaysArray(_ daysArray: [String]) -> [String] {
    var result: [String] = []

    for day: String in daysArray {
      let formattedDay: String = (day as NSString).substring(to: 3)
      result.append(formattedDay.uppercased())
    }

    return result
  }

  func formattedTime(_ event: ScheduledEventModel) -> String {
    var formattedTime = ""
    if event.eventTime.currentTimeType == .absolute {
      formattedTime = event.eventTimeFormatted
    }
    return formattedTime
  }
}
