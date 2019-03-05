//
//  ArcusHttpResponse.swift
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
 `ArcusHttpResponse` defines the expected behavior of a class needing to accept HTTP responses.
 */
public protocol ArcusHttpResponse {
  var response: HTTPURLResponse? { get set }
  var type: String? { get set }
  var headers: [String: AnyObject] { get set }
  var payload: [String: AnyObject] { get set }
  var cookies: [HTTPCookie]? { get set }
  var data: Data? { get set }

  /**
   Get status code of the response.

   - Returns: Optional `Int` representing the status code of the response.
   */
  func statusCode() -> Int?

  /**
   Get cookie value from response.

   - Parameters:
   - cookieName: `String` name of the cookie to retrieve.

   - Returns: Optional `String` representing the cookie value.
   */
  func getValue(_ cookieName: String) -> String?
}
