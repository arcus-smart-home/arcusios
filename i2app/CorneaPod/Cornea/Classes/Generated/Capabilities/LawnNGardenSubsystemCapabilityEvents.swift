
//
// LawnNGardenSubsystemCapEvents.swift
//
// Generated on 20/09/18
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

import Foundation

// MARK: Commands
fileprivate struct Commands {
  /** Stops a controller from watering whether it was started manually or not. */
  static let lawnNGardenSubsystemStopWatering: String = "sublawnngarden:StopWatering"
  /** Changes the scheduling mode on a controller between the various types */
  static let lawnNGardenSubsystemSwitchScheduleMode: String = "sublawnngarden:SwitchScheduleMode"
  /** Enables the current schedule */
  static let lawnNGardenSubsystemEnableScheduling: String = "sublawnngarden:EnableScheduling"
  /** Disables the current schedule */
  static let lawnNGardenSubsystemDisableScheduling: String = "sublawnngarden:DisableScheduling"
  /** Skips scheduled watering events for a specific length of time */
  static let lawnNGardenSubsystemSkip: String = "sublawnngarden:Skip"
  /** Cancels skipping (rain delay) */
  static let lawnNGardenSubsystemCancelSkip: String = "sublawnngarden:CancelSkip"
  /** Configures the start time and interval for the interval schedule */
  static let lawnNGardenSubsystemConfigureIntervalSchedule: String = "sublawnngarden:ConfigureIntervalSchedule"
  /** Creates a weekly schedule event */
  static let lawnNGardenSubsystemCreateWeeklyEvent: String = "sublawnngarden:CreateWeeklyEvent"
  /** Updates a weekly schedule event */
  static let lawnNGardenSubsystemUpdateWeeklyEvent: String = "sublawnngarden:UpdateWeeklyEvent"
  /** Removes a weekly schedule event */
  static let lawnNGardenSubsystemRemoveWeeklyEvent: String = "sublawnngarden:RemoveWeeklyEvent"
  /** Creates a non-weekly scheduling event */
  static let lawnNGardenSubsystemCreateScheduleEvent: String = "sublawnngarden:CreateScheduleEvent"
  /** Updates an existing non-weekly schedule event */
  static let lawnNGardenSubsystemUpdateScheduleEvent: String = "sublawnngarden:UpdateScheduleEvent"
  /** Removes an existing non-weekly schedule event */
  static let lawnNGardenSubsystemRemoveScheduleEvent: String = "sublawnngarden:RemoveScheduleEvent"
  /** Attempts to repush an entire scheduled identified by the mode down to the device, typically useful when applying some event has failed */
  static let lawnNGardenSubsystemSyncSchedule: String = "sublawnngarden:SyncSchedule"
  /** Attempts to repush an entire scheduled event down to the device, typically useful when applying some event has failed */
  static let lawnNGardenSubsystemSyncScheduleEvent: String = "sublawnngarden:SyncScheduleEvent"
  
}
// MARK: Events
public struct LawnNGardenSubsystemEvents {
  /** Fired when a zone starts watering. */
  public static let lawnNGardenSubsystemStartWatering: String = "sublawnngarden:StartWatering"
  /** Fired when a zone stops watering. */
  public static let lawnNGardenSubsystemStopWatering: String = "sublawnngarden:StopWatering"
  /** Fired a controller is set to skip watering. */
  public static let lawnNGardenSubsystemSkipWatering: String = "sublawnngarden:SkipWatering"
  /** Fired when the subsystem schedule is updated. */
  public static let lawnNGardenSubsystemUpdateSchedule: String = "sublawnngarden:UpdateSchedule"
  /** Fired when a schedule is applied to a controller. */
  public static let lawnNGardenSubsystemApplyScheduleToDevice: String = "sublawnngarden:ApplyScheduleToDevice"
  /** Fired when a schedule fails to be applied to a controller. */
  public static let lawnNGardenSubsystemApplyScheduleToDeviceFailed: String = "sublawnngarden:ApplyScheduleToDeviceFailed"
  }

// MARK: Enumerations

// MARK: Requests

/** Stops a controller from watering whether it was started manually or not. */
public class LawnNGardenSubsystemStopWateringRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemStopWateringRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemStopWatering
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemStopWateringResponse(message)
  }

  // MARK: StopWateringRequest Attributes
  struct Attributes {
    /** The address of the controller to stop */
    static let controller: String = "controller"
/** Ignored if watering was triggered manually.  If watering was triggered on a schedule this controls whether just this zone is stopped or all zones in the scheduled event.  If not provided, it will be assumed to be true */
    static let currentOnly: String = "currentOnly"
 }
  
  /** The address of the controller to stop */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** Ignored if watering was triggered manually.  If watering was triggered on a schedule this controls whether just this zone is stopped or all zones in the scheduled event.  If not provided, it will be assumed to be true */
  public func setCurrentOnly(_ currentOnly: Bool) {
    attributes[Attributes.currentOnly] = currentOnly as AnyObject
  }

  
}

public class LawnNGardenSubsystemStopWateringResponse: SessionEvent {
  
}

/** Changes the scheduling mode on a controller between the various types */
public class LawnNGardenSubsystemSwitchScheduleModeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemSwitchScheduleModeRequest Enumerations
  /** The new mode to enable on the device */
  public enum LawnNGardenSubsystemMode: String {
   case weekly = "WEEKLY"
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemSwitchScheduleMode
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemSwitchScheduleModeResponse(message)
  }

  // MARK: SwitchScheduleModeRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The new mode to enable on the device */
    static let mode: String = "mode"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The new mode to enable on the device */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
}

public class LawnNGardenSubsystemSwitchScheduleModeResponse: SessionEvent {
  
}

/** Enables the current schedule */
public class LawnNGardenSubsystemEnableSchedulingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemEnableSchedulingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemEnableScheduling
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemEnableSchedulingResponse(message)
  }

  // MARK: EnableSchedulingRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
}

public class LawnNGardenSubsystemEnableSchedulingResponse: SessionEvent {
  
}

/** Disables the current schedule */
public class LawnNGardenSubsystemDisableSchedulingRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemDisableSchedulingRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemDisableScheduling
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemDisableSchedulingResponse(message)
  }

  // MARK: DisableSchedulingRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
}

public class LawnNGardenSubsystemDisableSchedulingResponse: SessionEvent {
  
}

/** Skips scheduled watering events for a specific length of time */
public class LawnNGardenSubsystemSkipRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemSkipRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemSkip
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemSkipResponse(message)
  }

  // MARK: SkipRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The number of hours to skip */
    static let hours: String = "hours"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The number of hours to skip */
  public func setHours(_ hours: Int) {
    attributes[Attributes.hours] = hours as AnyObject
  }

  
}

public class LawnNGardenSubsystemSkipResponse: SessionEvent {
  
}

/** Cancels skipping (rain delay) */
public class LawnNGardenSubsystemCancelSkipRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemCancelSkipRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemCancelSkip
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemCancelSkipResponse(message)
  }

  // MARK: CancelSkipRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
}

public class LawnNGardenSubsystemCancelSkipResponse: SessionEvent {
  
}

/** Configures the start time and interval for the interval schedule */
public class LawnNGardenSubsystemConfigureIntervalScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemConfigureIntervalScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemConfigureIntervalSchedule
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemConfigureIntervalScheduleResponse(message)
  }

  // MARK: ConfigureIntervalScheduleRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The time on which the interval starts.  Technically it will start on midnight of the date given */
    static let startTime: String = "startTime"
/** The number of interval days */
    static let days: String = "days"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The time on which the interval starts.  Technically it will start on midnight of the date given */
  public func setStartTime(_ startTime: Date) {
    let startTime: Double = startTime.millisecondsSince1970
    attributes[Attributes.startTime] = startTime as AnyObject
  }

  
  /** The number of interval days */
  public func setDays(_ days: Int) {
    attributes[Attributes.days] = days as AnyObject
  }

  
}

public class LawnNGardenSubsystemConfigureIntervalScheduleResponse: SessionEvent {
  
}

/** Creates a weekly schedule event */
public class LawnNGardenSubsystemCreateWeeklyEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemCreateWeeklyEventRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemCreateWeeklyEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemCreateWeeklyEventResponse(message)
  }

  // MARK: CreateWeeklyEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The days the event will fire.  Must be MON, TUE, WED, THU, FRI, SAT, SUN */
    static let days: String = "days"
/** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
    static let timeOfDay: String = "timeOfDay"
/** The length of time to water for each zone */
    static let zoneDurations: String = "zoneDurations"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The days the event will fire.  Must be MON, TUE, WED, THU, FRI, SAT, SUN */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
  public func setTimeOfDay(_ timeOfDay: String) {
    attributes[Attributes.timeOfDay] = timeOfDay as AnyObject
  }

  
  /** The length of time to water for each zone */
  public func setZoneDurations(_ zoneDurations: [Any]) {
    attributes[Attributes.zoneDurations] = zoneDurations as AnyObject
  }

  
}

public class LawnNGardenSubsystemCreateWeeklyEventResponse: SessionEvent {
  
}

/** Updates a weekly schedule event */
public class LawnNGardenSubsystemUpdateWeeklyEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemUpdateWeeklyEventRequest Enumerations
  /** The day to update.  If not provided all days will be updated */
  public enum LawnNGardenSubsystemDay: String {
   case mon = "MON"
   case tue = "TUE"
   case wed = "WED"
   case thu = "THU"
   case fri = "FRI"
   case sat = "SAT"
   case sun = "SUN"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemUpdateWeeklyEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemUpdateWeeklyEventResponse(message)
  }

  // MARK: UpdateWeeklyEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The identifier for the event to remove */
    static let eventId: String = "eventId"
/** The days the event will fire.  Must be MON, TUE, WED, THU, FRI, SAT, SUN */
    static let days: String = "days"
/** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
    static let timeOfDay: String = "timeOfDay"
/** The length of time to water for each zone */
    static let zoneDurations: String = "zoneDurations"
/** The day to update.  If not provided all days will be updated */
    static let day: String = "day"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The identifier for the event to remove */
  public func setEventId(_ eventId: String) {
    attributes[Attributes.eventId] = eventId as AnyObject
  }

  
  /** The days the event will fire.  Must be MON, TUE, WED, THU, FRI, SAT, SUN */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
  public func setTimeOfDay(_ timeOfDay: String) {
    attributes[Attributes.timeOfDay] = timeOfDay as AnyObject
  }

  
  /** The length of time to water for each zone */
  public func setZoneDurations(_ zoneDurations: [Any]) {
    attributes[Attributes.zoneDurations] = zoneDurations as AnyObject
  }

  
  /** The day to update.  If not provided all days will be updated */
  public func setDay(_ day: String) {
    if let value: LawnNGardenSubsystemDay = LawnNGardenSubsystemDay(rawValue: day) {
      attributes[Attributes.day] = value.rawValue as AnyObject
    }
  }
  
}

public class LawnNGardenSubsystemUpdateWeeklyEventResponse: SessionEvent {
  
}

/** Removes a weekly schedule event */
public class LawnNGardenSubsystemRemoveWeeklyEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemRemoveWeeklyEventRequest Enumerations
  /** The specific day to remove.  If not provided all days (i.e. the entire event) will be removed */
  public enum LawnNGardenSubsystemDay: String {
   case mon = "MON"
   case tue = "TUE"
   case wed = "WED"
   case thu = "THU"
   case fri = "FRI"
   case sat = "SAT"
   case sun = "SUN"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemRemoveWeeklyEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemRemoveWeeklyEventResponse(message)
  }

  // MARK: RemoveWeeklyEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The identifier for the event to remove */
    static let eventId: String = "eventId"
/** The specific day to remove.  If not provided all days (i.e. the entire event) will be removed */
    static let day: String = "day"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The identifier for the event to remove */
  public func setEventId(_ eventId: String) {
    attributes[Attributes.eventId] = eventId as AnyObject
  }

  
  /** The specific day to remove.  If not provided all days (i.e. the entire event) will be removed */
  public func setDay(_ day: String) {
    if let value: LawnNGardenSubsystemDay = LawnNGardenSubsystemDay(rawValue: day) {
      attributes[Attributes.day] = value.rawValue as AnyObject
    }
  }
  
}

public class LawnNGardenSubsystemRemoveWeeklyEventResponse: SessionEvent {
  
}

/** Creates a non-weekly scheduling event */
public class LawnNGardenSubsystemCreateScheduleEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemCreateScheduleEventRequest Enumerations
  /** The mode of the schedule to add the event to */
  public enum LawnNGardenSubsystemMode: String {
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemCreateScheduleEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemCreateScheduleEventResponse(message)
  }

  // MARK: CreateScheduleEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The mode of the schedule to add the event to */
    static let mode: String = "mode"
/** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
    static let timeOfDay: String = "timeOfDay"
/** The length of time to water for each zone */
    static let zoneDurations: String = "zoneDurations"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The mode of the schedule to add the event to */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
  public func setTimeOfDay(_ timeOfDay: String) {
    attributes[Attributes.timeOfDay] = timeOfDay as AnyObject
  }

  
  /** The length of time to water for each zone */
  public func setZoneDurations(_ zoneDurations: [Any]) {
    attributes[Attributes.zoneDurations] = zoneDurations as AnyObject
  }

  
}

public class LawnNGardenSubsystemCreateScheduleEventResponse: SessionEvent {
  
}

/** Updates an existing non-weekly schedule event */
public class LawnNGardenSubsystemUpdateScheduleEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemUpdateScheduleEventRequest Enumerations
  /** The mode of the schedule */
  public enum LawnNGardenSubsystemMode: String {
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemUpdateScheduleEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemUpdateScheduleEventResponse(message)
  }

  // MARK: UpdateScheduleEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The mode of the schedule */
    static let mode: String = "mode"
/** The identifier for the event to remove */
    static let eventId: String = "eventId"
/** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
    static let timeOfDay: String = "timeOfDay"
/** The length of time to water for each zone */
    static let zoneDurations: String = "zoneDurations"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The mode of the schedule */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The identifier for the event to remove */
  public func setEventId(_ eventId: String) {
    attributes[Attributes.eventId] = eventId as AnyObject
  }

  
  /** The time of day the event starts.  Must be of the form HH:mm in the 24 our clock */
  public func setTimeOfDay(_ timeOfDay: String) {
    attributes[Attributes.timeOfDay] = timeOfDay as AnyObject
  }

  
  /** The length of time to water for each zone */
  public func setZoneDurations(_ zoneDurations: [Any]) {
    attributes[Attributes.zoneDurations] = zoneDurations as AnyObject
  }

  
}

public class LawnNGardenSubsystemUpdateScheduleEventResponse: SessionEvent {
  
}

/** Removes an existing non-weekly schedule event */
public class LawnNGardenSubsystemRemoveScheduleEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemRemoveScheduleEventRequest Enumerations
  /** The mode of the schedule */
  public enum LawnNGardenSubsystemMode: String {
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemRemoveScheduleEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemRemoveScheduleEventResponse(message)
  }

  // MARK: RemoveScheduleEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The mode of the schedule */
    static let mode: String = "mode"
/** The identifier for the event to remove */
    static let eventId: String = "eventId"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The mode of the schedule */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The identifier for the event to remove */
  public func setEventId(_ eventId: String) {
    attributes[Attributes.eventId] = eventId as AnyObject
  }

  
}

public class LawnNGardenSubsystemRemoveScheduleEventResponse: SessionEvent {
  
}

/** Attempts to repush an entire scheduled identified by the mode down to the device, typically useful when applying some event has failed */
public class LawnNGardenSubsystemSyncScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemSyncScheduleRequest Enumerations
  /** The mode of the schedule */
  public enum LawnNGardenSubsystemMode: String {
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   case weekly = "WEEKLY"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemSyncSchedule
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemSyncScheduleResponse(message)
  }

  // MARK: SyncScheduleRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The mode of the schedule */
    static let mode: String = "mode"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The mode of the schedule */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
}

public class LawnNGardenSubsystemSyncScheduleResponse: SessionEvent {
  
}

/** Attempts to repush an entire scheduled event down to the device, typically useful when applying some event has failed */
public class LawnNGardenSubsystemSyncScheduleEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: LawnNGardenSubsystemSyncScheduleEventRequest Enumerations
  /** The mode of the schedule */
  public enum LawnNGardenSubsystemMode: String {
   case odd = "ODD"
   case even = "EVEN"
   case interval = "INTERVAL"
   case weekly = "WEEKLY"
   
  }
  override init() {
    super.init()
    self.command = Commands.lawnNGardenSubsystemSyncScheduleEvent
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return LawnNGardenSubsystemSyncScheduleEventResponse(message)
  }

  // MARK: SyncScheduleEventRequest Attributes
  struct Attributes {
    /** The address of the controller */
    static let controller: String = "controller"
/** The mode of the schedule */
    static let mode: String = "mode"
/** The identifier for the event to remove */
    static let eventId: String = "eventId"
 }
  
  /** The address of the controller */
  public func setController(_ controller: String) {
    attributes[Attributes.controller] = controller as AnyObject
  }

  
  /** The mode of the schedule */
  public func setMode(_ mode: String) {
    if let value: LawnNGardenSubsystemMode = LawnNGardenSubsystemMode(rawValue: mode) {
      attributes[Attributes.mode] = value.rawValue as AnyObject
    }
  }
  
  /** The identifier for the event to remove */
  public func setEventId(_ eventId: String) {
    attributes[Attributes.eventId] = eventId as AnyObject
  }

  
}

public class LawnNGardenSubsystemSyncScheduleEventResponse: SessionEvent {
  
}

