//
//  ArcusHttpRequest.swift
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

/**
 `HttpMethod` enum specifies the types of HTTP requests that can be made with `ArcusHttpRequest`.
 */
public enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
}

/**
 `ArcusHttpRequest` defines the expected behavior of a class needing to make an HTTP request with `ArcusClient`.
 */
public protocol ArcusHttpRequest {
  var url: URL { get set }
  var method: HttpMethod { get set }
  var json: String { get set }
  var formParams: [String : String] { get set }
  var headers: [String : AnyObject] { get set }
  var cookies: [String : String] { get set }

  /**
   Create `URLRequest` from `ArcusHttpeRequest` properties.

   - Returns: `URLRquest` created from `ArcusHttpRequest` properties.
   */
  func request() -> URLRequest
}
