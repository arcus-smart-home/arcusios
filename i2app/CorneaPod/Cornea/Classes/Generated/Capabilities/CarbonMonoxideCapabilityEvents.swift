
//
// CarbonMonoxideCapEvents.swift
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

/** Reflects the state of the carbon monoxide presence. When &#x27;DETECTED&#x27; the sensor has detected CO, when &#x27;SAFE&#x27; no CO has been detected. */
public enum CarbonMonoxideCo: String {
  case safe = "SAFE"
  case detected = "DETECTED"
}

/** Reflects the state of the carbon monoxide sensor itself. When &#x27;OK&#x27; the sensor is operational, when &#x27;EOL&#x27; the sensor has reached its &#x27;end-of-life&#x27; and should be replaced. */
public enum CarbonMonoxideEol: String {
  case ok = "OK"
  case eol = "EOL"
}

// MARK: Requests

