
//
// LeakGasCapabilityLegacy.swift
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

public class LeakGasCapabilityLegacy: NSObject, ArcusLeakGasCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: LeakGasCapabilityLegacy  = LeakGasCapabilityLegacy()
  
  static let LeakGasStateSAFE: String = LeakGasState.safe.rawValue
  static let LeakGasStateLEAK: String = LeakGasState.leak.rawValue
  

  
  public static func getState(_ model: DeviceModel) -> String? {
    return capability.getLeakGasState(model)?.rawValue
  }
  
  public static func getStatechanged(_ model: DeviceModel) -> Date? {
    guard let statechanged: Date = capability.getLeakGasStatechanged(model) else {
      return nil
    }
    return statechanged
  }
  
}
