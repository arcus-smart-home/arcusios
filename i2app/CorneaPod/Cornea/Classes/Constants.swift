//
//  Constants.swift
//  i2app
//
//  Created by Arcus Team on 8/4/17.
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

// TODO: Relocate to Common
@objc public class Constants: NSObject {}

extension Constants {
  public struct Platform {

    public static let httpScheme: String = "https"
    public static let wsScheme: String = "wss"

    public static let host: String = ""
    public static let devHost: String = ""

    public static let port: Int = 0

    public static let retryAttempts: Int = 0
    public static let retryDelay: Double = 5.0

    public static let maxFrameSize: Int = 1024 * 1024

    public static let clientAgent: String = "iOS"
    public static let clientVersion: String = getVersion()

    public static func getVersion() -> String {
      guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        return "0.0"
      }
      return version
    }
  }
}

// TODO: Relocate to Common

/**
 `UrlBuilder` is a mix-in that allows a conforming class to create a based on Platform Constants.
 */
public protocol UrlBuilder {
  func url(_ useWebSockets: Bool,
           instanceType: ArcusPlatformInstance,
           host: String?,
           port: Int,
           path: String?) -> URL?
  func url(_ baseUrl: URL, scheme: String?, path: String?) -> URL?
}

extension UrlBuilder {

  /**
   Create url from Platform Constants.

   - Parameters:
   - useWebSockets: `Bool` indicating if URL should be prefixed with `https` or `wss`.
   - instanceType: `ArcusPlatformInstance` enum indicating which host to create url for.
   - host: Optional `String` that can only be used to specify the host when `instanceType == .none`
   - path: `String` representing the path to be appended to the url.

   - Returns: Optional `URL` based on Platform Constants.
   */
  public func url(_ useWebSockets: Bool,
           instanceType: ArcusPlatformInstance,
           host: String? = nil,
           port: Int = Constants.Platform.port,
           path: String? = nil) -> URL? {
    var platformComponents = URLComponents()
    if useWebSockets {
      platformComponents.scheme = Constants.Platform.wsScheme
    } else {
      platformComponents.scheme = Constants.Platform.httpScheme
    }

    if let host: String = platformHostForType(instanceType) {
      platformComponents.host = host
    } else if instanceType == .other && host != nil {
      platformComponents.host = host
    } else {
      return nil
    }

    platformComponents.port = port

    if path != nil {
      platformComponents.path = path!
    }

    return platformComponents.url
  }

  public func url(_ baseUrl: URL, scheme: String? = nil, path: String? = nil) -> URL? {
    guard var components: URLComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else {
      return nil
    }

    if scheme != nil {
      components.scheme = scheme!
    }

    if path != nil {
      components.path = path!
    }

    return components.url
  }

  private func platformHostForType(_ type: ArcusPlatformInstance) -> String? {
    switch type {
    case .prod:
      return Constants.Platform.host
    case .devTest:
      return Constants.Platform.devHost
    default:
      return nil
    }
  }
}
