//
//  Session.swift
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

public typealias CameraPreviewHandler = (Data?, Error?) -> Void

/**
 `Session` protocol defines a contract for network communication with the platform.
 */
public protocol ArcusSession {
  var client: ArcusClient { get set }
  var token: ArcusKeychain? { get set }
  var activeUser: ArcusKeychain? { get set }
  var userAgent: String { get set }
  var clientVersion: String { get set }
  var sessionInfo: ArcusSessionInfo? { get set }
  var socketConfig: ArcusSocketConfig? { get set }
  var platform: ArcusPlatformInstance { get set }

  func configureSessionUrl(_ platform: ArcusPlatformInstance, host: String?, port: Int?)
  func fetchCameraPreview(_ cameraId: String, placeId: String, completion: @escaping CameraPreviewHandler)

  /**
   Attempt to authenticate the client with the platform using username and password combination.

   - Parameters:
   - username: `String` representing the user to be authenticated.
   - password: `String` representing the password of the user to be authenticated.
   - completion: `(success: Bool, error: Error?) -> Void` closure used to process completion.
   */
  func login(_ username: String, password: String, completion: @escaping (Bool, Error?) -> Void)

  /**
   Logout from platform.
   */
  func logout()

  /**
   Connect the client to the platform.
   */
  func connect()

  /**
   Connect the client to the platform via application URL.

   - Parameters: String value for the token to attempt to configure the client with.
   */
  func connectWithToken(_ value: String)

  /**
   Disconnect client from the platform.
   */
  func disconnect()

  /**
   Temporarily halts client communications with the platform without closing the connection.
   (Assumes client has been connected.)
   */
  func suspend()

  /**
   Resume halted client communications with the platform.
   (Assumes client has been connected, and suspended.)
   */
  func resume()

  /**
   Set Active Place with Id

   - Parameters:
   - placeId: Id of place to set as active
   */
  func setActivePlace(_ placeId: String)

  /**
   Send message with client.

   - Parameters:
   - message: `ArcusClientMessage` to submit to client
   */
  func send(_ message: ArcusClientMessage)
}

extension ArcusSession {}
