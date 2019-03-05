
//
// HubBackupCapEvents.swift
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
  /** Performs a backup in the hub, returning a binary blob in response. */
  static let hubBackupBackup: String = "hubbackup:Backup"
  /** Performs a restore on the hub. */
  static let hubBackupRestore: String = "hubbackup:Restore"
  
}
// MARK: Events
public struct HubBackupEvents {
  /** An event indicating that the migration process has finished. */
  public static let hubBackupRestoreFinished: String = "hubbackup:RestoreFinished"
  /** A progress report for migration. */
  public static let hubBackupRestoreProgress: String = "hubbackup:RestoreProgress"
  }


// MARK: Requests

/** Performs a backup in the hub, returning a binary blob in response. */
public class HubBackupBackupRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubBackupBackupRequest Enumerations
  /** The requested format of the backup data. */
  public enum HubBackupType: String {
   case v2 = "V2"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubBackupBackup
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
    return HubBackupBackupResponse(message)
  }

  // MARK: BackupRequest Attributes
  struct Attributes {
    /** The requested format of the backup data. */
    static let type: String = "type"
 }
  
  /** The requested format of the backup data. */
  public func setType(_ type: String) {
    if let value: HubBackupType = HubBackupType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class HubBackupBackupResponse: SessionEvent {
  
  
  /** A Base 64 encoded binary blob. */
  public func getData() -> String? {
    return self.attributes["data"] as? String
  }
}

/** Performs a restore on the hub. */
public class HubBackupRestoreRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubBackupRestoreRequest Enumerations
  /** The format of the backup data. */
  public enum HubBackupType: String {
   case v1 = "V1"
   case v2 = "V2"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubBackupRestore
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
    return HubBackupRestoreResponse(message)
  }

  // MARK: RestoreRequest Attributes
  struct Attributes {
    /** The format of the backup data. */
    static let type: String = "type"
/** A Base 64 encoded binary blob. */
    static let data: String = "data"
 }
  
  /** The format of the backup data. */
  public func setType(_ type: String) {
    if let value: HubBackupType = HubBackupType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
  /** A Base 64 encoded binary blob. */
  public func setData(_ data: String) {
    attributes[Attributes.data] = data as AnyObject
  }

  
}

public class HubBackupRestoreResponse: SessionEvent {
  
}

