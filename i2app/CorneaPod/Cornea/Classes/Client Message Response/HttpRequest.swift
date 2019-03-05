//
//  HttpRequest.swift
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

/*
 `HttpRequest` class conforms to `ArcusHttpRequest` and is used by classes conforming to `ArcusClient` to send
 HTTP requests.
 **/
public class HttpRequest: ArcusHttpRequest {
  public var url: URL
  public var method: HttpMethod
  public var json: String
  public var formParams: [String : String]
  public var headers: [String : AnyObject]
  public var cookies: [String : String]

  public init(url: URL,
       method: HttpMethod,
       json: String,
       formParams: [String : String],
       headers: [String : AnyObject],
       cookies: [String : String]) {
    self.url = url
    self.method = method
    self.json = json
    self.formParams = formParams
    self.headers = headers
    self.cookies = cookies
  }

  // `ArcusHttpRequest` Functions

  /**
   Create `URLRequest` from `ArcusHttpeRequest` properties.

   - Returns: `URLRquest` created from `ArcusHttpRequest` properties.
   */
  public func request() -> URLRequest {
    // TODO: Add Timeout as param
    var request = URLRequest(url: url,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = method.rawValue

    addHeaders(&request, headers: headers)
    addCookies(&request, cookies: cookies)

    if method == HttpMethod.post {
      if !json.isEmpty {
        jsonPayload(&request, json: json)
      } else {
        formPayload(&request, formParams: formParams)
      }
    }

    return request as URLRequest
  }

  // MARK: Private Functions

  /**
   Set form payload on `URLRequest`

   - Parameters:
   - request: `inout URLRequest` to be configured with the form params.
   - formParams: `[String: AnyObject]` dictionary of params to add to the request.
   */
  private func formPayload(_ request: inout URLRequest, formParams: [String : String]) {
    if formParams.count > 0 {
      // Build String
      var message: String = ""
      for (key, value) in formParams {
        if message.lengthOfBytes(using: String.Encoding.utf8) > 0 {
          message += "&"
        }

        var encodingSet: CharacterSet = CharacterSet.alphanumerics
        encodingSet.insert(charactersIn: ".")
        message += "\(key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)="
          + "\(value.addingPercentEncoding(withAllowedCharacters: encodingSet)!)"
      }
      setContent(&request, content: message)
    }
  }

  /**
   Set json payload on `URLRequest`

   - Parameters:
   - request: `inout URLRequest` to add the json to.
   - json: `String` of json to add to the request.
   */
  private func jsonPayload(_ request: inout URLRequest, json: String) {
    //request.setValue("application/json", forHTTPHeaderField:"Content-Type")
    setContent(&request, content: json)
  }

  /**
   Set content payload to `URLRequest`

   - Parameters:
   - request: `inout URLRequest` to be configured with the content.
   - content: `String` of content to add to the request.
   */
  private func setContent(_ request: inout URLRequest, content: String) {
    let length = String(content.lengthOfBytes(using: String.Encoding.utf8))
    request.setValue(length, forHTTPHeaderField: "Content-Length")

    request.httpBody = content.data(using: String.Encoding.utf8)
  }

  /**
   Add headers to `URLRequest`

   - Parameters:
   - request: `inout URLRequest` to be configured with headers.
   - headers: `[String: AnyObject]` dictionary of headers to add to the request.
   */
  private func addHeaders(_ request: inout URLRequest, headers: [String : AnyObject]) {
    for (key, value) in headers {
      request.addValue(String(describing: value), forHTTPHeaderField: key)
    }
  }

  /**
   Add cookies to `URLRequest`

   - Parameters:
   - request: `inout URLRequest` to be configured with headers.
   - cookies: `[String: String]` dictionary of cookies to add to the request.
   */
  private func addCookies(_ request: inout URLRequest, cookies: [String : String]) {
    var payload: String = ""
    for (key, value) in cookies {
      payload += "\(key)=\(value);"
    }

    if payload.characters.count > 0 {
      request.setValue(payload, forHTTPHeaderField: "Cookie")
    }
  }
}

extension HttpRequest: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "HttpRequest: \r\n"
      + "url: \(url), \r\n"
      + "method: \(method), \r\n"
      + "json: \(json), \r\n"
      + "formParams: \(formParams), \r\n"
      + "headers: \(headers), \r\n"
      + "cookies: \(cookies), \r\n"
  }
}
