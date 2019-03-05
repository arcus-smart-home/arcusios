//
//  WSSPairingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/9/18.
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

protocol WSSPairingPresenter: WSSNetworkConfigurator, ArcusBridgeService, ArcusPairingSubsystemCapability {
  // The client required to communicate with the WifiSmartSwitch.
  var client: WSSConfigurator { get set }

  var pairingSubsystemProvider: ArcusModelProvider<SubsystemModel> { get }

  /**
   Method used to configure a Swann WiFi Smart Switch's Network Settings & will attempt to register the device
   with the platform.

   - Parameters:
   - ssid: `String` representing the WiFi network to join.
   - key: `String` representing the WiFi network's password required to join.

   - Returns: Obersvable `Single` Trait that will give onSuccess/onError indicating if pairing was successful.
   */
  func pairSwitch(ssid: String, key: String) -> Single<Void>
}

extension WSSPairingPresenter {
  func pairSwitch(ssid: String, key: String) -> Single<Void> {
    // Configure the Switch's WiFi Network.
    return client.provisionSwitch(config.getSSID(), key: config.getKey())
      .flatMap { [unowned self]  macAddress in
        // Resume the current Session.
        self.resumeSession(macAddress)
      }.flatMap{ [unowned self] macAddress in
        // Ensure we are in pairing mode still, the timeout could have occured while
        // the user was in the background
        return self.ensureInPairingMode(macAddress)
      }.flatMap { [unowned self]  macAddress in
        // Once the Switch is configured & Session has resumed.  Attempt to register with Platform.
        return self.registerSwitch(macAddress)
      }.flatMap { [unowned self]  _ in
        // Once the Switch is configured & Session has resumed.  Attempt to register with Platform.
        return self.stopPairing()
      }  
  }

  private func resumeSession(_ macAddress: String) -> Single<String> {
    let single = Single<String>.create { [macAddress] single in
      guard let session = RxCornea.shared.session as? RxArcusSession else {
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      let disposable = session.resumeSession().subscribe(
        onSuccess: { [single, macAddress] _ in
          single(.success(macAddress))
        },
        onError: { [single] error in
          single(.error(error))
      })

      return Disposables.create {
        disposable.dispose()
      }
    }

    return single
      .asObservable()
      .retry(.delayed(maxCount: 3, time: 5.0), shouldRetry: { _ in
        // Retry maximum of 3 times with a 5 second delay between attempts.
        // Session will already delay 15 seconds before producing error.
        // So this should total 60 seconds of retry attempts on resume.
        return true
      })
      .asSingle()
  }

  private func ensureInPairingMode(_ macAddress: String) -> Single<String> {
    let single = Single<String>.create { [unowned self] (single) in

      let disposable = self.pairingSubsystemProvider.modelObservable
        .unwrap()
        .take(1)
        .subscribe(onNext: { [unowned self] pairingSubsystem in
          let mode = self.getPairingSubsystemPairingMode(pairingSubsystem)
          guard mode == PairingSubsystemPairingMode.idle else {
            single(.success(macAddress))
            return
          }
          // swiftlint:disable:next force_try
          try! self.requestPairingSubsystemSearch(pairingSubsystem,
                                                  productAddress: "",
                                                  form: [:])
            .subscribe(onNext: { _ in
              single(.success(macAddress))
            }, onError: { (error) in
              single(.error(error))
            }).disposed(by: self.disposeBag)

          }, onError: { (error) in
            single(.error(error))
        })

      return Disposables.create {
        disposable.dispose()
      }
    }
    return single
  }

  private func registerSwitch(_ macAddress: String) -> Single<Void> {
    let single = Single<Void>.create { [unowned self] single in
      // Attempt to Register the Switch with the Platform.
      let dev = ["IPCD:sn": macAddress, "IPCD:v1devicetype": "other"]
      // Ignoring Force Try Warning.  Error should never be thrown, and `throws` will soon be removed.
      // swiftlint:disable:next force_try
      let disposable = try! self.requestBridgeServiceRegisterDevice(dev)
        .subscribe(
          onNext: { event in
            guard event is BridgeServiceRegisterDeviceResponse else {
              if let errorEvent = event as? SessionErrorEvent {
                single(.error(errorEvent.error))
              } else {
                single(.error(ClientError(errorType: .unknown)))
              }
              return
            }
            single(.success())
        })

      return Disposables.create {
        disposable.dispose()
      }
    }

    // Retry Request to Register for 2 minutes.
    return single
      .asObservable()
      .retry(.delayed(maxCount: 24, time: 5.0), shouldRetry: { error in
        if let error = error as? ClientError {
          return error.code == "request.destination.notfound"
        }
        return false
      })
      .asSingle()
  }

  private func stopPairing() -> Single<Void> {
    let single = Single<Void>.create { [unowned self] single in

      // Simple first check
      if let ps = try? self.pairingSubsystemProvider.modelObservable.value(),
        let pairingSubsystem = ps {
        let mode = self.getPairingSubsystemPairingMode(pairingSubsystem)
        if mode == PairingSubsystemPairingMode.idle {
          single(.success())
        }
      }

      // Complete on attribute change to IDLE
      let attributeChangeDisposable = self.pairingSubsystemProvider.attributeObservable
        .filter({ [unowned self] (event: (model: SubsystemModel, changes: [String: AnyObject])) -> Bool in
          let mode = self.getPairingSubsystemPairingMode(event.model)
          return mode == PairingSubsystemPairingMode.idle
        })
        .subscribe(
          onNext: { _ in
            single(.success())
        })

      // Call Stop Pairing and complete after a delay (to ensure we always will complete)
      let modelChangeDisposable = self.pairingSubsystemProvider.modelObservable
        .unwrap()
        .take(1)
        .subscribe(
          onNext: { [unowned self] subsystem in
            let mode = self.getPairingSubsystemPairingMode(subsystem)
            if mode == PairingSubsystemPairingMode.idle {
              single(.success())
            } else {
              // swiftlint:disable:next force_try
              _ = try! self.requestPairingSubsystemStopSearching(subsystem)
            }
        })

      return Disposables.create {
        attributeChangeDisposable.dispose()
        modelChangeDisposable.dispose()
      }
    }

    return single.asObservable()
      .timeout(60, scheduler: ConcurrentDispatchQueueScheduler(qos: .utility))
      .asSingle()
  }
}
