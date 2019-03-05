//
//  ArcusBLEPairable.swift
//  i2app
//
//  Created by Arcus Team on 7/25/18.
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

import Cornea
import RxSwift

protocol ArcusBLEPairable: ArcusBridgeService, ArcusPairingSubsystemCapability {
  var ipcdDeviceType: String! { get set }
  
  func pairBLEDevice(_ identifier: String) -> Single<Void>
}

extension ArcusBLEPairable {
  func pairBLEDevice(_ identifier: String) -> Single<Void> {
    return Observable<Void>.create { [unowned self] observer in
      // Attempt to Register the Device with the Platform.
      let dev: [String: String] = ["IPCD:sn": identifier, "IPCD:v1devicetype": self.ipcdDeviceType]

      // Ignoring Force Try Warning.  Error should never be thrown, and `throws` will soon be removed.
      // swiftlint:disable:next force_try
      let disposable = try! self.requestBridgeServiceRegisterDevice(dev)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .map{ (event) -> Void in
          if let errorEvent = event as? ArcusErrorEvent {
            throw errorEvent.error
          }
          return ()
        }
        .subscribe(onNext: { _ in
          observer.onNext()
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        })
      disposable.disposed(by: self.disposeBag)

      return Disposables.create {
        disposable.dispose()
      }
    }
    .retry(.delayed(maxCount: 6, time: 5.0))
    .asSingle()
  }
}
