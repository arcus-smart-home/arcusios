
//
// IrrigationControllerCapEvents.swift
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
  /** Starts watering the indicated zone for the duration specified. */
  static let irrigationControllerWaterNowV2: String = "irrcont:WaterNowV2"
  /** Cancels any watering currently in progress. */
  static let irrigationControllerCancelV2: String = "irrcont:CancelV2"
  /** This method was deprecated in 1.8. */
  static let irrigationControllerWaterNow: String = "irrcont:WaterNow"
  /** This method was deprecated in 1.8. */
  static let irrigationControllerCancel: String = "irrcont:Cancel"
  
}

// MARK: Enumerations

/** Indicates whether the zone is currently watering or not */
public enum IrrigationControllerControllerState: String {
  case off = "OFF"
  case watering = "WATERING"
  case not_watering = "NOT_WATERING"
  case rain_delay = "RAIN_DELAY"
}

// MARK: Requests

/** Starts watering the indicated zone for the duration specified. */
public class IrrigationControllerWaterNowV2Request: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationControllerWaterNowV2Request Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationControllerWaterNowV2
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
    return IrrigationControllerWaterNowV2Response(message)
  }

  // MARK: WaterNowV2Request Attributes
  struct Attributes {
    /** The zone number to begin watering. */
    static let zone: String = "zone"
/** How long, in minutes, to water the zone. */
    static let duration: String = "duration"
 }
  
  /** The zone number to begin watering. */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
  /** How long, in minutes, to water the zone. */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
}

public class IrrigationControllerWaterNowV2Response: SessionEvent {
  
  
  /** True for success or false for a failure. */
  public func getSuccessful() -> Bool? {
    return self.attributes["successful"] as? Bool
  }
}

/** Cancels any watering currently in progress. */
public class IrrigationControllerCancelV2Request: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationControllerCancelV2Request Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationControllerCancelV2
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
    return IrrigationControllerCancelV2Response(message)
  }

  // MARK: CancelV2Request Attributes
  struct Attributes {
    /** The zone number to begin watering. */
    static let zone: String = "zone"
 }
  
  /** The zone number to begin watering. */
  public func setZone(_ zone: String) {
    attributes[Attributes.zone] = zone as AnyObject
  }

  
}

public class IrrigationControllerCancelV2Response: SessionEvent {
  
  
  /** True for success or false for a failure. */
  public func getSuccessful() -> Bool? {
    return self.attributes["successful"] as? Bool
  }
}

/** This method was deprecated in 1.8. */
public class IrrigationControllerWaterNowRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationControllerWaterNowRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationControllerWaterNow
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
    return IrrigationControllerWaterNowResponse(message)
  }

  // MARK: WaterNowRequest Attributes
  struct Attributes {
    /** This parameter was deprecated in 1.8. */
    static let zonenum: String = "zonenum"
/** How long, in minutes, to water the zone. */
    static let duration: String = "duration"
 }
  
  /** This parameter was deprecated in 1.8. */
  public func setZonenum(_ zonenum: Int) {
    attributes[Attributes.zonenum] = zonenum as AnyObject
  }

  
  /** How long, in minutes, to water the zone. */
  public func setDuration(_ duration: Int) {
    attributes[Attributes.duration] = duration as AnyObject
  }

  
}

public class IrrigationControllerWaterNowResponse: SessionEvent {
  
  
  /** True for success or false for a failure. */
  public func getSuccessful() -> Bool? {
    return self.attributes["successful"] as? Bool
  }
}

/** This method was deprecated in 1.8. */
public class IrrigationControllerCancelRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IrrigationControllerCancelRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.irrigationControllerCancel
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
    return IrrigationControllerCancelResponse(message)
  }

  // MARK: CancelRequest Attributes
  struct Attributes {
    /** This parameter was deprecated in 1.8. */
    static let zonenum: String = "zonenum"
 }
  
  /** This parameter was deprecated in 1.8. */
  public func setZonenum(_ zonenum: Int) {
    attributes[Attributes.zonenum] = zonenum as AnyObject
  }

  
}

public class IrrigationControllerCancelResponse: SessionEvent {
  
  
  /** True for success or false for a failure. */
  public func getSuccessful() -> Bool? {
    return self.attributes["successful"] as? Bool
  }
}

