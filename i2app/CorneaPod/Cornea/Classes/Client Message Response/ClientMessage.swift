//
//  ClientMessage.swift
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
 `ClientMessage` is class that is used by `ArcusClient` to send 'ArcusClientMessage' socket based 
 messages to the platform.  Also conforms to `CustomStringConvertible`.
 */
public class ClientMessage: ArcusClientMessage, CustomDebugStringConvertible {
  public var type: String = ""
  public var source: String = ""
  public var destination: String = ""
  public var correlationId: String = UUID().uuidString.replacingOccurrences(of: "-", with: "")
  public var isRequest: Bool = false
  public var command: String = ""
  public var attributes: [String: AnyObject] = [String: AnyObject]()

  /**
   Base init.
   */
  public init() {}

  /**
   Init with text received from platform.
   */
  public init(_ text: String) {
    // Get Data
    guard let data: Data = text.data(using: .utf8) else { return }

    // Get JSON
    if let json = try? JSONSerialization.jsonObject(with: data,
                                                    options: .allowFragments) as? [String: AnyObject] {
      if json != nil {
        processJson(json!)
      }
    }
  }

  /**
   Init with text received from platform.
   */
  public init(jsonDict: [String: AnyObject]) {
    processJson(jsonDict)
  }

  public init(headers: [String: AnyObject], payload: [String: AnyObject], type: String) {
    process(headers, payload: payload, type: type)
  }

  func processJson(_ jsonDict: [String: AnyObject]) {
    self.correlationId = ""

    if let type = jsonDict["type"] as? String {
      self.type = type
    }

    if let headers = jsonDict["headers"] as? [String: AnyObject] {
      if let source = headers["source"] as? String {
        self.source = source
      }

      if let correlationId = headers["correlationId"] as? String {
        self.correlationId = correlationId
      }
    }

    if let payload = jsonDict["payload"] as? [String: AnyObject] {
      if let attributes = payload["attributes"] as? [String: AnyObject] {
        self.attributes = attributes
      }
    } 

    if let destination = jsonDict["destination"] as? String {
      self.destination = destination
    }

    if let isRequest = jsonDict["isRequest"] as? Bool {
      self.isRequest = isRequest
    }
  }

  func process(_ headers: [String: AnyObject], payload: [String: AnyObject], type: String) {
    self.correlationId = ""

    if let source = headers["source"] as? String {
      self.source = source
    }

    if let correlation = headers["correlationId"] as? String {
      self.correlationId = correlation
    }

    if let destination = headers["destination"] as? String {
      self.destination = destination
    }

    if let attributes = payload["attributes"] as? [String: AnyObject] {
      self.attributes = attributes
    }

    self.type = type
  }

  // MARK: ArcusSocketMessage Implementation

  /**
   Create message to send to socket,

   - Returns: `String` message to send to the socket.
   */
  public func message() -> String {
    guard let headers: [String: AnyObject] = messageHeaders(),
      let payload: [String: AnyObject] = messagePayload() else { return "" }

    if let message: String = messageJSON(command, headers: headers, payload: payload) {
      return message
    }
    return ""
  }

  // MARK: Private Methods

  /**
   Private fucntion used to create message JSON including type, headers, and payload key/values.

   - Parameters:
   - headers: Dictionary of headers to add to message JSON.
   - payload: Dictionary of payload to add to message JSON.

   - Returns: Optional `String` of the message JSON.
   */
  fileprivate func messageJSON(_ type: String,
                               headers: [String: AnyObject],
                               payload: [String: AnyObject]) -> String? {
    let jsonDict: [String: AnyObject] = ["type": type as AnyObject,
                                         "headers": headers as AnyObject,
                                         "payload": payload as AnyObject]

    return convertToJsonString(jsonDict)
  }

  /**
   Private function used to convert a dictionary to a JSON string.

   - Parameters:
   - jsonDict: Dictionary of key/values to convert to JSON.

   - Returns: Optional `String` of the created JSON.
   */
  fileprivate func convertToJsonString(_ jsonDict: [String: AnyObject]) -> String? {
    if let jsonData: Data = try? JSONSerialization.data(withJSONObject: jsonDict) {
      return String(data: jsonData, encoding: .utf8)
    }
    return nil
  }

  /**
   Private function used to create message headers from `ArcusClientMessage` properties.

   - Returns: Optional dictionary of message headers.
   */
  fileprivate func messageHeaders() -> [String: AnyObject]? {
      guard correlationId.count > 0 else {
        return nil
    }

    // destination is not set when sending a message.  We use source instead.
    // (destination is used primarily in responses.)
    // TODO: Consolidate destination/source
    // isRequest is always sent as true based on ObjC ArcusClient.
    let headers: [String: AnyObject] = ["destination": source as AnyObject,
                                        "correlationId": correlationId as AnyObject,
                                        "isRequest": isRequest as AnyObject]

    return headers
  }

  /**
   Private function used to create message payload from `ArcusClientMessage` properties.

   - Returns: Optional dictionary of message payload.
   */
  fileprivate func messagePayload() -> [String: AnyObject]? {
    var payload: [String: AnyObject] = ["messageType": command as AnyObject]
    if attributes.keys.count > 0 {
      payload["attributes"] = attributes as AnyObject
    }

    return payload
  }

  // MARK: CustomDebugStringConvertible Confromance
  public var debugDescription: String {
    return "ClientMessage: \r\n"
      + "type: \(type), \r\n"
      + "source: \(source), \r\n"
      + "destination: \(destination), \r\n"
      + "correlationId: \(correlationId), \r\n"
      + "isRequest: \(isRequest), \r\n"
      + "command: \(command), \r\n"
      + "attributes: \(attributes.debugDescription)"
  }
}
