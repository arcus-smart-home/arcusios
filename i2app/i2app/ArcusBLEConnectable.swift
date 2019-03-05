//
//  ArcusBLEConnectable.swift
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
import RxSwift
import RxSwiftExt

/**
 The `ArcusBLEConnectable` protocol allows the conforming class to expose the ability to connect to a
 BLE Peripheral.
 */
protocol ArcusBLEConnectable: ArcusBLEUtility {
  // Will be updated with results from `connect()`, and can be bound to/observed at the UI level.
  var connectedDevice: Variable<ArcusBLEViewModel?> { get set }
  var connectedDisposable: Disposable? { get set }

  /**
   Connect to the peripheral.  Connecting, failure to connect, and disconnection events will update the
   `connectedDevice` property.

   - Parameters:
   - bleDevice: `ArcusBLEViewModel` used to connect to a discovered `CBPeriperal`.

   - Returns: `Observable` emitting the connected device or nil if not connected.
   */
  func connect(_ bleDevice: ArcusBLEViewModel) -> Observable<ArcusBLEViewModel?>

  /**
   Disconnect the currently connected device, and set connectedDevice to nil.
   */
  func disconnect()
}

extension ArcusBLEConnectable {
  @discardableResult
  func connect(_ bleDevice: ArcusBLEViewModel) -> Observable<ArcusBLEViewModel?> {
    connectedDisposable?.dispose()

    let connectObservable = connectDevice(bleDevice)

    connectedDisposable = connectObservable
      .catchErrorJustReturn(nil)
      .bind(to: connectedDevice)
    connectedDisposable?.disposed(by: disposeBag)

    return connectObservable
      .map { (connectedDevice) -> ArcusBLEViewModel? in
        guard connectedDevice != nil else {
          throw BLEPairingError(errorType: .disconnected)
        }
        return connectedDevice
    }
  }

  func disconnect() {
    if let peripheral = connectedDevice.value?.peripheral {
      centralManager.cancelPeripheralConnection(peripheral)
    }
    connectedDevice.value = nil
  }

  /**
   Attempt to connect to `bleDevice.peripheral`, and observe connection status until the
   timeout expires.

   - Parameters:
   - bleDevice: `ArcusBLEViewModel` used to connect to a discovered `CBPeriperal`.

   - Returns: Observable returning the `ArcusBLEViewMode` or `BLEPairingError`.
   */
  private func connectDevice(_ bleDevice: ArcusBLEViewModel, timeout: TimeInterval = 10.0) -> Observable<ArcusBLEViewModel?> {

    // Observe didConnect events to `connectedDevice`.
    let didConnect: Observable<ArcusBLEViewModel?> = centralManager.rx.didConnect
      .filterMap { (_, peripheral) in
        return peripheral.name == bleDevice.name ? .map(bleDevice) : .ignore
    }

    // Observe didFailToConnect events to `connectedDevice`.
    let didFail: Observable<ArcusBLEViewModel?> = centralManager.rx.didFailToConnect
      .filterMap { (_, peripheral, _) in
        return peripheral.name == bleDevice.name ? .map(nil) : .ignore
      }

    // Observe didDisconnect events to `connectedDevice`.
    let didDisconnect: Observable<ArcusBLEViewModel?> = centralManager.rx.didDisconnect
      .filterMap { (_, peripheral, _) in
        return peripheral.name == bleDevice.name ? .map(nil) : .ignore
      }

    // Observe didTimeout and map to .disconnected error..
    let didTimeout: Observable<ArcusBLEViewModel?> = Observable<Int>
      .interval(timeout, scheduler: MainScheduler.asyncInstance)
      .filter { [unowned self] _ in
        return self.connectedDevice.value == nil
      }
      .map { _ -> ArcusBLEViewModel? in
        return nil
    }

    // Connect the peripheral
    centralManager.connect(bleDevice.peripheral, options: nil)

    return Observable<ArcusBLEViewModel?>.merge([didConnect, didFail, didDisconnect, didTimeout])
  }
}
