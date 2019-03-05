//
//  WiFiScanItem.swift
//  i2app
//
//  Created by Arcus Team on 7/10/18.
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
//

import Foundation

struct WiFiScanItem {
  var ssid: String = ""
  var security: String = ""
  var channel: Int = 0
  var signal: Double = 0

  init(ssid: String, security: String, channel: Int, signal: Double) {
    self.ssid = ssid
    self.security = security
    self.channel = channel
    self.signal = signal
  }

  init(json: [String: AnyObject]) {
    if let ssid = json["ssid"] as? String {
      self.ssid = ssid
    }

    if let security = json["security"] as? String {
      self.security = security
    }

    if let channel = json["channel"] as? Int {
      self.channel = channel
    }

    if let signal = json["signal"] as? Double {
      self.signal = signal
    }
  }

  static func imageForSignalStrength(_ signal: Double, security: String) -> UIImage {
    var signalIndex: String = ""

    if signal >= -55 {
      signalIndex = "5"
    } else if signal >= -70 {
      signalIndex = "4"
    } else if signal >= -85 {
      signalIndex = "3"
    } else if signal >= -100 {
      signalIndex = "2"
    } else {
      signalIndex = "1"
    }

    if security != "" && security != "None" && security != "[OPEN]" {
      return UIImage(named: "wifi_lock_" + signalIndex + "_23x20")!
    } else {
      return UIImage(named: "wifi_" + signalIndex + "_24x20")!
    }
  }

  static func imageForSignalStrength(_ signal: Double) -> UIImage {
    var signalIndex: String = ""

    if signal >= -55 {
      signalIndex = "5"
    } else if signal >= -70 {
      signalIndex = "4"
    } else if signal >= -85 {
      signalIndex = "3"
    } else if signal >= -100 {
      signalIndex = "2"
    } else {
      signalIndex = "1"
    }

    return UIImage(named: "wi-fi_white_" + signalIndex + "_24x20")!
  }
}

extension WiFiScanItem: Hashable {
  var hashValue: Int {
    return ssid.hashValue
  }

  static func == (lhs: WiFiScanItem, rhs: WiFiScanItem) -> Bool {
    return lhs.ssid == rhs.ssid
  }
}

extension WiFiScanItem: Comparable {
  static func < (lhs: WiFiScanItem, rhs: WiFiScanItem) -> Bool {
    return lhs.signal < rhs.signal
  }
}

extension WiFiScanItem: CustomDebugStringConvertible {
  var debugDescription: String {
    return "WiFiScanItem:\n"
      + "    SSID: \(ssid),\n"
      + "    Security: \(security),\n"
      + "    Channel: \(channel),\n"
      + "    Signal: \(signal)"
  }
}

class WifiScanItemHolder: NSObject {
  static func imageForSignalStrength(_ signal: Double) -> UIImage {
    return WiFiScanItem.imageForSignalStrength(signal)
  }
}
