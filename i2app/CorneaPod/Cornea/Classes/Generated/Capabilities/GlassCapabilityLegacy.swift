
//
// GlassCapabilityLegacy.swift
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

public class GlassCapabilityLegacy: NSObject, ArcusGlassCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: GlassCapabilityLegacy  = GlassCapabilityLegacy()
  
  static let GlassBreakSAFE: String = GlassBreak.safe.rawValue
  static let GlassBreakDETECTED: String = GlassBreak.detected.rawValue
  

  
  public static func getBreak(_ model: DeviceModel) -> String? {
    return capability.getGlassBreak(model)?.rawValue
  }
  
  public static func getBreakchanged(_ model: DeviceModel) -> Date? {
    guard let breakchanged: Date = capability.getGlassBreakchanged(model) else {
      return nil
    }
    return breakchanged
  }
  
}
