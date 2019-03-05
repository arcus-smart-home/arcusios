
//
// AOSmithWaterHeaterControllerCapEvents.swift
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

/** The display unit of the temperation. */
public enum AOSmithWaterHeaterControllerUnits: String {
  case c = "C"
  case f = "F"
}

/** This is the mode setting of the device, not whether or not it is actually heating the water at the moment. */
public enum AOSmithWaterHeaterControllerControlmode: String {
  case standard = "STANDARD"
  case vacation = "VACATION"
  case energy_smart = "ENERGY_SMART"
}

/** Enable or disable leak detection. Or report that no sensor is present and force to disabled. */
public enum AOSmithWaterHeaterControllerLeakdetect: String {
  case disabled = "DISABLED"
  case enabled = "ENABLED"
  case notdetected = "NOTDETECTED"
}

/** Water conductivity detected on probes. */
public enum AOSmithWaterHeaterControllerLeak: String {
  case none = "NONE"
  case detected = "DETECTED"
  case unplugged = "UNPLUGGED"
  case error = "ERROR"
}

/** Status of upper and lower elements */
public enum AOSmithWaterHeaterControllerElementfail: String {
  case none = "NONE"
  case upper = "UPPER"
  case lower = "LOWER"
  case upper_lower = "UPPER_LOWER"
}

/** Status of uppwer and lower temperature sensors. */
public enum AOSmithWaterHeaterControllerTanksensorfail: String {
  case none = "NONE"
  case upper = "UPPER"
  case lower = "LOWER"
  case upper_lower = "UPPER_LOWER"
}

/** Master (ET) and Display (ESM) self-test status */
public enum AOSmithWaterHeaterControllerMasterdispfail: String {
  case none = "NONE"
  case master = "MASTER"
  case display = "DISPLAY"
}

// MARK: Requests

