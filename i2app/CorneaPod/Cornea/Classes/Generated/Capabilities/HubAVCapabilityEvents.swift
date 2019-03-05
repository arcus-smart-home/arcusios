
//
// HubAVCapEvents.swift
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
  /** Pair an AV device to the hub */
  static let hubAVPair: String = "hubav:pair"
  /** Release an AV device from the hub */
  static let hubAVRelease: String = "hubav:release"
  /** Get current state of AV device */
  static let hubAVGetState: String = "hubav:getState"
  /** Get IPv4 address of AV device */
  static let hubAVGetIPAddress: String = "hubav:getIPAddress"
  /** Get model of AV device */
  static let hubAVGetModel: String = "hubav:getModel"
  /** Start audio on an AV device given an URL */
  static let hubAVAudioStart: String = "hubav:audioStart"
  /** Stop audio on an AV device */
  static let hubAVAudioStop: String = "hubav:audioStop"
  /** Pause audio on an AV device */
  static let hubAVAudioPause: String = "hubav:audioPause"
  /** Seek audio on an AV device */
  static let hubAVAudioSeekTo: String = "hubav:audioSeekTo"
  /** Set volume on an AV device */
  static let hubAVSetVolume: String = "hubav:setVolume"
  /** Get volume on an AV device */
  static let hubAVGetVolume: String = "hubav:getVolume"
  /** Set mute on an AV device */
  static let hubAVSetMute: String = "hubav:setMute"
  /** Get mute on an AV device */
  static let hubAVGetMute: String = "hubav:getMute"
  /** Get information about current audio track */
  static let hubAVAudioInfo: String = "hubav:audioInfo"
  
}
// MARK: Events
public struct HubAVEvents {
  /** Sent when the status of an AV device pairing changes. */
  public static let hubAVAVDevicePairingStatus: String = "hubav:AVDevicePairingStatus"
  }

// MARK: Enumerations

// MARK: Requests

/** Pair an AV device to the hub */
public class HubAVPairRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVPairRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVPair
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
    return HubAVPairResponse(message)
  }

  // MARK: pairRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVPairResponse: SessionEvent {
  
  
  /** A status indicating status of the pairing */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the pairing */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Release an AV device from the hub */
public class HubAVReleaseRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVReleaseRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVRelease
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
    return HubAVReleaseResponse(message)
  }

  // MARK: releaseRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVReleaseResponse: SessionEvent {
  
  
  /** A status indicating status of the release */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the release */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An informative message about the status */
  public func getMessage() -> String? {
    return self.attributes["message"] as? String
  }
}

/** Get current state of AV device */
public class HubAVGetStateRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVGetStateRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVGetState
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
    return HubAVGetStateResponse(message)
  }

  // MARK: getStateRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVGetStateResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** Current state of device */
  public enum HubAVState: String {
    case uninitialized = "UNINITIALIZED"
    case initialized = "INITIALIZED"
    case paired = "PAIRED"
    case disconnected = "DISCONNECTED"
    case retry = "RETRY"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** Current state of device */
  public func getState() -> HubAVState? {
    guard let attribute = self.attributes["state"] as? String,
      let enumAttr: HubAVState = HubAVState(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Get IPv4 address of AV device */
public class HubAVGetIPAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVGetIPAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVGetIPAddress
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
    return HubAVGetIPAddressResponse(message)
  }

  // MARK: getIPAddressRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVGetIPAddressResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The IPv4 address of the device */
  public func getIpAddress() -> String? {
    return self.attributes["ipAddress"] as? String
  }
}

/** Get model of AV device */
public class HubAVGetModelRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVGetModelRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVGetModel
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
    return HubAVGetModelResponse(message)
  }

  // MARK: getModelRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVGetModelResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The model name of the device */
  public func getModel() -> String? {
    return self.attributes["model"] as? String
  }
}

/** Start audio on an AV device given an URL */
public class HubAVAudioStartRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVAudioStartRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVAudioStart
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
    return HubAVAudioStartResponse(message)
  }

  // MARK: audioStartRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
/** URL of media to play */
    static let url: String = "url"
/** Metadata of media to play */
    static let metadata: String = "metadata"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
  /** URL of media to play */
  public func setUrl(_ url: String) {
    attributes[Attributes.url] = url as AnyObject
  }

  
  /** Metadata of media to play */
  public func setMetadata(_ metadata: String) {
    attributes[Attributes.metadata] = metadata as AnyObject
  }

  
}

public class HubAVAudioStartResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Stop audio on an AV device */
public class HubAVAudioStopRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVAudioStopRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVAudioStop
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
    return HubAVAudioStopResponse(message)
  }

  // MARK: audioStopRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVAudioStopResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Pause audio on an AV device */
public class HubAVAudioPauseRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVAudioPauseRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVAudioPause
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
    return HubAVAudioPauseResponse(message)
  }

  // MARK: audioPauseRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVAudioPauseResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Seek audio on an AV device */
public class HubAVAudioSeekToRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVAudioSeekToRequest Enumerations
  /** Seek mode of operation */
  public enum HubAVUnit: String {
   case rel_time = "REL_TIME"
   case track_nr = "TRACK_NR"
   
  }
  override init() {
    super.init()
    self.command = Commands.hubAVAudioSeekTo
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
    return HubAVAudioSeekToResponse(message)
  }

  // MARK: audioSeekToRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
/** Seek mode of operation */
    static let unit: String = "unit"
/** The offset (in milliseconds) or track number. */
    static let target: String = "target"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
  /** Seek mode of operation */
  public func setUnit(_ unit: String) {
    if let value: HubAVUnit = HubAVUnit(rawValue: unit) {
      attributes[Attributes.unit] = value.rawValue as AnyObject
    }
  }
  
  /** The offset (in milliseconds) or track number. */
  public func setTarget(_ target: Int) {
    attributes[Attributes.target] = target as AnyObject
  }

  
}

public class HubAVAudioSeekToResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Set volume on an AV device */
public class HubAVSetVolumeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVSetVolumeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVSetVolume
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
    return HubAVSetVolumeResponse(message)
  }

  // MARK: setVolumeRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
/** The volume, 0-100 */
    static let volume: String = "volume"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
  /** The volume, 0-100 */
  public func setVolume(_ volume: Int) {
    attributes[Attributes.volume] = volume as AnyObject
  }

  
}

public class HubAVSetVolumeResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Get volume on an AV device */
public class HubAVGetVolumeRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVGetVolumeRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVGetVolume
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
    return HubAVGetVolumeResponse(message)
  }

  // MARK: getVolumeRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVGetVolumeResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The volume level of the device, 0-100 */
  public func getLevel() -> Int? {
    return self.attributes["level"] as? Int
  }
}

/** Set mute on an AV device */
public class HubAVSetMuteRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVSetMuteRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVSetMute
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
    return HubAVSetMuteResponse(message)
  }

  // MARK: setMuteRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
/** The mute setting */
    static let mute: String = "mute"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
  /** The mute setting */
  public func setMute(_ mute: Bool) {
    attributes[Attributes.mute] = mute as AnyObject
  }

  
}

public class HubAVSetMuteResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
}

/** Get mute on an AV device */
public class HubAVGetMuteRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVGetMuteRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVGetMute
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
    return HubAVGetMuteResponse(message)
  }

  // MARK: getMuteRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVGetMuteResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The mute setting of the device */
  public func getMute() -> Bool? {
    return self.attributes["mute"] as? Bool
  }
}

/** Get information about current audio track */
public class HubAVAudioInfoRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubAVAudioInfoRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubAVAudioInfo
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
    return HubAVAudioInfoResponse(message)
  }

  // MARK: audioInfoRequest Attributes
  struct Attributes {
    /** The UUID of the device. */
    static let uuid: String = "uuid"
 }
  
  /** The UUID of the device. */
  public func setUuid(_ uuid: String) {
    attributes[Attributes.uuid] = uuid as AnyObject
  }

  
}

public class HubAVAudioInfoResponse: SessionEvent {
  
  
  /** A status indicating status of the method */
  public enum HubAVStatus: String {
    case ok = "OK"
    case refused = "REFUSED"
    
  }
  /** A status indicating status of the method */
  public func getStatus() -> HubAVStatus? {
    guard let attribute = self.attributes["status"] as? String,
      let enumAttr: HubAVStatus = HubAVStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** The track number */
  public func getTrack() -> Int? {
    return self.attributes["track"] as? Int
  }
  /** The track URI */
  public func getUri() -> String? {
    return self.attributes["uri"] as? String
  }
  /** The track metadata */
  public func getMetadata() -> String? {
    return self.attributes["metadata"] as? String
  }
  /** The track duration */
  public func getDuration() -> String? {
    return self.attributes["duration"] as? String
  }
  /** The track relative time */
  public func getReltime() -> String? {
    return self.attributes["reltime"] as? String
  }
}

