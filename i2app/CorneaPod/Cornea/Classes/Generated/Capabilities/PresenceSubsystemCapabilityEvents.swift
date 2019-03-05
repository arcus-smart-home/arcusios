
//
// PresenceSubsystemCapEvents.swift
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
  /** Presence analysis describes, for each person, whether the subsystem thinks the person is at home or not and how it came to that conclusion. */
  static let presenceSubsystemGetPresenceAnalysis: String = "subspres:GetPresenceAnalysis"
  
}
// MARK: Events
public struct PresenceSubsystemEvents {
  /** Sent when a person or device becomes present. */
  public static let presenceSubsystemArrived: String = "subspres:Arrived"
  /** Sent when a person or device devices. */
  public static let presenceSubsystemDeparted: String = "subspres:Departed"
  /** Sent when a presence device associated with a person becomes present. */
  public static let presenceSubsystemPersonArrived: String = "subspres:PersonArrived"
  /** Sent when a presence device associated with a person becomes absent */
  public static let presenceSubsystemPersonDeparted: String = "subspres:PersonDeparted"
  /** Sent when a presence device associated with a place becomes present. */
  public static let presenceSubsystemDeviceArrived: String = "subspres:DeviceArrived"
  /** Sent when a presence device associated with a place becomes absent */
  public static let presenceSubsystemDeviceDeparted: String = "subspres:DeviceDeparted"
  /** Sent when a presence device is associated with a person */
  public static let presenceSubsystemDeviceAssignedToPerson: String = "subspres:DeviceAssignedToPerson"
  /** Sent when a presence device is unassociated with a person */
  public static let presenceSubsystemDeviceUnassignedFromPerson: String = "subspres:DeviceUnassignedFromPerson"
  /** Sent when at least one presence device assigned to people is present */
  public static let presenceSubsystemPlaceOccupied: String = "subspres:PlaceOccupied"
  /** Sent when all presence device assigned to people are absent */
  public static let presenceSubsystemPlaceUnoccupied: String = "subspres:PlaceUnoccupied"
  }

// MARK: Enumerations

// MARK: Requests

/** Presence analysis describes, for each person, whether the subsystem thinks the person is at home or not and how it came to that conclusion. */
public class PresenceSubsystemGetPresenceAnalysisRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.presenceSubsystemGetPresenceAnalysis
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
    return PresenceSubsystemGetPresenceAnalysisResponse(message)
  }

  
}

public class PresenceSubsystemGetPresenceAnalysisResponse: SessionEvent {
  
  
  /**  */
  public func getAnalysis() -> [String: Any]? {
    return self.attributes["analysis"] as? [String: Any]
  }
}

