//
//  Client.swift
//  i2app
//
//  Created by Arcus Team on 5/24/17.
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
import RxSwift

// TypeAlias for HTTP request completion closure.
public typealias HTTPCompletionHandler = (_ response: ArcusHttpResponse?, _ error: Error?) -> Void

/**
 `ArcusClient` protocol defines a Observable-based contract for network communication.
 */
public protocol ArcusClient: class {
  var clientUrl: URL? { get set }
  var clientHeaders: [String: AnyObject] { get set }
  var clientCookies: [String: String] { get set }
  var socket: ArcusSocket { get set }

  // MARK: EXTENDED

  /**
   Method used to configure the client for HTTP communication, and configure the client's socket for
   WebSocket communication.

   - Parameters:
   - clientUrl: Optional `URL` used by the client for HTTP communication.
   - clientHeaders: `[String: AnyObject]` headers to be sent with HTTP communication.
   - clientCookies: `[String: String]` cookies to be sent with HTTP communication.
   - config: `ArcusSocketConfig` used to configure WebSocket Communication.
   */
  func configureClient(_ clientUrl: URL?,
                       clientHeaders: [String: AnyObject],
                       clientCookies: [String: String],
                       socketConfig: ArcusSocketConfig)

  /**
   Connect the client.
   */
  func connect()

  /**
   Disconnect the client.

   - Parameters:
   - allowReconnect: Bool indicating if the socket should attempt to reconnect.
   */
  func disconnect(_ allowReconnect: Bool)

  /**
   Send a message.

   - Parameters:
   - message: The message to be sent.
   */
  func send(_ message: ArcusClientMessage)

  /**
   Send http request

   - Parameters:
   - request: The HttpRequest to be sent.
   - completionHandler:  Closure to handle the processing of the received response or error.
   */
  func sendHttp(_ request: HttpRequest,
                _ completionHandler: @escaping HTTPCompletionHandler)

  /**
   Send `ArcusClientMessage` as `HttpRequest`.

   - Parameters:
   - message: The `ArcusClientMessage` to be sent.
   */
  func sendHttp(_ message: ArcusClientMessage)
}

extension ArcusClient {
  public func configureClient(_ clientUrl: URL? = nil,
                       clientHeaders: [String: AnyObject],
                       clientCookies: [String: String],
                       socketConfig: ArcusSocketConfig) {
    self.clientUrl = clientUrl
    self.clientHeaders = clientHeaders
    self.clientCookies = clientCookies
    configureSocket(socketConfig)
  }

  fileprivate func configureSocket(_ config: ArcusSocketConfig) {
    socket.configureSocket(config)
  }

  public func connect() {
    socket.connect()
  }

  public func disconnect(_ allowReconnect: Bool = false) {
    socket.disconnect(allowReconnect)
  }

  func send(_ message: ArcusClientMessage) {
    // Send the message.
    socket.send(message)
  }

  func sendHttp(_ request: HttpRequest, _ completionHandler: @escaping HTTPCompletionHandler) {

  }
}

extension ArcusClient where Self: ArcusClientMessageQueue {
  public func send(_ message: ArcusClientMessage) {
    // Add the message to pending messages.
    appendPending(message)

    socket.send(message)
  }
}

public protocol ArcusClientMessageQueue: class {
  var pendingMessages: [String: ArcusClientMessage] { get set }
  var pendingQueue: DispatchQueue { get set }

  /**
   Add pending message.

   - Parameters:
   - message: The message to be added.
   */
  func appendPending(_ message: ArcusClientMessage)

  /**
   Remove pending message.

   - Parameters:
   - correlationId: `String` representing the correlationId of the message to return.
   */
  func removePending(_ correlationId: String)

  /**
   Retrieve pending message.

   - Parameters:
   - correlationId: `String` representing the correlationId of the message to return.

   - Returns: `ArcusClientMessage` if found in pendingMessages.
   */
  func getPending(_ correlationId: String) -> ArcusClientMessage?
}

extension ArcusClientMessageQueue {
  public func appendPending(_ message: ArcusClientMessage) {
    pendingQueue.async(flags:.barrier) {
      self.pendingMessages[message.correlationId] = message
    }
  }

  public func removePending(_ correlationId: String) {
    pendingQueue.async(flags:.barrier) {
      self.pendingMessages[correlationId] = nil
    }
  }

  public func getPending(_ correlationId: String) -> ArcusClientMessage? {
    var result: ArcusClientMessage?
    pendingQueue.sync {
      result = self.pendingMessages[correlationId]
    }
    return result
  }
}
