
//
// CareSubsystemCapEvents.swift
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
  /**  */
  static let careSubsystemPanic: String = "subcare:Panic"
  /**  */
  static let careSubsystemAcknowledge: String = "subcare:Acknowledge"
  /**  */
  static let careSubsystemClear: String = "subcare:Clear"
  /** Creates a list of time buckets and indicates which care devices, optionally filtered, are triggered during that bucket. */
  static let careSubsystemListActivity: String = "subcare:ListActivity"
  /** Returns a list of all the history log entries associated with this subsystem. */
  static let careSubsystemListDetailedActivity: String = "subcare:ListDetailedActivity"
  /**  */
  static let careSubsystemListBehaviors: String = "subcare:ListBehaviors"
  /**  */
  static let careSubsystemListBehaviorTemplates: String = "subcare:ListBehaviorTemplates"
  /**  */
  static let careSubsystemAddBehavior: String = "subcare:AddBehavior"
  /** Updates the requested attributes on the specified behavior. */
  static let careSubsystemUpdateBehavior: String = "subcare:UpdateBehavior"
  /** Updates the requested attributes on the specified behavior. */
  static let careSubsystemRemoveBehavior: String = "subcare:RemoveBehavior"
  
}
// MARK: Events
public struct CareSubsystemEvents {
  /** Alerts the system that a behaviors has triggered an alert. */
  public static let careSubsystemBehaviorAlert: String = "subcare:BehaviorAlert"
  /** The care alert has been cleared. */
  public static let careSubsystemBehaviorAlertCleared: String = "subcare:BehaviorAlertCleared"
  /** The care alert has been ackknowledged. */
  public static let careSubsystemBehaviorAlertAcknowledged: String = "subcare:BehaviorAlertAcknowledged"
  /** Alerts the system that a behaviors has triggered an alert. */
  public static let careSubsystemBehaviorAction: String = "subcare:BehaviorAction"
  }

// MARK: Enumerations

/** Whether the care alarm is currently turned on or in visit mode.  During visit mode behaviors will not trigger the care alarm, but the care pendant may still generate a panic. */
public enum CareSubsystemAlarmMode: String {
  case on = "ON"
  case visit = "VISIT"
}

/** Whether the alarm is currently going of or not. */
public enum CareSubsystemAlarmState: String {
  case ready = "READY"
  case alert = "ALERT"
}

/** The current state of acknowledgement:     PENDING - Arcus is attempting to notify the user that an alarm has been triggered     ACKNOWLEDGED - One of the persons from the call tree has acknowledged the alarm     FAILED - No one acknowledged the alarm but no one was available to acknowledged it. */
public enum CareSubsystemLastAcknowledgement: String {
  case pending = "PENDING"
  case acknowledged = "ACKNOWLEDGED"
  case failed = "FAILED"
}

// MARK: Requests

/**  */
public class CareSubsystemPanicRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemPanic
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
    return CareSubsystemPanicResponse(message)
  }

  
}

public class CareSubsystemPanicResponse: SessionEvent {
  
}

/**  */
public class CareSubsystemAcknowledgeRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemAcknowledge
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
    return CareSubsystemAcknowledgeResponse(message)
  }

  
}

public class CareSubsystemAcknowledgeResponse: SessionEvent {
  
}

/**  */
public class CareSubsystemClearRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemClear
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
    return CareSubsystemClearResponse(message)
  }

  
}

public class CareSubsystemClearResponse: SessionEvent {
  
}

/** Creates a list of time buckets and indicates which care devices, optionally filtered, are triggered during that bucket. */
public class CareSubsystemListActivityRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CareSubsystemListActivityRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemListActivity
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
    return CareSubsystemListActivityResponse(message)
  }

  // MARK: ListActivityRequest Attributes
  struct Attributes {
    /** The start time of the interval */
    static let start: String = "start"
/** The end time of the interval */
    static let end: String = "end"
/** The number of seconds in each bucket */
    static let bucket: String = "bucket"
/** The devices to show activity for */
    static let devices: String = "devices"
 }
  
  /** The start time of the interval */
  public func setStart(_ start: Date) {
    let start: Double = start.millisecondsSince1970
    attributes[Attributes.start] = start as AnyObject
  }

  
  /** The end time of the interval */
  public func setEnd(_ end: Date) {
    let end: Double = end.millisecondsSince1970
    attributes[Attributes.end] = end as AnyObject
  }

  
  /** The number of seconds in each bucket */
  public func setBucket(_ bucket: Int) {
    attributes[Attributes.bucket] = bucket as AnyObject
  }

  
  /** The devices to show activity for */
  public func setDevices(_ devices: [String]) {
    attributes[Attributes.devices] = devices as AnyObject
  }

  
}

public class CareSubsystemListActivityResponse: SessionEvent {
  
  
  /**  */
  public func getIntervals() -> [Any]? {
    return self.attributes["intervals"] as? [Any]
  }
}

/** Returns a list of all the history log entries associated with this subsystem. */
public class CareSubsystemListDetailedActivityRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CareSubsystemListDetailedActivityRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemListDetailedActivity
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
    return CareSubsystemListDetailedActivityResponse(message)
  }

  // MARK: ListDetailedActivityRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results. Note an exact time may be jumped to by specifying token as a timestamp in epoch milliseconds. */
    static let token: String = "token"
/** The devices to show activity for. If none are specified the value of careDevices will be used. */
    static let devices: String = "devices"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results. Note an exact time may be jumped to by specifying token as a timestamp in epoch milliseconds. */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
  /** The devices to show activity for. If none are specified the value of careDevices will be used. */
  public func setDevices(_ devices: [String]) {
    attributes[Attributes.devices] = devices as AnyObject
  }

  
}

public class CareSubsystemListDetailedActivityResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this subsystem */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

/**  */
public class CareSubsystemListBehaviorsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemListBehaviors
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
    return CareSubsystemListBehaviorsResponse(message)
  }

  
}

public class CareSubsystemListBehaviorsResponse: SessionEvent {
  
  
  /**  */
  public func getBehaviors() -> [Any]? {
    return self.attributes["behaviors"] as? [Any]
  }
}

/**  */
public class CareSubsystemListBehaviorTemplatesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemListBehaviorTemplates
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
    return CareSubsystemListBehaviorTemplatesResponse(message)
  }

  
}

public class CareSubsystemListBehaviorTemplatesResponse: SessionEvent {
  
  
  /**  */
  public func getBehaviorTemplates() -> [Any]? {
    return self.attributes["behaviorTemplates"] as? [Any]
  }
}

/**  */
public class CareSubsystemAddBehaviorRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CareSubsystemAddBehaviorRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemAddBehavior
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
    return CareSubsystemAddBehaviorResponse(message)
  }

  // MARK: AddBehaviorRequest Attributes
  struct Attributes {
    /** Behavior to add. */
    static let behavior: String = "behavior"
 }
  
  /** Behavior to add. */
  public func setBehavior(_ behavior: Any) {
    attributes[Attributes.behavior] = behavior as AnyObject
  }

  
}

public class CareSubsystemAddBehaviorResponse: SessionEvent {
  
  
  /**  */
  public func getId() -> String? {
    return self.attributes["id"] as? String
  }
}

/** Updates the requested attributes on the specified behavior. */
public class CareSubsystemUpdateBehaviorRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CareSubsystemUpdateBehaviorRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemUpdateBehavior
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
    return CareSubsystemUpdateBehaviorResponse(message)
  }

  // MARK: UpdateBehaviorRequest Attributes
  struct Attributes {
    /** Behavior to add. */
    static let behavior: String = "behavior"
 }
  
  /** Behavior to add. */
  public func setBehavior(_ behavior: Any) {
    attributes[Attributes.behavior] = behavior as AnyObject
  }

  
}

public class CareSubsystemUpdateBehaviorResponse: SessionEvent {
  
}

/** Updates the requested attributes on the specified behavior. */
public class CareSubsystemRemoveBehaviorRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: CareSubsystemRemoveBehaviorRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.careSubsystemRemoveBehavior
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
    return CareSubsystemRemoveBehaviorResponse(message)
  }

  // MARK: RemoveBehaviorRequest Attributes
  struct Attributes {
    /** Id of the behavior to remove. */
    static let id: String = "id"
 }
  
  /** Id of the behavior to remove. */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
}

public class CareSubsystemRemoveBehaviorResponse: SessionEvent {
  
  
  /**  */
  public func getRemoved() -> Bool? {
    return self.attributes["removed"] as? Bool
  }
}

