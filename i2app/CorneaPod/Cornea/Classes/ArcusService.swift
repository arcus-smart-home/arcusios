//
//  ArcusService.swift
//  i2app
//
//  Created by Arcus Team on 8/7/17.
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

/**
`ArcusService` protocol
 */
public protocol ArcusService {
  // MARK: Extended Functions
  func sendMessage(_ message: ArcusClientMessage)
}

/**
 `ArcusService` extension
 */
extension ArcusService {
  func sendMessage(_ message: ArcusClientMessage) {
    guard let session = RxCornea.shared.session else { return }
    session.send(message)
  }
}

public protocol RxArcusService {
  var disposeBag: DisposeBag { get }

  func sendRequest<T: ArcusClientRequest>(_ request: T) throws -> Observable<ArcusSessionEvent>
}

extension RxArcusService {

  public func sendRequest<T: ArcusClientRequest>(_ request: T) throws -> Observable<ArcusSessionEvent> {
    guard let session = RxCornea.shared.session as? RxArcusSession,
      let message = request as? ArcusClientMessage else {
        throw RxArcusServiceError(type: .invalidConfig)
    }

    let observable = session.getEvents().filter { event -> Bool in
      return event.correlationId == message.correlationId
    }

    session.send(message)

    return observable.asObservable()
  }
}

public struct RxArcusServiceError: Error {
  enum ErrorType {
    case invalidConfig
  }

  let type: ErrorType
}
