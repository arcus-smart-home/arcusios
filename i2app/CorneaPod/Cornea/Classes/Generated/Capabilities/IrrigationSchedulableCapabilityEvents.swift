
//
// IrrigationSchedulableCapEvents.swift
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
  /** Enables scheduling on the device */
  static let irrigationSchedulableEnableSchedule: String = "irrsched:EnableSchedule"
  /** Disables schedulig on the device for an optional amount of time */
  static let irrigationSchedulableDisableSchedule: String = "irrsched:DisableSchedule"
  /** Clears the even/odd day schedule for the given zone */
  static let irrigationSchedulableClearEvenOddSchedule: String = "irrsched:ClearEvenOddSchedule"
  /** Sets an even/odd day schedule for the given zone */
  static let irrigationSchedulableSetEvenOddSchedule: String = "irrsched:SetEvenOddSchedule"
  /** Clears the interval schedule for the given zone */
  static let irrigationSchedulableClearIntervalSchedule: String = "irrsched:ClearIntervalSchedule"
  /** Sets an interval schedule for the given zone */
  static let irrigationSchedulableSetIntervalSchedule: String = "irrsched:SetIntervalSchedule"
  /** Sets the interval start date */
  static let irrigationSchedulableSetIntervalStart: String = "irrsched:SetIntervalStart"
  /** Clears the weekly schedule for the given zone */
  static let irrigationSchedulableClearWeeklySchedule: String = "irrsched:ClearWeeklySchedule"
  /** Sets a weekly schedule for the given zone */
  static let irrigationSchedulableSetWeeklySchedule: String = "irrsched:SetWeeklySchedule"
  
}
// MARK: Events
public struct IrrigationSchedulableEvents {
  /** Emitted as a result of EnableSchedule */
  public static let irrigationSchedulableScheduleEnabled: String = "irrsched:ScheduleEnabled"
  /** Emitted when a schedule is successfully written to the device */
  public static let irrigationSchedulableScheduleApplied: String = "irrsched:ScheduleApplied"
  /** Emitted when a schedule is successfully cleared from the device */
  public static let irrigationSchedulableScheduleCleared: String = "irrsched:ScheduleCleared"
  /** Emitted when a schedule could not be applied on the device */
  public static let irrigationSchedulableScheduleFailed: String = "irrsched:ScheduleFailed"
  /** Emitted when a schedule failed to be cleared from the device */
  public static let irrigationSchedulableScheduleClearFailed: String = "irrsched:ScheduleClearFailed"
  /** Emitted when setting the interval start date succeeds */
  public static let irrigationSchedulableSetIntervalStartSucceeded: String = "irrsched:SetIntervalStartSucceeded"
  /** Emitted when there is a failure to set the interval start date */
  public static let irrigationSchedulableSetIntervalStartFailed: String = "irrsched:SetIntervalStartFailed"
  }

// MARK: Enumerations

// MARK: Requests

/** Enables scheduling on the device */
public class IrrigationSchedulableEnableScheduleRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableEnableSchedule
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
    return IrrigationSchedulableEnableScheduleResponse(message)
  }

  
}

public class IrrigationSchedulableEnableScheduleResponse: SessionEvent {
  
}

/** Disables schedulig on the device for an optional amount of time */
public class IrrigationSchedulableDisableScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableDisableScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableDisableSchedule
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
    return IrrigationSchedulableDisableScheduleResponse(message)
  }

  // MARK: DisableScheduleRequest Attributes
  struct Attributes {
    /** The duration in minutes to disable the schedule.  -1 implies indefinitely */
    static let duration: String = "duration"
 }
  
  /** The duration in minutes to disable the schedule.  -1 implies indefinitely */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
}

public class IrrigationSchedulableDisableScheduleResponse: SessionEvent {
  
}

/** Clears the even/odd day schedule for the given zone */
public class IrrigationSchedulableClearEvenOddScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableClearEvenOddScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableClearEvenOddSchedule
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
    return IrrigationSchedulableClearEvenOddScheduleResponse(message)
  }

  // MARK: ClearEvenOddScheduleRequest Attributes
  struct Attributes {
    /** The zone to clear */
    static let zone: String = "zone"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to clear */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableClearEvenOddScheduleResponse: SessionEvent {
  
}

/** Sets an even/odd day schedule for the given zone */
public class IrrigationSchedulableSetEvenOddScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableSetEvenOddScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableSetEvenOddSchedule
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
    return IrrigationSchedulableSetEvenOddScheduleResponse(message)
  }

  // MARK: SetEvenOddScheduleRequest Attributes
  struct Attributes {
    /** The zone to set the schedule on */
    static let zone: String = "zone"
/** true for an even day schedule, false for an odd day */
    static let even: String = "even"
/** Each transition to set containing startTime and duration */
    static let transitions: String = "transitions"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to set the schedule on */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** true for an even day schedule, false for an odd day */
  public func setEven(_ even: Bool) {
    attributes[Attributes.even] = even as AnyObject
  }

  
  /** Each transition to set containing startTime and duration */
  public func setTransitions(_ transitions: [Any]) {
    attributes[Attributes.transitions] = transitions as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableSetEvenOddScheduleResponse: SessionEvent {
  
}

/** Clears the interval schedule for the given zone */
public class IrrigationSchedulableClearIntervalScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableClearIntervalScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableClearIntervalSchedule
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
    return IrrigationSchedulableClearIntervalScheduleResponse(message)
  }

  // MARK: ClearIntervalScheduleRequest Attributes
  struct Attributes {
    /** The zone to clear */
    static let zone: String = "zone"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to clear */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableClearIntervalScheduleResponse: SessionEvent {
  
}

/** Sets an interval schedule for the given zone */
public class IrrigationSchedulableSetIntervalScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableSetIntervalScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableSetIntervalSchedule
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
    return IrrigationSchedulableSetIntervalScheduleResponse(message)
  }

  // MARK: SetIntervalScheduleRequest Attributes
  struct Attributes {
    /** The zone to set the schedule on */
    static let zone: String = "zone"
/** The number of days in the interval */
    static let days: String = "days"
/** Each transition to set containing startTime and duration */
    static let transitions: String = "transitions"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to set the schedule on */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The number of days in the interval */
  public func setDays(_ days: Int) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** Each transition to set containing startTime and duration */
  public func setTransitions(_ transitions: [Any]) {
    attributes[Attributes.transitions] = transitions as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableSetIntervalScheduleResponse: SessionEvent {
  
}

/** Sets the interval start date */
public class IrrigationSchedulableSetIntervalStartRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableSetIntervalStartRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableSetIntervalStart
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
    return IrrigationSchedulableSetIntervalStartResponse(message)
  }

  // MARK: SetIntervalStartRequest Attributes
  struct Attributes {
    /** The zone to set the interval start on */
    static let zone: String = "zone"
/** The timestamp of the day on which the interval schedule should start */
    static let startDate: String = "startDate"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to set the interval start on */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The timestamp of the day on which the interval schedule should start */
  public func setStartDate(_ startDate: Date) {
    let startDate: Double = startDate.millisecondsSince1970
    attributes[Attributes.startDate] = startDate as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableSetIntervalStartResponse: SessionEvent {
  
}

/** Clears the weekly schedule for the given zone */
public class IrrigationSchedulableClearWeeklyScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableClearWeeklyScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableClearWeeklySchedule
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
    return IrrigationSchedulableClearWeeklyScheduleResponse(message)
  }

  // MARK: ClearWeeklyScheduleRequest Attributes
  struct Attributes {
    /** The zone to clear */
    static let zone: String = "zone"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to clear */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableClearWeeklyScheduleResponse: SessionEvent {
  
}

/** Sets a weekly schedule for the given zone */
public class IrrigationSchedulableSetWeeklyScheduleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationSchedulableSetWeeklyScheduleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationSchedulableSetWeeklySchedule
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
    return IrrigationSchedulableSetWeeklyScheduleResponse(message)
  }

  // MARK: SetWeeklyScheduleRequest Attributes
  struct Attributes {
    /** The zone to set the schedule on */
    static let zone: String = "zone"
/** The days to set, each entry will be one of MON,TUE,WED,THU,FRI,SAT or SUN */
    static let days: String = "days"
/** Each transition to set containing startTime and duration */
    static let transitions: String = "transitions"
/** The operation ID, this should be returned in success or failure events for alignment */
    static let opId: String = "opId"
 }
  
  /** The zone to set the schedule on */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** The days to set, each entry will be one of MON,TUE,WED,THU,FRI,SAT or SUN */
  public func setDays(_ days: [String]) {
    attributes[Attributes.days] = days as AnyObject
  }

  
  /** Each transition to set containing startTime and duration */
  public func setTransitions(_ transitions: [Any]) {
    attributes[Attributes.transitions] = transitions as AnyObject
  }

  
  /** The operation ID, this should be returned in success or failure events for alignment */
  public func setOpId(_ opId: String) {
    attributes[Attributes.opId] = opId as AnyObject
  }

  
}

public class IrrigationSchedulableSetWeeklyScheduleResponse: SessionEvent {
  
}

