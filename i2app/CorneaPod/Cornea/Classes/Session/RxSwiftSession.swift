//
//  RxSwiftSession.swift
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
import CocoaLumberjack

// TODO: Add better docs!
/**
 `RxSwiftSession` protocol
 */
public protocol RxSwiftSession: class {
  var disposeBag: DisposeBag { get }
  var reachabilityHandler: RxReachabilityHandler? { get set }

  var stateObservable: BehaviorSubject<ArcusSessionStatus> { get set }
  var eventObservable: PublishSubject<ArcusSessionEvent> { get set }

  /**
   Configure the session to observe client state events from `RxSwiftClient`.

   - Parameters:
   - rxClient: instance of `RxSwiftClient` observe events from.
   */
  func observeClientState(_ rxClient: RxSwiftClient)

  /**
   Configure the session to observe client message events from `RxSwiftClient`.

   - Parameters:
   - rxClient: instance of `RxSwiftClient` observe events from.
   */
  func observeClientMessages(_ rxClient: RxSwiftClient)

  /**
   Configure the session to observe `ArcusSessionEvent`s to handle internal processing of those events.
   */
  func observeSessionEvents()

  /**
   Configure the session with a `RxReachabilityHandler` and start observing reachability events.

   - Parameters:
   - handler: instance of `RxReachabilityHandler` observe events from.
   */
  func startReachabilityHandler(_ handler: RxReachabilityHandler)

  // MARK: RxSwift Convenience Methods

  func suspendSession() -> Single<ArcusSessionStatus>
  func resumeSession() -> Single<ArcusSessionStatus>

  // MARK: EXTENDED

  func getState() -> Observable<ArcusSessionStatus>
  func getEvents() -> Observable<ArcusSessionEvent>
}

/**
 `RxSwiftSession` protocol extension
 */
extension RxSwiftSession {
  public func getState() -> Observable<ArcusSessionStatus> {
    return stateObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
  }

  public func getEvents() -> Observable<ArcusSessionEvent> {
    return eventObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
  }
}
