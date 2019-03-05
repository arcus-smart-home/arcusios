
//
// WaterSubsystemCapEvents.swift
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

// MARK: Events
public struct WaterSubsystemEvents {
  /** Emitted when a new water flow sensor detects continuous use. The device address will also be added to continuousWaterUseDevices. */
  public static let waterSubsystemContinuousWaterUse: String = "subwater:ContinuousWaterUse"
  /** Emitted when a new water flow sensor detects excessive use. The device address will also be added to excessiveWaterUseDevices. */
  public static let waterSubsystemExcessiveWaterUse: String = "subwater:ExcessiveWaterUse"
  /** Emitted when a new water softener is added to the set of low salt devices. */
  public static let waterSubsystemLowSalt: String = "subwater:LowSalt"
  }

// MARK: Enumerations

// MARK: Requests

