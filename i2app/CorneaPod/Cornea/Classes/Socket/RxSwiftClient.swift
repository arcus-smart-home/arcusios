//
//  RxSwiftClient.swift
//  i2app
//
//  Created by Arcus Team on 7/14/17.
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

public protocol RxSwiftClient {
  /**
   Observable used to monitor the connection state of the socket.
   */
  var stateObservable: BehaviorSubject<ArcusSocketState> { get set }

  /**
   Observable that will publish messages received from socket.
   */
  var messageObservable: PublishSubject<ArcusClientMessage> { get set }

  func getState() -> Observable<ArcusSocketState>
  func getMessages() -> Observable<ArcusClientMessage>

  /**
   Ansynchronously execute HTTP Request.

   - Parameters:
   - request: The HttpRequest to be sent.

   - Returns: Observable that will publish HttpResponse.
   */
  func executeAsyncHttpRequest(_ request: HttpRequest) -> Observable<HttpResponse>
}

extension RxSwiftClient {
  public func getState() -> Observable<ArcusSocketState> {
    return stateObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
  }

  public func getMessages() -> Observable<ArcusClientMessage> {
    return messageObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
  }

  /**
   Ansynchronously execute HTTP Request.

   - Parameters:
   - request: The HttpRequest to be sent.

   - Returns: Observable that will publish HttpResponse.
   */
  public func executeAsyncHttpRequest(_ request: HttpRequest) -> Observable<HttpResponse> {
    return URLSession.shared.rx.response(request: request.request())
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
      .map({ response, data in
      return HttpResponse(response: response, data: data)
    })
  }
}
