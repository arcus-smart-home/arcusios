
//
// ProductCapEvents.swift
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


// MARK: Enumerations

/** Product Arcus Certification */
public enum ProductCert: String {
  case compatible = "COMPATIBLE"
  case none = "NONE"
  case works = "WORKS"
}

/** Primary battery size */
public enum ProductBatteryPrimSize: String {
  case _9v = "_9V"
  case aaaa = "AAAA"
  case aaa = "AAA"
  case aa = "AA"
  case c = "C"
  case d = "D"
  case cr123 = "CR123"
  case cr2 = "CR2"
  case cr2032 = "CR2032"
  case cr2430 = "CR2430"
  case cr2450 = "CR2450"
  case cr14250 = "CR14250"
}

/** Backup battery size */
public enum ProductBatteryBackSize: String {
  case _9v = "_9V"
  case aaaa = "AAAA"
  case aaa = "AAA"
  case aa = "AA"
  case c = "C"
  case d = "D"
  case cr123 = "CR123"
  case cr2 = "CR2"
  case cr2032 = "CR2032"
  case cr2430 = "CR2430"
  case cr2450 = "CR2450"
  case cr14250 = "CR14250"
}

/** The pairing mode for the device.  If not specified it will be defaulted to HUB. EXTERNAL_APP:  Requires a different mobile application, for example for voice assistants. WIFI:  Requires the mobile app and typically custom soft AP pairing logic. HUB:  Requires the hub to be present for pairing. IPCD:  Requires manual entry of information to align an IP connected device with a place, typically the serial number. OAUTH:  Requires interaction with a third-party for cloud to cloud integration. BRIDGED_DEVICE:  Requires some bridge device to be paired first where the bridge device is specified in the devRequired attribute.  */
public enum ProductPairingMode: String {
  case external_app = "EXTERNAL_APP"
  case wifi = "WIFI"
  case hub = "HUB"
  case ipcd = "IPCD"
  case oauth = "OAUTH"
  case bridged_device = "BRIDGED_DEVICE"
}

// MARK: Requests

