//
//  RXArcusClient.swift
//  i2app
//
//  Created by Arcus Team on 6/8/17.
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
import CocoaLumberjack

public class RxArcusClient: ArcusClient, RxSwiftClient, ArcusClientMessageQueue, UrlBuilder {
  public var clientUrl: URL?
  public var clientHeaders: [String: AnyObject] = [:]
  public var clientCookies: [String: String] = [:]
  public var socket: ArcusSocket {
    didSet {
      socket.delegate = self
    }
  }
  public var pendingMessages: [String: ArcusClientMessage] = [String: ArcusClientMessage]()
  public var pendingQueue: DispatchQueue = DispatchQueue(label: "",
                                                  qos: .utility,
                                                  attributes: .concurrent)

  public var stateObservable: BehaviorSubject<ArcusSocketState> =
    BehaviorSubject<ArcusSocketState>(value: .uninitialized)
  public var messageObservable: PublishSubject<ArcusClientMessage> = PublishSubject<ArcusClientMessage>()

  public var disposeBag: DisposeBag = DisposeBag()

  public required init(_ socket: ArcusSocket) {
    self.socket = socket
    self.socket.delegate = self
  }

  deinit {
    stateObservable.onCompleted()
    messageObservable.onCompleted()
  }

  /**
   Send http request

   - Parameters:
   - request: The HttpRequest to be sent.
   - completionHandler:  Closure to handle the processing of the received response or error.
   */
  public func sendHttp(_ request: HttpRequest,
                _ completionHandler: @escaping HTTPCompletionHandler) {
    _ = executeAsyncHttpRequest(request).subscribe(
      onNext: { response in
        completionHandler(response, nil)
    },
      onError: { error in
        completionHandler(nil, error)
    }).addDisposableTo(disposeBag)
  }

  /**
   Send http request

   - Parameters:
   - message: The `ArcusClientMeessage` to be sent as `HttpRequest`.
   */
  public func sendHttp(_ message: ArcusClientMessage) {
    guard let request = requestForMessage(message, headers: clientHeaders, cookies: clientCookies) else {
      return
    }

    // Create HTTPRequest from message.
    _ = executeAsyncHttpRequest(request).subscribe(
      onNext: { [weak self] response in
        if let type: String = response.type {
          let responseMessage: ClientMessage = ClientMessage(headers: response.headers,
                                                             payload: response.payload,
                                                             type: type)
          if responseMessage.correlationId == "" {
            responseMessage.correlationId = message.correlationId
          }

          var resultMessage: ArcusClientMessage = responseMessage
          if let requestMessage = message as? ArcusClientRequest {
            let resultResponse = ClientResponse(headers: response.headers,
                                                payload: response.payload,
                                                type: type)
            if resultResponse.correlationId == "" {
              resultResponse.correlationId = responseMessage.correlationId
            }
            resultResponse.request = requestMessage
            resultMessage = resultResponse
          }
          self?.messageObservable.onNext(resultMessage)
        }
    })
      .addDisposableTo(disposeBag)
  }

  /**
   Private convenience method used to create `HttpRequest` for `ArcusClientMessage`.

   - Parameters:
   - message: `ArcusClientMessage` to convert to `HttpRequest`.
   - headers: `[String: AnyObject]` of headers to be added to `HttpRequest`.
   - cookies: `[String: String]` of cookies to be added to `HttpRequest`.

   - Returns: Optional `HttpRequest` that can be sent by the client.
   */
  private func requestForMessage(_ message: ArcusClientMessage,
                                 headers: [String: AnyObject],
                                 cookies: [String: String]) -> HttpRequest? {
    guard message.isRequest == true else { return nil }

    // Create URL path from message command.
    let path: String = "/" + message.command.replacingOccurrences(of: ":", with: "/")

    guard let clientUrl = clientUrl,
      let url: URL = url(clientUrl,
                         scheme: Constants.Platform.httpScheme,
                         path: path) else {
                          return nil
    }

    let json = message.message()

    return HttpRequest(url: url,
                       method: .post,
                       json: json,
                       formParams: [:],
                       headers: headers,
                       cookies: cookies)
  }
}

extension RxArcusClient: ArcusSocketDelegate {
  public func socket(_ socket: ArcusSocket, connectionStateChanged state: ArcusSocketState) {
    stateObservable.onNext(state)
  }

  public func socket(_ socket: ArcusSocket, didReceiveMessage message: ArcusSocketMessage) {
    let clientMessage: ClientMessage = ClientMessage(message.message())

    if let pendingMessage: ArcusClientMessage = self.getPending(clientMessage.correlationId) {
      self.removePending(clientMessage.correlationId)

      if let request = pendingMessage as? ArcusClientRequest {
        let response = ClientResponse(message.message())
        response.request = request
        self.messageObservable.onNext(response)
        return
      }
    }
    self.messageObservable.onNext(clientMessage)
  }
}
