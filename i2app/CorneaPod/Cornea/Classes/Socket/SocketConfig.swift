//
//  SocketConfig.swift
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

// TODO: Improve Docs
/**
 `SocketConfig` struct
 */
public struct SocketConfig: ArcusSocketConfig {
  public var uri: URL
  public var headers: [String: String]
  public var retryAttempts: Int
  public var retryDelay: Double
  public var maxFrameSize: Int

  public init(_ uri: URL, headers: [String: String], retryAttempts: Int, retryDelay: Double, maxFrameSize: Int) {
    self.uri = uri
    self.headers = headers
    self.retryAttempts = retryAttempts
    self.retryDelay = retryDelay
    self.maxFrameSize = maxFrameSize
  }

  public static func emptyConfig() -> SocketConfig {
    return SocketConfig(URL(fileURLWithPath: ""),
                        headers: ["empty": "empty"],
                        retryAttempts: 0,
                        retryDelay: 0,
                        maxFrameSize: 0)
  }
}
