//
//  PairingMessageBoxPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/5/18.
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
import Cornea
import RxSwift

/// Required business logic for the advanced pairing banner or "Mustard View"
protocol PairingMessageBoxPresenter: class {

  /// disposeBag required for memory
  var disposeBag: DisposeBag { get }

  /// Should be called to start monitoring
  func startMonitoringPairing(cache: (ArcusModelCache & RxSwiftModelCache)?)

  /// state change callback to display
  /// - extended for View Controllers
  /// - parameter withText: text to display in the banner
  func shouldPresentAdvancedPairingBanner(withText text: String)

  /// state change callback to hide
  /// - extended for View Controllers
  /// - parameter animated: defaults to true
  func shouldHideAdvancedPairingBanner(_ animated: Bool)
}

extension PairingMessageBoxPresenter {

  /// static helper function to clean up the next function default param for cache
  private static func optionalModelCache() -> (ArcusModelCache & RxSwiftModelCache)? {
    if let cache = RxCornea.shared.modelCache as? (ArcusModelCache & RxSwiftModelCache) {
      return cache
    }
    return nil
  }

  func startMonitoringPairing(cache: (ArcusModelCache & RxSwiftModelCache)? = Self.optionalModelCache()) {

    // A Cache is optional but required for this function to do anything of use
    guard let cache = cache else { return }

    // Lets First get the count as it is now
    let originalDeviceCount = deviceCount()
    var previousDeviceCount = originalDeviceCount

    /// The Text of the Banner when displayed
    let bannerDisplay = PublishSubject<String>()

    /// a Subscription to a timer for Displaying the Banner based on the Count for a length of time
    var bannerTimerSubscription: Disposable?

    // Setup the Subscription changes to emit Changes of the count from the Model Cache
    cache.getEvents()
      .filter { (event: ArcusModelCacheEvent) in
        return event.address.contains("dev")
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe({ [weak self] _ in
        let newDeviceCount = self?.deviceCount() ?? 0
        
        // Only apply logic when device count has increased
        if newDeviceCount - previousDeviceCount > 0 {
          previousDeviceCount = newDeviceCount
          
          let difference = newDeviceCount - originalDeviceCount
          if difference == 1 {
            bannerDisplay.onNext("A device was added!")
          } else if difference > 1 {
            bannerDisplay.onNext("Multiple devices were added!")
          } else {
            self?.shouldHideAdvancedPairingBanner(false)
          }
        }
      })
      .disposed(by: disposeBag)

    // display the banner and start a timer to hide it if need be
    bannerDisplay.asObserver()
      .subscribe(onNext: { [weak disposeBag, weak self] text in
        guard let disposeBag = disposeBag,
          text.count > 0 else {
          return
        }
        self?.shouldPresentAdvancedPairingBanner(withText: text)
        bannerTimerSubscription?.dispose()
        let newTimer = Observable<Int>.timer(7, scheduler: MainScheduler.asyncInstance)
        let newSubscription = newTimer.subscribe(onNext: { _ in
          self?.shouldHideAdvancedPairingBanner(true)
        })
        newSubscription.disposed(by: disposeBag)
        bannerTimerSubscription = newSubscription
      })
      .disposed(by: disposeBag)
  }
  
  private func deviceCount() -> Int {
    let namespace = Constants.deviceNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [DeviceModel] else {
      return 0
    }
    
    return models.count
  }
}
