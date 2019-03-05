
//
// IdentifyCap.swift
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
  public static var identifyNamespace: String = "ident"
  public static var identifyName: String = "Identify"
}



public protocol ArcusIdentifyCapability: class, RxArcusService {
  
  /** Causes this device to identify itself by blinking an LED or playing a sound.  This method should not return a response to a request until the device has started its notification.  It is expected notification will last for a short period of time, and this call will be repeated often.  A second call to Identify while the device is already actively identifying itself should be a no-op and return immediately. */
  func requestIdentifyIdentify(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusIdentifyCapability {
  
  public func requestIdentifyIdentify(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: IdentifyIdentifyRequest = IdentifyIdentifyRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
