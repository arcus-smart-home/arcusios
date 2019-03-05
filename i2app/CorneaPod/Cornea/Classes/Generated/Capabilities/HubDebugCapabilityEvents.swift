
//
// HubDebugCapEvents.swift
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
  /** Gets the current contents of the HubOS syslog file. */
  static let hubDebugGetFiles: String = "hubdebug:GetFiles"
  /** Gets the current contents of the agent database. */
  static let hubDebugGetAgentDb: String = "hubdebug:GetAgentDb"
  /** Gets the current contents of the HubOS syslog file. */
  static let hubDebugGetSyslog: String = "hubdebug:GetSyslog"
  /** Gets the current contents of the HubOS bootlog file. */
  static let hubDebugGetBootlog: String = "hubdebug:GetBootlog"
  /** Gets the current list of processes from the HubOS. */
  static let hubDebugGetProcesses: String = "hubdebug:GetProcesses"
  /** Gets the current process load information from the HubOS. */
  static let hubDebugGetLoad: String = "hubdebug:GetLoad"
  
}


// MARK: Requests

/** Gets the current contents of the HubOS syslog file. */
public class HubDebugGetFilesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubDebugGetFilesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetFiles
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
    return HubDebugGetFilesResponse(message)
  }

  // MARK: GetFilesRequest Attributes
  struct Attributes {
    /** List of files/directories to return. */
    static let paths: String = "paths"
 }
  
  /** List of files/directories to return. */
  public func setPaths(_ paths: [String]) {
    attributes[Attributes.paths] = paths as AnyObject
  }

  
}

public class HubDebugGetFilesResponse: SessionEvent {
  
  
  /** Zip file of files, base 64 encoded. */
  public func getContent() -> String? {
    return self.attributes["content"] as? String
  }
}

/** Gets the current contents of the agent database. */
public class HubDebugGetAgentDbRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetAgentDb
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
    return HubDebugGetAgentDbResponse(message)
  }

  
}

public class HubDebugGetAgentDbResponse: SessionEvent {
  
  
  /** Agent database, gzip compressed, and base 64 encoded. */
  public func getDb() -> String? {
    return self.attributes["db"] as? String
  }
}

/** Gets the current contents of the HubOS syslog file. */
public class HubDebugGetSyslogRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetSyslog
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
    return HubDebugGetSyslogResponse(message)
  }

  
}

public class HubDebugGetSyslogResponse: SessionEvent {
  
  
  /** Recent syslog statements from the hub, gzip compressed, and base 64 encoded. */
  public func getSyslogs() -> String? {
    return self.attributes["syslogs"] as? String
  }
}

/** Gets the current contents of the HubOS bootlog file. */
public class HubDebugGetBootlogRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetBootlog
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
    return HubDebugGetBootlogResponse(message)
  }

  
}

public class HubDebugGetBootlogResponse: SessionEvent {
  
  
  /** Recent bootlog statements from the hub, gzip compressed, and base 64 encoded. */
  public func getBootlogs() -> String? {
    return self.attributes["bootlogs"] as? String
  }
}

/** Gets the current list of processes from the HubOS. */
public class HubDebugGetProcessesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetProcesses
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
    return HubDebugGetProcessesResponse(message)
  }

  
}

public class HubDebugGetProcessesResponse: SessionEvent {
  
  
  /** Current processes from the hub, gzip compressed, and base 64 encoded. */
  public func getProcesses() -> String? {
    return self.attributes["processes"] as? String
  }
}

/** Gets the current process load information from the HubOS. */
public class HubDebugGetLoadRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubDebugGetLoad
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
    return HubDebugGetLoadResponse(message)
  }

  
}

public class HubDebugGetLoadResponse: SessionEvent {
  
  
  /** Current process load information from the hub, gzip compressed, and base 64 encoded. */
  public func getLoad() -> String? {
    return self.attributes["load"] as? String
  }
}

