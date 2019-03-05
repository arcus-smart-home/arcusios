//
//  HttpResponse.swift
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

/**
 `HttpResponse` class conforms to `ArcusHttpResponse` and is used by `ArcusClient` to process HTTP responses.
 */
public class HttpResponse: ArcusHttpResponse {
  public var response: HTTPURLResponse?
  public var type: String?
  public var headers: [String: AnyObject] = [:]
  public var payload: [String: AnyObject] = [:]
  public var cookies: [HTTPCookie]?
  public var data: Data?

  public required init() {}

  public convenience init(response: HTTPURLResponse, data: Data) {
    self.init()

    self.response = response
    self.data = data
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
      if let jsonDict = json as? [String: AnyObject] {
        if let headers = jsonDict["headers"] as? [String: AnyObject] {
          self.headers = headers
        }
        if let payload = jsonDict["payload"] as? [String: AnyObject] {
          self.payload = payload
        }
        if let type = jsonDict["type"] as? String {
          self.type = type
        }
      }
    } catch {}

    if let headerFields = response.allHeaderFields as? [String : String],
      let url = response.url {
      let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
      self.cookies = cookies

      HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
    }
  }

  // MARK: `ArcusHttpResponse` Functions

  /**
   Get status code of the response.

   - Returns: Optional `Int` representing the status code of the response.
   */
  public func statusCode() -> Int? {
    return response?.statusCode
  }

  /**
   Get cookie value from response.

   - Parameters:
   - cookieName: `String` name of the cookie to retrieve.

   - Returns: Optional `String` representing the cookie value.
   */
  public func getValue(_ cookieName: String) -> String? {
    return cookies?.filter({ $0.name == cookieName }).first?.value
  }
}

extension HttpResponse: CustomDebugStringConvertible {
  public var debugDescription: String {
    var responseString: String = "reponse: nil, \r\n"
    if response != nil {
      responseString = "reponse: \(response!), \r\n"
    }

    var cookiesString: String = "cookies: nil, \r\n"
    if cookies != nil {
      cookiesString = "cookies: \(cookies!), \r\n"
    }

    var dataString: String = "data: nil, \r\n"
    if data != nil {
      dataString = "data: \(data!), \r\n"
    }

    return "HttpResponse: \r\n"
      + responseString
      + "payload: \(payload), \r\n"
      + cookiesString
      + dataString
  }
}
