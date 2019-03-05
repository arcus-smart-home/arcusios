
//
// IrrigationZoneCapEvents.swift
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

/** Indicates whether the zone is currently watering or not */
public enum IrrigationZoneZoneState: String {
  case watering = "WATERING"
  case not_watering = "NOT_WATERING"
}

/** If watering, what triggered the watering event */
public enum IrrigationZoneWateringTrigger: String {
  case manual = "MANUAL"
  case scheduled = "SCHEDULED"
}

/** Color used to represent the zone on the UI. */
public enum IrrigationZoneZonecolor: String {
  case lightred = "LIGHTRED"
  case darkred = "DARKRED"
  case orange = "ORANGE"
  case yellow = "YELLOW"
  case lightgreen = "LIGHTGREEN"
  case darkgreen = "DARKGREEN"
  case lightblue = "LIGHTBLUE"
  case darkblue = "DARKBLUE"
  case violet = "VIOLET"
  case white = "WHITE"
  case grey = "GREY"
  case black = "BLACK"
}

// MARK: Requests

