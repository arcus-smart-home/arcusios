//
//  ClientResponse.swift
//  i2app
//
//  Created by Arcus Team on 9/18/17.
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

public struct ArcusClientMessageError: Error {
  enum ErrorType {
    case invalidConfig
  }

  let type: ErrorType
}

public class ClientResponse: ClientMessage, ArcusClientResponse {
  public var request: ArcusClientRequest?

  public func getResponseEvent() throws -> ArcusEvent {
    guard request != nil else {
      throw ArcusClientMessageError(type: .invalidConfig)
    }

    return request!.responseEventForMessage(self)
  }

  // Mark: Override `ClientMessage` conformance of `CustomDebugStringConvertible`

  override public var debugDescription: String {
    var requestString: String = "request: nil, \r\n"
    if request != nil {
      requestString = "request: \(request!), \r\n"
    }
    return super.debugDescription
      .replacingOccurrences(of: "ClientMessage", with: "ClientResponse") + requestString
  }
}
