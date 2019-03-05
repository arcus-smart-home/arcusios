//
//  ArcusSocket.swift
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
import CocoaLumberjack

/**
 `ArcusSocket` protocol defines behavior of a class that needs message based communication with
 Web Sockets.
 */
public  protocol ArcusSocket: class {
  var state: ArcusSocketState { get set }
  var config: ArcusSocketConfig { get set }
  weak var delegate: ArcusSocketDelegate? { get set }
  var currentRetryAttempts: Int { get set }
  var shouldReconnect: Bool { get set }

  var connectHandler: () -> Void { get }
  var disconnectHandler: () -> Void { get }
  var reconnctHandler: () -> Void { get }
  var writeHandler: (_ message: ArcusSocketMessage) -> Void { get }

  /**
   Setter for `ArcusSocketState`; will notify `ArcusSocketDelegate` of the change.

   - Parameters:
   - state: The new `ArcusSocketState` to set.
   */
  func updateState(_ state: ArcusSocketState)

  /**
   Getter for `ArcusSocketState`.

   - Returns: `ArcusSocketState` representing the socket's connection state.
   */
  func getState() -> ArcusSocketState

  /**
   Connect the socket.
   */
  func connect()

  /**
   Disconnect the socket.

   - Parameters:
   - allowReconnect: Bool indicating if the socket should attempt to reconnect.
   */
  func disconnect(_ allowReconnect: Bool)

  /**
   Reconnect the socket after connection loss.
   */
  func reconnect()

  /**
   Send a message.

   - Parameters:
   - message: The ArcusSocketMessage to be sent.
   */
  func send(_ message: ArcusSocketMessage)

  /**
   Set the socket configuration

   - Parameters:
   - config: Class conforming to `ArcusSocketConfig`
   */
  func configureSocket(_ config: ArcusSocketConfig)
}

/**
 `ArcusSocketDelegate` protocol extension. This is extension allows for abstracting the connection 
 state/retry logic from conforming classes while still allowing for the class to specify specific
 connection/disconnection logic.
 */
extension ArcusSocket {
  /*
   Connect the socket.
   */
  public func connect() {
    // Do not connect if connected
    guard getState() != .connected else {
      DDLogInfo("ArcusSocket: aborted connection attempt, already connected.")
      return
    }
    DDLogInfo("ArcusSocket: connecting.")

    // Update connection state
    updateState(.connecting)

    // Attempt connection
    connectHandler()
  }

  /**
   Disconnect the socket.
   */
  public func disconnect(_ allowReconnect: Bool = false) {
    // Do not disconnect if not connected
    guard getState() != .disconnected && getState() != .disconnecting else { return }

    // Prevent socket from attempting to reconnect
    shouldReconnect = allowReconnect

    // Update connection state
    updateState(.disconnecting)

    // Attempt disconnect
    disconnectHandler()
  }

  /**
   Reconnect the socket after connection loss.
   */
  public func reconnect() {
    // Do not reconnect if disconnect() was called
    guard shouldReconnect == true else { return }
    // Do not reconnect if max retry attempts has been reached
    guard currentRetryAttempts < config.retryAttempts else {
      // Update state to disconnected.
      updateState(.disconnected)

      return
    }

    // Incremement retry attempt count
    currentRetryAttempts += 1

    // Attempt reconnect
    reconnctHandler()
  }

  /**
   Send a message.

   - Parameters:
   - message: The ArcusSocketRequest to be sent.
   */
  public func send(_ message: ArcusSocketMessage) {
    // Only attempt to write to the socket if connected
    guard getState() == .connected else { return }

    // Attempt to write message to the socket
    writeHandler(message)
  }
}

/**
 `ArcusSocketDelegate` protocol for communicating state changes and message I/O on `ArcusSocket`.  Should be
 conformed to by class which uses `ArcusSocket` as a dependency.  (i.e. ArcusClient conforming classes)
 */
public protocol ArcusSocketDelegate: class {
  /**
   Relay connection state changes to the delegate.

   - Parameters:
   - socket: `ArcusSocket` conforming class owning the reference to the delegate.
   - state: Current `ArcusSocketState` reporting by `ArcusSocket`
   */
  func socket(_ socket: ArcusSocket, connectionStateChanged state: ArcusSocketState)

  /**
   Relay message I/O to the delegate.

   - Parameters:
   - socket: `ArcusSocket` conforming class owning the reference to the delegate.
   - message: `ArcusSocketMessage` received by `ArcusSocket`
   */
  func socket(_ socket: ArcusSocket, didReceiveMessage message: ArcusSocketMessage)
}
