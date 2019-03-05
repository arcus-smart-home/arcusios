
//
// WeatherRadioCapEvents.swift
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
  /** Scans all stations to determine which can be heard. */
  static let weatherRadioScanStations: String = "noaa:ScanStations"
  /** Play selected station to allow user to select amongst the options. */
  static let weatherRadioPlayStation: String = "noaa:PlayStation"
  /** Stop playing current station. */
  static let weatherRadioStopPlayingStation: String = "noaa:StopPlayingStation"
  /** Select station as the one Halo will use. */
  static let weatherRadioSelectStation: String = "noaa:SelectStation"
  
}

// MARK: Enumerations

/** Reflects the current state of the weather radio (alerting, no existing alert, or an existing hushed alert). */
public enum WeatherRadioAlertstate: String {
  case alert = "ALERT"
  case no_alert = "NO_ALERT"
  case hushed = "HUSHED"
}

/** Reflects whether the weather radio is currently playing or is quiet. */
public enum WeatherRadioPlayingstate: String {
  case playing = "PLAYING"
  case quiet = "QUIET"
}

// MARK: Requests

/** Scans all stations to determine which can be heard. */
public class WeatherRadioScanStationsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.weatherRadioScanStations
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
    return WeatherRadioScanStationsResponse(message)
  }

  
}

public class WeatherRadioScanStationsResponse: SessionEvent {
  
  
  /** The list of stations discovered during the scan, like [ {&#x27;id&#x27;:1, &#x27;freq&#x27;:&#x27;106.240 MHz&#x27;, &#x27;rssi&#x27;:-67.0}, ... ] */
  public func getStations() -> [Any]? {
    return self.attributes["stations"] as? [Any]
  }
}

/** Play selected station to allow user to select amongst the options. */
public class WeatherRadioPlayStationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: WeatherRadioPlayStationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.weatherRadioPlayStation
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
    return WeatherRadioPlayStationResponse(message)
  }

  // MARK: PlayStationRequest Attributes
  struct Attributes {
    /** The ID of the station to play (1-7) */
    static let station: String = "station"
/** Timeout in seconds after which player will stop (-1 to play forever) */
    static let time: String = "time"
 }
  
  /** The ID of the station to play (1-7) */
  public func setStation(_ station: Int) {
    attributes[Attributes.station] = station as AnyObject
  }

  
  /** Timeout in seconds after which player will stop (-1 to play forever) */
  public func setTime(_ time: Int) {
    attributes[Attributes.time] = time as AnyObject
  }

  
}

public class WeatherRadioPlayStationResponse: SessionEvent {
  
}

/** Stop playing current station. */
public class WeatherRadioStopPlayingStationRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.weatherRadioStopPlayingStation
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
    return WeatherRadioStopPlayingStationResponse(message)
  }

  
}

public class WeatherRadioStopPlayingStationResponse: SessionEvent {
  
}

/** Select station as the one Halo will use. */
public class WeatherRadioSelectStationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: WeatherRadioSelectStationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.weatherRadioSelectStation
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
    return WeatherRadioSelectStationResponse(message)
  }

  // MARK: SelectStationRequest Attributes
  struct Attributes {
    /** The ID of the station to use (1-7) */
    static let station: String = "station"
 }
  
  /** The ID of the station to use (1-7) */
  public func setStation(_ station: Int) {
    attributes[Attributes.station] = station as AnyObject
  }

  
}

public class WeatherRadioSelectStationResponse: SessionEvent {
  
}

