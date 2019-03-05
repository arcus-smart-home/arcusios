
//
// CellBackupSubsystemCapEvents.swift
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
  /** Sets status = ERRORED, errorState = BANNED so that the hub bridge will not auth this hub if it connects via cellular. */
  static let cellBackupSubsystemBan: String = "cellbackup:Ban"
  /** Resets status to best-choice [READY, ACTIVE, NOTREADY] and sets errorState to NONE */
  static let cellBackupSubsystemUnban: String = "cellbackup:Unban"
  
}
// MARK: Events
public struct CellBackupSubsystemEvents {
  /** Event emitted from the subsystem to the hub-bridges to boot the hub if it is currently connected by cell backup */
  public static let cellBackupSubsystemCellAccessBanned: String = "cellbackup:CellAccessBanned"
  /** Event emitted from the subsystem to the hub-bridges to boot the hub if it is currently connected by cell backup */
  public static let cellBackupSubsystemCellAccessUnbanned: String = "cellbackup:CellAccessUnbanned"
  }

// MARK: Enumerations

/**  READY:  Will work: Modem is plugged in, healthy, connected, and add on subscription exists for place ACTIVE:  Is working: Hub is actively connected to hub bridge via cellular NOTREADY:  Will not work (user recoverable) : check notReadyState to see if they need a modem or a subscription ERRORED:  Will not work (requires contact center) : check erroredState for more information  */
public enum CellBackupSubsystemStatus: String {
  case ready = "READY"
  case active = "ACTIVE"
  case notready = "NOTREADY"
  case errored = "ERRORED"
}

/**  NONE:  No error NOSIM:  Modem is plugged in but does not have a SIM NOTPROVISIONED:  Modem is plugged in but SIM is/was not properly provisioned DISABLED: BANNED: OTHER:  Modem is pluggin in and has a provisioned SIM but for some reason it cannot connect (hub4g:connectionStatus will have a vendor specific code as to why)  */
public enum CellBackupSubsystemErrorState: String {
  case none = "NONE"
  case nosim = "NOSIM"
  case notprovisioned = "NOTPROVISIONED"
  case disabled = "DISABLED"
  case banned = "BANNED"
  case other = "OTHER"
}

/**  NEEDSSUB:  Modem is plugged in, healthy, and connected, but no add on subscription for place exists NEEDSMODEM:  Add on subscription for place exists, but no modem plugged in BOTH:  Needs both modem and subscription  */
public enum CellBackupSubsystemNotReadyState: String {
  case needssub = "NEEDSSUB"
  case needsmodem = "NEEDSMODEM"
  case both = "BOTH"
}

// MARK: Requests

/** Sets status = ERRORED, errorState = BANNED so that the hub bridge will not auth this hub if it connects via cellular. */
public class CellBackupSubsystemBanRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.cellBackupSubsystemBan
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
    return CellBackupSubsystemBanResponse(message)
  }

  
}

public class CellBackupSubsystemBanResponse: SessionEvent {
  
}

/** Resets status to best-choice [READY, ACTIVE, NOTREADY] and sets errorState to NONE */
public class CellBackupSubsystemUnbanRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.cellBackupSubsystemUnban
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
    return CellBackupSubsystemUnbanResponse(message)
  }

  
}

public class CellBackupSubsystemUnbanResponse: SessionEvent {
  
}

