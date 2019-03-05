
//
// DoorsNLocksSubsystemCapEvents.swift
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
  /** Authorizes the given people on the lock.  Any people that previously existed on the lock not in this set will be deauthorized */
  static let doorsNLocksSubsystemAuthorizePeople: String = "subdoorsnlocks:AuthorizePeople"
  /** Synchronizes the access on the device and the service, by clearing all pins and reassociating people that should have access */
  static let doorsNLocksSubsystemSynchAuthorization: String = "subdoorsnlocks:SynchAuthorization"
  
}
// MARK: Events
public struct DoorsNLocksSubsystemEvents {
  /** Emitted from the subsystem when a person is authorized on a lock */
  public static let doorsNLocksSubsystemPersonAuthorized: String = "subdoorsnlocks:PersonAuthorized"
  /** Emitted from the subsystem when a person is deauthorized from a lock */
  public static let doorsNLocksSubsystemPersonDeauthorized: String = "subdoorsnlocks:PersonDeauthorized"
  /** Emitted when a door lock is jammed. */
  public static let doorsNLocksSubsystemLockJammed: String = "subdoorsnlocks:LockJammed"
  /** Emitted when a door lock is no longer jammed. */
  public static let doorsNLocksSubsystemLockUnjammed: String = "subdoorsnlocks:LockUnjammed"
  /** Emitted when a motorized door is obstructed. */
  public static let doorsNLocksSubsystemMotorizedDoorObstructed: String = "subdoorsnlocks:MotorizedDoorObstructed"
  /** Emitted when a motorized door is no longer obstructed. */
  public static let doorsNLocksSubsystemMotorizedDoorUnobstructed: String = "subdoorsnlocks:MotorizedDoorUnobstructed"
  }

// MARK: Enumerations

// MARK: Requests

/** Authorizes the given people on the lock.  Any people that previously existed on the lock not in this set will be deauthorized */
public class DoorsNLocksSubsystemAuthorizePeopleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DoorsNLocksSubsystemAuthorizePeopleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.doorsNLocksSubsystemAuthorizePeople
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
    return DoorsNLocksSubsystemAuthorizePeopleResponse(message)
  }

  // MARK: AuthorizePeopleRequest Attributes
  struct Attributes {
    /** The address of the door lock to disassociate/associate people with */
    static let device: String = "device"
/** The set of people to assign to the door lock */
    static let operations: String = "operations"
 }
  
  /** The address of the door lock to disassociate/associate people with */
  public func setDevice(_ device: String) {
    attributes[Attributes.device] = device as AnyObject
  }

  
  /** The set of people to assign to the door lock */
  public func setOperations(_ operations: [Any]) {
    attributes[Attributes.operations] = operations as AnyObject
  }

  
}

public class DoorsNLocksSubsystemAuthorizePeopleResponse: SessionEvent {
  
  
  /** true if there are changes pending, false if no changes were required */
  public func getChangesPending() -> Bool? {
    return self.attributes["changesPending"] as? Bool
  }
}

/** Synchronizes the access on the device and the service, by clearing all pins and reassociating people that should have access */
public class DoorsNLocksSubsystemSynchAuthorizationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DoorsNLocksSubsystemSynchAuthorizationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.doorsNLocksSubsystemSynchAuthorization
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
    return DoorsNLocksSubsystemSynchAuthorizationResponse(message)
  }

  // MARK: SynchAuthorizationRequest Attributes
  struct Attributes {
    /** The address of the device to synchronize */
    static let device: String = "device"
 }
  
  /** The address of the device to synchronize */
  public func setDevice(_ device: String) {
    attributes[Attributes.device] = device as AnyObject
  }

  
}

public class DoorsNLocksSubsystemSynchAuthorizationResponse: SessionEvent {
  
}

