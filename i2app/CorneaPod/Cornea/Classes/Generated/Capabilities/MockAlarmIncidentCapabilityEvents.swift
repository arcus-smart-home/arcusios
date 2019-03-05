
//
// MockAlarmIncidentCapEvents.swift
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
  /** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Adds the history entry for contacting a person.  If no person is specified the person issuing the call will be used. */
  static let mockAlarmIncidentContacted: String = "incidentmock:Contacted"
  /** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to CANCELLED and the alertState to COMPLETE.  Also creates the appropriate history entries.             If no person is specified the person issuing the call will be used. */
  static let mockAlarmIncidentDispatchCancelled: String = "incidentmock:DispatchCancelled"
  /** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.             If the alertState is CANCELLING it should be changed to COMPLETE. */
  static let mockAlarmIncidentDispatchAccepted: String = "incidentmock:DispatchAccepted"
  /** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.           If the alertState is CANCELLING it should be changed to COMPLETE. */
  static let mockAlarmIncidentDispatchRefused: String = "incidentmock:DispatchRefused"
  
}


// MARK: Requests

/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Adds the history entry for contacting a person.  If no person is specified the person issuing the call will be used. */
public class MockAlarmIncidentContactedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: MockAlarmIncidentContactedRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.mockAlarmIncidentContacted
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
    return MockAlarmIncidentContactedResponse(message)
  }

  // MARK: ContactedRequest Attributes
  struct Attributes {
    /** The address of the person to contact */
    static let person: String = "person"
 }
  
  /** The address of the person to contact */
  public func setPerson(_ person: String) {
    attributes[Attributes.person] = person as AnyObject
  }

  
}

public class MockAlarmIncidentContactedResponse: SessionEvent {
  
}

/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to CANCELLED and the alertState to COMPLETE.  Also creates the appropriate history entries.             If no person is specified the person issuing the call will be used. */
public class MockAlarmIncidentDispatchCancelledRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: MockAlarmIncidentDispatchCancelledRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.mockAlarmIncidentDispatchCancelled
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
    return MockAlarmIncidentDispatchCancelledResponse(message)
  }

  // MARK: DispatchCancelledRequest Attributes
  struct Attributes {
    /** The address of the person to contact */
    static let person: String = "person"
 }
  
  /** The address of the person to contact */
  public func setPerson(_ person: String) {
    attributes[Attributes.person] = person as AnyObject
  }

  
}

public class MockAlarmIncidentDispatchCancelledResponse: SessionEvent {
  
}

/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.             If the alertState is CANCELLING it should be changed to COMPLETE. */
public class MockAlarmIncidentDispatchAcceptedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: MockAlarmIncidentDispatchAcceptedRequest Enumerations
  /** The authority for the incident incident. */
  public enum MockAlarmIncidentAuthority: String {
   case fire = "FIRE"
   case police = "POLICE"
   
  }
  override init() {
    super.init()
    self.command = Commands.mockAlarmIncidentDispatchAccepted
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
    return MockAlarmIncidentDispatchAcceptedResponse(message)
  }

  // MARK: DispatchAcceptedRequest Attributes
  struct Attributes {
    /** The authority for the incident incident. */
    static let authority: String = "authority"
 }
  
  /** The authority for the incident incident. */
  public func setAuthority(_ authority: String) {
    if let value: MockAlarmIncidentAuthority = MockAlarmIncidentAuthority(rawValue: authority) {
      attributes[Attributes.authority] = value.rawValue as AnyObject
    }
  }
  
}

public class MockAlarmIncidentDispatchAcceptedResponse: SessionEvent {
  
}

/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.           If the alertState is CANCELLING it should be changed to COMPLETE. */
public class MockAlarmIncidentDispatchRefusedRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: MockAlarmIncidentDispatchRefusedRequest Enumerations
  /** The authority for the incident incident. */
  public enum MockAlarmIncidentAuthority: String {
   case fire = "FIRE"
   case police = "POLICE"
   
  }
  override init() {
    super.init()
    self.command = Commands.mockAlarmIncidentDispatchRefused
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
    return MockAlarmIncidentDispatchRefusedResponse(message)
  }

  // MARK: DispatchRefusedRequest Attributes
  struct Attributes {
    /** The authority for the incident incident. */
    static let authority: String = "authority"
 }
  
  /** The authority for the incident incident. */
  public func setAuthority(_ authority: String) {
    if let value: MockAlarmIncidentAuthority = MockAlarmIncidentAuthority(rawValue: authority) {
      attributes[Attributes.authority] = value.rawValue as AnyObject
    }
  }
  
}

public class MockAlarmIncidentDispatchRefusedResponse: SessionEvent {
  
}

