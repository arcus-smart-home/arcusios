
//
// DevicePowerCapEvents.swift
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
public struct DevicePowerEvents {
  /** Fired when a line powered device loses power and is on backup battery. */
  public static let devicePowerBackupBattery: String = "devpow:BackupBattery"
  /** Fired when a device currently on backup battery has line power restored. */
  public static let devicePowerLinePowerRestored: String = "devpow:LinePowerRestored"
  /** Fired when a battery (backup or otherwise) is under 40%. */
  public static let devicePowerBatteryLow: String = "devpow:BatteryLow"
  }

// MARK: Enumerations

/** Indicates that this device is currently line-powered */
public enum DevicePowerSource: String {
  case line = "LINE"
  case battery = "BATTERY"
  case backupbattery = "BACKUPBATTERY"
}

// MARK: Requests

