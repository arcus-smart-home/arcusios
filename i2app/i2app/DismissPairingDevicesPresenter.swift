//
//  DismissPairingDevicesPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/13/18.
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
import RxSwiftExt
import Cornea

protocol DismissPairingDevicesPresenter: ArcusPairingSubsystemCapability {

  /**
   Dismiss all Pairing Devices and return on completion
   - parameter subsystem: the pairing subsystem, default value is,
                          SubsystemCache.sharedInstance.pairingSubsystem()
   - parameter completion: optional closure to return that the networking call has completed

   - warning: completion closure swallows any errors, rewrite if you need error handling
   */
  func dismissPairingDevices(completion: @escaping ((_ zwaveRebuildNeeded: Bool) -> Void)) 

}

extension DismissPairingDevicesPresenter {

  func dismissPairingDevices(completion: @escaping ((_ zwaveRebuildNeeded: Bool) -> Void)) {

    // dismissPairingDevices should be called when the view is first created
    let pairingSubsystemSingle = Single<SubsystemModel>.create { single in
      if let subsystem = SubsystemCache.sharedInstance.pairingSubsystem() {
        single(.success(subsystem))
      } else {
        single(.error(ClientError(errorType: .unknown)))
      }
      return Disposables.create()
    }
    pairingSubsystemSingle
      .asObservable()
      .retry(.delayed(maxCount: 100, time: 0.1), shouldRetry: { _ in
        return true
      })
      .flatMap({ [unowned self] (subsystem) in
        return try! self.requestPairingSubsystemDismissAll(subsystem)
      })
      .subscribe(onNext: { event in
        if let response = event as? PairingSubsystemDismissAllResponse {
          KitDeviceDismissHelper.dismissKittedDevicesIfNeeded()
          completion(response.zwRebuildRequested())
        } else {
          completion(false)
        }
      })
      .addDisposableTo(disposeBag)
  }

}
