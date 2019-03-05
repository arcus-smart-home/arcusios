//
//  RxReachabilityHandler.swift
//  i2app
//
//  Created by Arcus Team on 9/19/17.
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
import RxReachability
import ReachabilitySwift

/**
`RxReachabilityHandler` protocol is a mix-in that can be implemeneted in order for a class to RxSwift based
 `Reachability` events.
 */
public protocol RxReachabilityHandler: class {
  var disposeBag: DisposeBag { get set }
  var reachability: Reachability? { get set }
  var reachableEventObservable: PublishSubject<Reachability.NetworkStatus> { get set }

  // MARK: Extended

  /**
   Start Reachability notifications and begin producing events.
   */
  func startReachabilityNotifier()

  /**
   Stop Reachability notifications and halt events.
   */
  func stopReachabilityNotifier()

  /**
   Get the observable for network status changes.

   - Returns: Instance of `Observable<Reachability.NetworkStatus>`
   */
  func getReachabilityEvents() -> Observable<Reachability.NetworkStatus>
}

/**
  `RxReachabilityHandler` protocol extension.
 */
extension RxReachabilityHandler {
  public func startReachabilityNotifier() {
    do {
      try reachability?.startNotifier()
      configureObservable()
    } catch {}
  }

  public func stopReachabilityNotifier() {
    reachability?.stopNotifier()
    reachableEventObservable.onCompleted()
  }

  public func getReachabilityEvents() -> Observable<Reachability.NetworkStatus> {
    return reachableEventObservable.asObservable()
  }

  fileprivate func configureObservable() {
    reachability?.rx.status
      .subscribe(
        onNext: { [weak self] status in
          self?.reachableEventObservable.onNext(status)
      })
      .addDisposableTo(disposeBag)
  }
}

public class ReachabilityHandler: RxReachabilityHandler {
  public var disposeBag: DisposeBag = DisposeBag()
  public var reachability: Reachability? = Reachability()
  public var reachableEventObservable: PublishSubject<Reachability.NetworkStatus> =
    PublishSubject<Reachability.NetworkStatus>()
}
