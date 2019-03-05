
//
// LutronBridgeCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class LutronBridgeCapabilityLegacy: NSObject, ArcusLutronBridgeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: LutronBridgeCapabilityLegacy  = LutronBridgeCapabilityLegacy()
  
  static let LutronBridgeOperatingmodeSTARTUP: String = LutronBridgeOperatingmode.startup.rawValue
  static let LutronBridgeOperatingmodeNORMAL: String = LutronBridgeOperatingmode.normal.rawValue
  static let LutronBridgeOperatingmodeASSOCIATION: String = LutronBridgeOperatingmode.association.rawValue
  static let LutronBridgeOperatingmodeERROR: String = LutronBridgeOperatingmode.error.rawValue
  

  
  public static func getOperatingmode(_ model: DeviceModel) -> String? {
    return capability.getLutronBridgeOperatingmode(model)?.rawValue
  }
  
  public static func getSerialnumber(_ model: DeviceModel) -> String? {
    return capability.getLutronBridgeSerialnumber(model)
  }
  
}
