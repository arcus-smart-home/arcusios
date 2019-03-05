//
//  ArcusClientMessage.swift
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

// TODO: Add better docs.
/**
 `ArcusClientMessage` protocol
 */
public protocol ArcusClientMessage: ArcusSocketMessage {
  var type: String { get set }
  var source: String { get set }
  var destination: String { get set }
  var correlationId: String { get set }
  var isRequest: Bool { get set }
  var command: String { get set }
  var attributes: [String: AnyObject] { get set }
}

/**
 `ArcusClientRequest` protocol
 */
public protocol ArcusClientRequest {
  func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent
}

/**
 `ArcusClientResponse` protocol
 */
public protocol ArcusClientResponse {
  var request: ArcusClientRequest? { get set }

  func getResponseEvent() throws -> ArcusEvent
}
