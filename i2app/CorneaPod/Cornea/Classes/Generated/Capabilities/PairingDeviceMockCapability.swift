
//
// PairingDeviceMockCap.swift
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
  public static var pairingDeviceMockNamespace: String = "pairdevmock"
  public static var pairingDeviceMockName: String = "PairingDeviceMock"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let pairingDeviceMockTargetProductAddress: String = "pairdevmock:targetProductAddress"
  
}

public protocol ArcusPairingDeviceMockCapability: class, RxArcusService {
  /** The eventual product address that will be displayed when / if a driver is created for this mock. */
  func getPairingDeviceMockTargetProductAddress(_ model: PairingDeviceMockModel) -> String?
  
  /** Updates the pairing phase, does not allow the mock to &#x27;go backwards&#x27; */
  func requestPairingDeviceMockUpdatePairingPhase(_  model: PairingDeviceMockModel, phase: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusPairingDeviceMockCapability {
  public func getPairingDeviceMockTargetProductAddress(_ model: PairingDeviceMockModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.pairingDeviceMockTargetProductAddress] as? String
  }
  
  
  public func requestPairingDeviceMockUpdatePairingPhase(_  model: PairingDeviceMockModel, phase: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PairingDeviceMockUpdatePairingPhaseRequest = PairingDeviceMockUpdatePairingPhaseRequest()
    request.source = model.address
    
    
    
    request.setPhase(phase)
    
    return try sendRequest(request)
  }
  
}
