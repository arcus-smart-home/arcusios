//
//  ArcusHubBLEPairingPresenter.swift
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

protocol ArcusHubBLEPairingPresenter: ArcusPlaceCapability {

  /// current PlaceModel, Sane Default to RxCornea
  var currentPlace: PlaceModel? { get }

  func pairHub(hubId: String, place: PlaceModel) -> Single<Void>
}

struct PlaceRegisterHubOfflineError: Error {}

extension ArcusHubBLEPairingPresenter {

  /// Sane Default to RxCornea
  var currentPlace: PlaceModel? {
    return currentSettings?.currentPlace
  }

  /// Sane Default to RxCornea
  var currentSettings: (ArcusSettings & RxSwiftSettings)? {
    if let settings = RxCornea.shared.settings as? ArcusSettings & RxSwiftSettings {
      return settings
    }
    return nil
  }

  func pairHub(hubId: String, place: PlaceModel) -> Single<Void> {
    return Single<Void>.create { [unowned self] single in
      // Attempt to Register the Hub with the Platform.
      // Ignoring Force Try Warning.  Error should never be thrown, and `throws` will soon be removed.
      // swiftlint:disable:next force_try
      let disposable = try! self.requestPlaceRegisterHubV2(place, hubId: hubId.uppercased())
        .subscribe(
          onNext: { event in
            guard let res = event as? PlaceRegisterHubV2Response else {
              if let errorEvent = event as? SessionErrorEvent {
                single(.error(errorEvent.error))
              } else {
                single(.error(ClientError(errorType: .unknown)))
              }
              return
            }
            if let state = res.getState() {
              switch state {
              case .online, .downloading, .applying, .registered:
                single(.success())
              default: //mostly just .offline unless enum is updated
                single(.error(PlaceRegisterHubOfflineError()))
              }
            }
            else {
              single(.error(PlaceRegisterHubOfflineError()))
            }
        })
      return Disposables.create {
        disposable.dispose()
      }
      }
      .asObservable()
      // Retry for 10 min
      .retry(.delayed(maxCount: 300, time: 2.0), shouldRetry: { err in
        return !(err is PlaceRegisterHubV2Error)
      })
      .timeout(60 * 10, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .asSingle()
  }
}
