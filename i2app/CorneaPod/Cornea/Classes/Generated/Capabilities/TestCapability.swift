
//
// TestCap.swift
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
  public static var testNamespace: String = "test"
  public static var testName: String = "Test"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let testLastTestTime: String = "test:lastTestTime"
  
}

public protocol ArcusTestCapability: class, RxArcusService {
  /** The last time the device was tested (a test:Test event was emitted). */
  func getTestLastTestTime(_ model: DeviceModel) -> Date?
  
  
}

extension ArcusTestCapability {
  public func getTestLastTestTime(_ model: DeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.testLastTestTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
}
