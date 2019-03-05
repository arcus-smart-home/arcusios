
//
// PlaceMonitorSubsystemCapEvents.swift
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
  /** Renders all alerts */
  static let placeMonitorSubsystemRenderAlerts: String = "subplacemonitor:RenderAlerts"
  
}
// MARK: Events
public struct PlaceMonitorSubsystemEvents {
  /** Sent when a hub is offline for a specified measure of time. */
  public static let placeMonitorSubsystemHubOffline: String = "subplacemonitor:HubOffline"
  /** Sent when a hub comes back online after being offline for a specified measure of time. */
  public static let placeMonitorSubsystemHubOnline: String = "subplacemonitor:HubOnline"
  /** Sent when a device is offline for a specified measure of time. */
  public static let placeMonitorSubsystemDeviceOffline: String = "subplacemonitor:DeviceOffline"
  /** Sent when a device comes back online after being offline for a specified measure of time. */
  public static let placeMonitorSubsystemDeviceOnline: String = "subplacemonitor:DeviceOnline"
  }

// MARK: Enumerations

/** Pairing state of the place. */
public enum PlaceMonitorSubsystemPairingState: String {
  case pairing = "PAIRING"
  case unpairing = "UNPAIRING"
  case idle = "IDLE"
  case partial = "PARTIAL"
}

// MARK: Requests

/** Renders all alerts */
public class PlaceMonitorSubsystemRenderAlertsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeMonitorSubsystemRenderAlerts
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
    return PlaceMonitorSubsystemRenderAlertsResponse(message)
  }

  
}

public class PlaceMonitorSubsystemRenderAlertsResponse: SessionEvent {
  
  
  /** List of rendered alerts JSON formatted for consumption via the UI. */
  public func getAlerts() -> [Any]? {
    return self.attributes["alerts"] as? [Any]
  }
}

