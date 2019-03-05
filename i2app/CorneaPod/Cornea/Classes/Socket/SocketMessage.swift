//
//  SocketMessage.swift
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

/**
 `SocketMessage` struct used to pass message received by an instance of `ArcusSocket` to `ArcusSocketDelegate`.
 */
public struct SocketMessage: ArcusSocketMessage {
  public var text: String

  public init(_ text: String) {
    self.text = text
  }

  // MARK: `ArcusSocketMessage` Implementation

  public func message() -> String {
    return text
  }
}
