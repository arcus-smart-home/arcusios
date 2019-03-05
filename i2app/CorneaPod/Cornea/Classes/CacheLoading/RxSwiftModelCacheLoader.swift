//
//  RxSwiftModelCacheLoader.swift
//  i2app
//
//  Created by Arcus Team on 12/15/17.
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

public protocol RxSwiftModelCacheLoader {
  var statusObservable: BehaviorSubject<CacheLoadingStatus> { get }
  
  func getStatus() -> Observable<CacheLoadingStatus>
  func loadCache(_ place: PlaceModel, account: AccountModel) -> Observable<CacheLoadingStatus>
}

extension RxSwiftModelCacheLoader {
  public func getStatus() -> Observable<CacheLoadingStatus> {
    return statusObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
  }
}
