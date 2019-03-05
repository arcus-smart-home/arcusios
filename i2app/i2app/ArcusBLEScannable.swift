//
//  ArcusBLEScannable.swift
//  i2app
//
//  Created by Arcus Team on 7/10/18.
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

import CoreBluetooth
import Cornea
import RxSwift

extension Constants {
  static let kBLEAdvertisedName: String = "kCBAdvDataLocalName"
}

/**
 The `ArcusBLEScannable` protocol allows the conforming class to expose the ability to scan for
 BLE Peripherals.
 */
protocol ArcusBLEScannable: ArcusBLEUtility {
  var searchFilter: String! { get set }

  // Will be updated with results from `scanForBLEDevices()`, and can be bound to/observed at the UI level.
  var discoveredDevices: Variable<[ArcusBLEViewModel]> { get set }
  var discoveredDevicesDisposable: Disposable? { get set }

  var isScanning: Variable<Bool> { get set }

  /**
   Method will scan for `CBPeripherals`, and when found will filter based upon the `searchFilter`, and
   will convert the returned peripheral to `BLEViewModel`, and will set `discoveredDevices` with the result.
   */
  func scanForBLEDevices() -> Observable<[ArcusBLEViewModel]>

  func stopScan()
}

extension ArcusBLEScannable {
  @discardableResult
  func scanForBLEDevices() -> Observable<[ArcusBLEViewModel]> {
    performBLEScan(searchFilter)

    return discoveredDevices.asObservable()
  }

  func performBLEScan(_ filter: String) {
    // Make sure that Bluetooth is still available.
    guard centralManager.state == CBManagerState.poweredOn else { return }

    // Dispose of previous subscriptions.
    discoveredDevicesDisposable?.dispose()

    // Set isScanning to true
    isScanning.value = true

    // Scan for peripherals
    centralManager.scanForPeripherals(withServices: nil, options: nil)

    // Observe peripheral discovery
    discoveredDevicesDisposable = centralManager.rx.didDiscover
      .filterMap { discovery in
        // Get advertised name, and make sure it contains the supplied filter.
        guard let name = discovery.advertisementData[Constants.kBLEAdvertisedName] as? String,
          name.contains(filter) else {
            return .ignore
        }
        // Create view model from peripheral.
        return .map(BLEViewModel(name, peripheral: discovery.peripheral))
      }
      .filter { [unowned self] model in
        // Filter duplicates.
        return !self.discoveredDevices.value.contains(where: { discovered in
          return discovered.name == model.name
        })
      }
      .subscribe(onNext: { [unowned self] model in
        self.discoveredDevices.value.append(model)
      })
    discoveredDevicesDisposable?.disposed(by: disposeBag)
  }

  func stopScan() {
    isScanning.value = false
    centralManager.stopScan()
  }
}
