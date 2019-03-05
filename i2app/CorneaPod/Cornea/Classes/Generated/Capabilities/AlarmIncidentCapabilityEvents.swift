
//
// AlarmIncidentCapEvents.swift
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
  /** Escalates a PreAlert incident to Alerting immediately. */
  static let alarmIncidentVerify: String = "incident:Verify"
  /** Attempts to cancel the current alert, if one is active.  This will attempt to silence all alarms and stop the alert from going to the monitoring center if the alert is professionally monitored. */
  static let alarmIncidentCancel: String = "incident:Cancel"
  /** Returns a list of all the history log entries associated with this incident */
  static let alarmIncidentListHistoryEntries: String = "incident:ListHistoryEntries"
  
}
// MARK: Events
public struct AlarmIncidentEvents {
  /** Fired when a carbon monoxide alarm is triggered */
  public static let alarmIncidentCOAlert: String = "incident:COAlert"
  /** Fired when a panic alarm is triggered */
  public static let alarmIncidentPanicAlert: String = "incident:PanicAlert"
  /** Fired when a security alarm is triggered */
  public static let alarmIncidentSecurityAlert: String = "incident:SecurityAlert"
  /** Fired when a smoke alarm is triggered */
  public static let alarmIncidentSmokeAlert: String = "incident:SmokeAlert"
  /** Fired when a water alarm is triggered */
  public static let alarmIncidentWaterAlert: String = "incident:WaterAlert"
  /** Fired when new history about an incident is added */
  public static let alarmIncidentHistoryAdded: String = "incident:HistoryAdded"
  /** Fired when an incident has fully completed */
  public static let alarmIncidentCompleted: String = "incident:Completed"
  }

// MARK: Errors
public struct AlarmIncidentVerifyError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If an attempt is made to escalate a completed incident. */
    case securityInactiveIncident = "security.inactiveIncident"
    
  }
}
// MARK: Enumerations

/** The current alert state of the incident.  This may begin in PREALERT for a security alarm grace period, then go to ALERT, transition to CANCELLING when the user requests that it be cancelled, and finally to COMPLETE when it is no longer active. */
public enum AlarmIncidentAlertState: String {
  case prealert = "PREALERT"
  case alert = "ALERT"
  case cancelling = "CANCELLING"
  case complete = "COMPLETE"
}

/** An enum of the current monitoring state: NONE - If the alerts are not monitored PENDING - If the alert is monitored but we have not contacted the monitoring station yet DISPATCHING - If we have contacted the monitoring station but the authorities have not been contacted yet DISPATCHED - If the authorities have been contacted REFUSED - If the authorities have been contacted but refused the dispatch CANCELLED - If the alarm was cancelled before the authorities were contacted FAILED - If the signal to the monitoring station failed or the monitoring station did not clear the incident within a configured timeout. */
public enum AlarmIncidentMonitoringState: String {
  case none = "NONE"
  case pending = "PENDING"
  case dispatching = "DISPATCHING"
  case dispatched = "DISPATCHED"
  case refused = "REFUSED"
  case cancelled = "CANCELLED"
  case failed = "FAILED"
}

/** An enum of the current platform&#x27;s view of the incident state.  If hubState is not present, this will be the same as alertState. */
public enum AlarmIncidentPlatformState: String {
  case prealert = "PREALERT"
  case alert = "ALERT"
  case cancelling = "CANCELLING"
  case complete = "COMPLETE"
}

/** An enum of the current hub&#x27;s view of the incident state.  If there is only a platform alarm provider this will not be present. */
public enum AlarmIncidentHubState: String {
  case prealert = "PREALERT"
  case alert = "ALERT"
  case cancelling = "CANCELLING"
  case complete = "COMPLETE"
}

/** The primary alert type */
public enum AlarmIncidentAlert: String {
  case security = "SECURITY"
  case panic = "PANIC"
  case smoke = "SMOKE"
  case co = "CO"
  case water = "WATER"
  case care = "CARE"
  case weather = "WEATHER"
}

// MARK: Requests

/** Escalates a PreAlert incident to Alerting immediately. */
public class AlarmIncidentVerifyRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.alarmIncidentVerify
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

      let error = AlarmIncidentVerifyError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return AlarmIncidentVerifyResponse(message)
  }

  
}

public class AlarmIncidentVerifyResponse: SessionEvent {
  
}

/** Attempts to cancel the current alert, if one is active.  This will attempt to silence all alarms and stop the alert from going to the monitoring center if the alert is professionally monitored. */
public class AlarmIncidentCancelRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.alarmIncidentCancel
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
    return AlarmIncidentCancelResponse(message)
  }

  
}

public class AlarmIncidentCancelResponse: SessionEvent {
  
  
  /** An enum value representing the current state of the alarm     CANCELLED - The alarm is fully silenced and cancelled, no further information is needed     CLEARING - The alarm is silenced but some devices may still be making noise */
  public enum AlarmIncidentAlarmState: String {
    case cancelled = "CANCELLED"
    case clearing = "CLEARING"
    
  }
  /** An enum value representing the state of the professionally monitored alert     CANCELLED - The alarm is fully cancelled.     DISPATCHING - The alarm has been sent to UCC but they have not dispatched the authorities yet     DISPATCHED - The authorities were notified of this alarm */
  public enum AlarmIncidentMonitoringState: String {
    case cancelled = "CANCELLED"
    case dispatching = "DISPATCHING"
    case dispatched = "DISPATCHED"
    
  }
  /** An enum value representing the current state of the alarm     CANCELLED - The alarm is fully silenced and cancelled, no further information is needed     CLEARING - The alarm is silenced but some devices may still be making noise */
  public func getAlarmState() -> AlarmIncidentAlarmState? {
    guard let attribute = self.attributes["alarmState"] as? String,
      let enumAttr: AlarmIncidentAlarmState = AlarmIncidentAlarmState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An enum value representing the state of the professionally monitored alert     CANCELLED - The alarm is fully cancelled.     DISPATCHING - The alarm has been sent to UCC but they have not dispatched the authorities yet     DISPATCHED - The authorities were notified of this alarm */
  public func getMonitoringState() -> AlarmIncidentMonitoringState? {
    guard let attribute = self.attributes["monitoringState"] as? String,
      let enumAttr: AlarmIncidentMonitoringState = AlarmIncidentMonitoringState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The cleared flag should be false if the SMOKE or CO alarms are still CLEARING (not READY) or the monitoringState is not NONE or CANCELLED. */
  public func getCleared() -> Bool? {
    return self.attributes["cleared"] as? Bool
  }
  /** Warning title displayed on UI when the alarm is not cleared after cancel request. */
  public func getWarningTitle() -> String? {
    return self.attributes["warningTitle"] as? String
  }
  /** Warning message displayed on UI when the alarm is not cleared after cancel request. */
  public func getWarningMessage() -> String? {
    return self.attributes["warningMessage"] as? String
  }
}

/** Returns a list of all the history log entries associated with this incident */
public class AlarmIncidentListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AlarmIncidentListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.alarmIncidentListHistoryEntries
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
    return AlarmIncidentListHistoryEntriesResponse(message)
  }

  // MARK: ListHistoryEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class AlarmIncidentListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this place */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

