
//
// MotionCapEvents.swift
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

/** Reflects the state of the motion sensor. When detected the motion sensor has detected motion, when none no motion has been detected. */
public enum MotionMotion: String {
  case none = "NONE"
  case detected = "DETECTED"
}

/** The sensitivity of the motion sensor where:  OFF:   Implies that the motion sensor is disabled and will not detect motion LOW:   Arcust possible detection sensitivity MED:   Moderate detection sensitivity HIGH:  High detection sensitivity MAX:   Maximum sensitivity the device can be set to.  This will be null for motion sensors that do not support modification of sensitivity.  */
public enum MotionSensitivity: String {
  case off = "OFF"
  case low = "LOW"
  case med = "MED"
  case high = "HIGH"
  case max = "MAX"
}

// MARK: Requests

