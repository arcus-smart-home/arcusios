//
//  ArcusPromiseConverter.swift
//  i2app
//
//  Created by Arcus Team on 7/13/17.
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
import PromiseKit
import RxSwift

/**
 `ArcusPromiseConverter` protocol can be conformed to in order to convert an RXSwift Observables to a 
  PromiseKit PMKPromise.
 */
public protocol ArcusPromiseConverter: class {
  var disposeBag: DisposeBag { get }

  // EXTENDED

  /**
   Create a `PMKPromise` from `Observable`.

   - Parameters:
   - observable: `Observable` with any type of specialization may be converted.

   - Returns: `PMKPromise` for the received `Observable`.
   */
  func promiseForObservable<T: Any>(_ observable: Observable<T>) -> PMKPromise
}

/**
 `ArcusPromiseConverter` extension.
 */
extension ArcusPromiseConverter {
  public func promiseForObservable<T: Any>(_ observable: Observable<T>) -> PMKPromise {
    // Create UUID and cache self to the update queue.
    let uuid: String = UUID.init().uuidString
    ArcusModelUpdateQueue.shared.add(self, identifier: uuid)
    
    var disposable: Disposable?
    return PMKPromise.new {
      [weak self] (fulfiller: PMKFulfiller!, rejector: PMKRejecter!) in
      disposable = observable.subscribe(
        onNext: { result in
          if let result = result as? SessionErrorEvent {
            let error: NSError = NSError(domain: "", code: 104, userInfo: result.attributes)
            rejector!(error)
          } else {
            fulfiller!(result)
          }
          
          // Remove self from update queue once callback is made.
          ArcusModelUpdateQueue.shared.remove(uuid)
          
          disposable?.dispose()
      },
        onError: { error in
          // Remove self from update queue once callback is made.
          ArcusModelUpdateQueue.shared.remove(uuid)
          
          rejector!(error)
      }
      )
      if let disposeBag = self?.disposeBag {
        disposable?.disposed(by: disposeBag)
      }
    }
  }
}

final public class ArcusModelUpdateQueue {
  public static let shared: ArcusModelUpdateQueue = ArcusModelUpdateQueue()
  
  public var updates: [String : AnyObject] = [:]
  public var accessQueue: DispatchQueue = DispatchQueue(label: "",
                                                        qos: .utility)
  
  public func add(_ item: AnyObject, identifier: String) {
    accessQueue.async { [unowned self] _ in
      self.updates[identifier] = item
    }
  }
  
  public func remove(_ identifier: String) {
    accessQueue.async { [unowned self] _ in
      self.updates[identifier] = nil
    }
  }
}
