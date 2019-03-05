
//
// LeakH2OCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var leakH2ONamespace: String = "leakh2o"
  public static var leakH2OName: String = "LeakH2O"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let leakH2OState: String = "leakh2o:state"
  static let leakH2OStatechanged: String = "leakh2o:statechanged"
  
}

public protocol ArcusLeakH2OCapability: class, RxArcusService {
  /** Reflects the state of the leak detector. */
  func getLeakH2OState(_ model: DeviceModel) -> LeakH2OState?
  /** Reflects the state of the leak detector. */
  func setLeakH2OState(_ state: LeakH2OState, model: DeviceModel)
/** UTC date time of last state change */
  func getLeakH2OStatechanged(_ model: DeviceModel) -> Date?
  
  /**  */
  func requestLeakH2OLeakh2o(_  model: DeviceModel, state: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusLeakH2OCapability {
  public func getLeakH2OState(_ model: DeviceModel) -> LeakH2OState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.leakH2OState] as? String,
      let enumAttr: LeakH2OState = LeakH2OState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setLeakH2OState(_ state: LeakH2OState, model: DeviceModel) {
    model.set([Attributes.leakH2OState: state.rawValue as AnyObject])
  }
  public func getLeakH2OStatechanged(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.leakH2OStatechanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestLeakH2OLeakh2o(_  model: DeviceModel, state: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: LeakH2OLeakh2oRequest = LeakH2OLeakh2oRequest()
    request.source = model.address
    
    
    
    request.setState(state)
    
    return try sendRequest(request)
  }
  
}
