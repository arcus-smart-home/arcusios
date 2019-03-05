
//
// DoorLockCapEvents.swift
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
  /** Authorizes a person on this lock by adding the person&#x27;s pin on the lock and returns the slot ID used */
  static let doorLockAuthorizePerson: String = "doorlock:AuthorizePerson"
  /** Remove the pin for the given user from the lock and sets the slot state to UNUSED */
  static let doorLockDeauthorizePerson: String = "doorlock:DeauthorizePerson"
  /** Temporarily unlock the lock if locked.  Automatically relock in 30 seconds. */
  static let doorLockBuzzIn: String = "doorlock:BuzzIn"
  /** Clear all the pins currently set in the lock. */
  static let doorLockClearAllPins: String = "doorlock:ClearAllPins"
  
}
// MARK: Events
public struct DoorLockEvents {
  /** If the driver supports it this will be emitted when an invalid pin is entered */
  public static let doorLockInvalidPin: String = "doorlock:InvalidPin"
  /** Fired when a pin is used to lock or unlock the lock */
  public static let doorLockPinUsed: String = "doorlock:PinUsed"
  /** Fired when a pin is added manually at the lock. */
  public static let doorLockPinAddedAtLock: String = "doorlock:PinAddedAtLock"
  /** Fired when a pin is removed manually at the lock. */
  public static let doorLockPinRemovedAtLock: String = "doorlock:PinRemovedAtLock"
  /** Fired when a pin is changed manually at the lock. */
  public static let doorLockPinChangedAtLock: String = "doorlock:PinChangedAtLock"
  /** Emitted when the driver receives a report that a person has been provisioned on the device */
  public static let doorLockPersonAuthorized: String = "doorlock:PersonAuthorized"
  /** Emitted when the driver receives a report that a person has been deprovisioned from the device */
  public static let doorLockPersonDeauthorized: String = "doorlock:PersonDeauthorized"
  /** Emitted when the driver receives report that a person&#x27;s PIN operation failed on the device */
  public static let doorLockPinOperationFailed: String = "doorlock:PinOperationFailed"
  /**  */
  public static let doorLockAllPinsCleared: String = "doorlock:AllPinsCleared"
  /** Emitted when the drivers receives a failure clearing the pins or fails to recieve confirmation */
  public static let doorLockClearAllPinsFailed: String = "doorlock:ClearAllPinsFailed"
  }

// MARK: Enumerations

/** Reflects the state of the lock mechanism. */
public enum DoorLockLockstate: String {
  case locked = "LOCKED"
  case unlocked = "UNLOCKED"
  case locking = "LOCKING"
  case unlocking = "UNLOCKING"
}

/** Reflects the type of door lock. */
public enum DoorLockType: String {
  case deadbolt = "DEADBOLT"
  case leverlock = "LEVERLOCK"
  case other = "OTHER"
}

// MARK: Requests

/** Authorizes a person on this lock by adding the person&#x27;s pin on the lock and returns the slot ID used */
public class DoorLockAuthorizePersonRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DoorLockAuthorizePersonRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.doorLockAuthorizePerson
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
    return DoorLockAuthorizePersonResponse(message)
  }

  // MARK: AuthorizePersonRequest Attributes
  struct Attributes {
    /** The ID of the person to add to the lock */
    static let personId: String = "personId"
 }
  
  /** The ID of the person to add to the lock */
  public func setPersonId(_ personId: String) {
    attributes[Attributes.personId] = personId as AnyObject
  }

  
}

public class DoorLockAuthorizePersonResponse: SessionEvent {
  
  
  /** The slot ID that was assigned to the user */
  public func getSlotId() -> String? {
    return self.attributes["slotId"] as? String
  }
}

/** Remove the pin for the given user from the lock and sets the slot state to UNUSED */
public class DoorLockDeauthorizePersonRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: DoorLockDeauthorizePersonRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.doorLockDeauthorizePerson
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
    return DoorLockDeauthorizePersonResponse(message)
  }

  // MARK: DeauthorizePersonRequest Attributes
  struct Attributes {
    /** The ID of the person to remove from the lock */
    static let personId: String = "personId"
 }
  
  /** The ID of the person to remove from the lock */
  public func setPersonId(_ personId: String) {
    attributes[Attributes.personId] = personId as AnyObject
  }

  
}

public class DoorLockDeauthorizePersonResponse: SessionEvent {
  
}

/** Temporarily unlock the lock if locked.  Automatically relock in 30 seconds. */
public class DoorLockBuzzInRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.doorLockBuzzIn
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
    return DoorLockBuzzInResponse(message)
  }

  
}

public class DoorLockBuzzInResponse: SessionEvent {
  
  
  /** True or false, the lock was unlocked. */
  public func getUnlocked() -> Bool? {
    return self.attributes["unlocked"] as? Bool
  }
}

/** Clear all the pins currently set in the lock. */
public class DoorLockClearAllPinsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.doorLockClearAllPins
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
    return DoorLockClearAllPinsResponse(message)
  }

  
}

public class DoorLockClearAllPinsResponse: SessionEvent {
  
  
  /** True or false, the pins were removed from the lock. */
  public func getUnlocked() -> Bool? {
    return self.attributes["unlocked"] as? Bool
  }
}

