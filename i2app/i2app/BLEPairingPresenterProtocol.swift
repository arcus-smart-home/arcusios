//
//  BLEPairingPresenterProtocol.swift
//  i2app
//
//  Created by Arcus Team on 8/9/18.
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

protocol BLEPairingPresenterProtocol: ArcusPairingSubsystemCapability {
  var customStepDelegate: PairingStepsCustomStepDelegate { get }

  func finalizeCustomPairing(subsystem: SubsystemModel?) -> Single<Void>
}

extension BLEPairingPresenterProtocol {
  // swiftlint:disable:next line_length
  func finalizeCustomPairing(subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) -> Single<Void> {
    return Single<Void>.create { [unowned self] single in
      guard let subsystem = subsystem else {
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // swiftlint:disable:next force_try
      let disposable = try! self.requestPairingSubsystemStopSearching(subsystem)
        .map{ (event) -> Void in
          if let errorEvent = event as? ArcusErrorEvent {
            throw errorEvent.error
          }
          return ()
        }
        .subscribe(
          onNext: { _ in
            single(.success())
        }, onError: { error in
          single(.error(error))
        })

      return Disposables.create {
        disposable.dispose()
      }
    }
  }
}
