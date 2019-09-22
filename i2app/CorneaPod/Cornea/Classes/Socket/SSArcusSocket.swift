//
//  SSArcusSocket.swift
//  i2app
//
//  Created by Arcus Team on 6/5/17.
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
import Starscream
import CocoaLumberjack

public class SSArcusSocket: ArcusSocket, StarscreamSocket, WebSocketDelegate {
  weak public var delegate: ArcusSocketDelegate?
  public var config: ArcusSocketConfig = SocketConfig.emptyConfig()

  private let callbackQueue: DispatchQueue = DispatchQueue(label: "socketCallback",
                                                           qos: .utility)
  private let stateQueue: DispatchQueue = DispatchQueue(label: "stateQueue",
                                                        qos: .utility)

  public var state: ArcusSocketState = .uninitialized

  // MARK: ArcusSocket Handlers

  public var connectHandler: () -> Void {
    return { [weak self] in
      DDLogInfo("SSArcusSocket: connectHandler fired.")

      // Do not connect if no config.
      guard self?.config.headers["empty"] == nil else {
        DDLogInfo("SSArcusSocket: empty config found.")

        // Update connection state
        self?.updateState(.closed)

        return
      }
      
      // Attempt connection
      self?.socket?.connect()
    }
  }

  public var disconnectHandler: () -> Void {
    return { [weak socket] in
      DDLogInfo("SSArcusSocket: disconnectHandler fired.")

      // Attempt disconnect
      socket?.disconnect()
    }
  }

  public var reconnctHandler: () -> Void {
    return { [weak self] in
      DDLogInfo("SSArcusSocket: reconnctHandler fired.")

      // If socket is connected, do not attempt reconnect.
      guard let socket = self?.socket, socket.isConnected == false else {
        return
      }

      self?.updateState(.reconnecting)

      // Retry after delay
      var delay: Double = 0
      if let retry: Double = self?.config.retryDelay {
        delay = retry
      }
      let dispatchTime = DispatchTime.now() + delay

      DispatchQueue.global(qos: .default)
        .asyncAfter(deadline: dispatchTime, execute: {
          // Attempt reconnect
          self?.connect()
        })
    }
  }

  public var writeHandler: (ArcusSocketMessage) -> Void {
    return { [weak socket] message in
      // Get message JSON
      let json = message.message()

      DDLogInfo("SSArcusSocket: writeHandler fired with message: \(json)")

      // Attempt to write JSON to the socket
      socket?.write(string: json)
    }
  }

  public var socket: WebSocket?

  public var currentRetryAttempts: Int = 0
  public var shouldReconnect: Bool = true

  deinit {
    state = .closed
    delegate = nil
    socket = nil
  }

  public func updateState(_ state: ArcusSocketState) {
    stateQueue.async(flags: .barrier) {
      self.state = state
    }
    callbackQueue.async {
      self.delegate?.socket(self, connectionStateChanged: state)
    }
  }

  public func getState() -> ArcusSocketState {
    var state: ArcusSocketState = .unknown
    stateQueue.sync {
      state = self.state
    }
    return state
  }

  /**
   Set the socket configuration

   - Parameters:
   - config: Class conforming to `ArcusSocketConfig`
   */
  public func configureSocket(_ config: ArcusSocketConfig) {
    DDLogInfo("SSArcusSocket: Configuring Socket with Config: \(config).")

    self.config = config
    var request = URLRequest(url: config.uri)

    // Add headers
    for (header, value) in config.headers {
        request.setValue(value, forHTTPHeaderField: header)
    }

    configure(WebSocket(request: request))
  }

  // MARK: SSSocket Configuration

  /**
   Configure the socket connection.
   
   - Parameters:
   - socket: The WebSocket to be configured.
   */
  func configure(_ socket: WebSocket) {
    DDLogInfo("SSArcusSocket: Configuring Socket.")

    // Set Callbacks for Delegation
    configureDelegateHandling(socket)

    // Set the Socket
    self.socket = socket
  }

  /**
   Configure the socket delegation.

   - Parameters:
   - socket: The WebSocket to be configured.
   */
  func configureDelegateHandling(_ socket: WebSocket) {
    DDLogInfo("SSArcusSocket: Configuring Delegate Handling.")

    socket.callbackQueue = callbackQueue

    socket.delegate = self
  }

  // MARK: Socket Delegation Handling
    
  /**
   Websocket did connect.
   */
  public func websocketDidConnect(socket: WebSocketClient) {
    DDLogInfo("SSArcusSocket: Websocket did connect.")

    // Update connection state
    updateState(.connected)

    // Reset current retry attempts to zero
    currentRetryAttempts = 0

    // Allow reconnection attempts
    shouldReconnect = true
  }

  /**
   Websocket did disconnect.

   - Parameters:
   - error: The error (if any) received on disconnect.
   */
  public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    DDLogInfo("SSArcusSocket: Websocket did disconnect.")

    // Process Error
    let error = error as? WSError

    if let code = error?.code {
      // If Platform issues closes connection app should receive a 4001
      if code == 4001 {
        updateState(.closed)
        return
      }
      // If the token is no longer valid, app appears to be receiving a 401
      if code == 401 {
        updateState(.closed)
        return
      }
    }

    // If ArcusSocket shouldReconnect, call reconnect(), otherwise disconnect.
    if shouldReconnect == true {
      // Attempt reconnect
      reconnect()
    } else {
      // Update connection state
      updateState(.disconnected)
    }
  }

  /**
   Websocket did receive a message.

   - Parameters:
   - text: The string received.
   */
  public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    DDLogInfo("SSArcusSocket: Websocket did receive message.")
    DDLogVerbose("SSArcusSocket: message: \(text)")

    // TODO: UPDATE
    let message = SocketMessage(text)
    
    // Pass received message to the delegate
    delegate?.socket(self, didReceiveMessage: message)
  }

  /**
   Websocket did receive data.

   - Parameters:
   - data: The data received.
   */
  public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    DDLogInfo("SSArcusSocket: Websocket did receive data.")
    DDLogVerbose("SSArcusSocket: data: \(data)")

    // TODO: UPDATE
    //let message = ArcusClientMessage(data)
    let message = ClientMessage()

    // Pass received message to the delegate
    delegate?.socket(self, didReceiveMessage: message)
  }
}
