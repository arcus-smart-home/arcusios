//
//  ClientError(errorType: .swift)
//  i2app
//
//  Created by Arcus Team on 12/21/17.
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
//

import Foundation

public protocol ArcusError: Error {
  associatedtype ErrorType

  var errorType: ErrorType! { get set}
  var code: String { get }
  var message: String! { get set }

  init()
  init(errorType: ErrorType, message: String)
  init?(code: String, message: String)
}

public extension ArcusError {
  public init(errorType: ErrorType, message: String) {
    self.init()
    self.errorType = errorType
    self.message = message
  }

  public var localizedDescription: String {
    return message
  }
}

public struct ClientError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorCode
  }
  public var message: String!

  var errorCode: String!

  public init() {}

  public init(errorType: ErrorType = .unknown, message: String = "") {
    self.errorType = errorType
    self.errorCode = errorType.rawValue
    self.message = message
  }

  public init?(code: String, message: String) {
    var type: ErrorType = .unknown
    if let codeType = ErrorType(rawValue: code) {
      type = codeType
    }

    self.errorType = type
    self.errorCode = code
    self.message = message
  }

  public enum ErrorType: String, RawRepresentable {
    case unknown = "error.arcus.unknown"
    case genericError = "error.arcus.genericError"
    case invalidConformance = "error.arcus.invalidConformance"
    case requestError = "error.arcus.requestError"
    case operationTimeout = "error.arcus.operationTimeout"
  }
}
