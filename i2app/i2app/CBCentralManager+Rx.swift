//
//  CBCentralManager+Rx.swift
//  i2app
//
//  Created by Arcus Team on 6/25/18.
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
import RxCocoa

extension CBCentralManager {
  /**
   Factory method.

   - Returns: `RxCBCentralManagerDelegateProxy` wrapper for `CBCenteralManagerDelegate`
   */
  public func rxDelegateProxy() -> RxCBCentralManagerDelegateProxy {
    return RxCBCentralManagerDelegateProxy(parentObject: self)
  }
}

extension Reactive where Base: CBCentralManager {

  // MARK: - Properties

  public var delegate: DelegateProxy {
    return RxCBCentralManagerDelegateProxy.proxyForObject(base)
  }

  public var state: Observable<CBManagerState> {
    let proxy = RxCBCentralManagerDelegateProxy.proxyForObject(base)
    return proxy.stateBehaviorSubject.asObservable()
  }

  // - seealso: `CBCentralManagerDelegate`
  public var willRestoreState: Observable<(central: CBCentralManager, dict: [String : Any])> {
    return Observable.deferred { [unowned source = self.base as CBCentralManager] () -> Observable<(central: CBCentralManager, dict: [String : Any])> in
      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:willRestoreState:)))
        .filterMap { params in
          guard let dict: [String: Any] = params[1] as? [String: Any] else {
            return .ignore
          }
          return .map(central: source, dict: dict)
        }
    }
  }

  // - seealso: `CBCentralManagerDelegate`
  public var didDiscover: Observable<(peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber)> {
    return Observable.deferred { [unowned source = self.base as CBCentralManager] () -> Observable<(peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)))
        .filterMap { params in
          guard let peripheral: CBPeripheral = params[1] as? CBPeripheral,
            let advertisementData: [String: Any] = params[2] as? [String: Any],
            let RSSI: NSNumber = params[3] as? NSNumber else {
              return .ignore
          }
          return .map(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI)
      }
    }
  }

  // - seealso: `CBCentralManagerDelegate`
  public var didConnect: Observable<(central: CBCentralManager, peripheral: CBPeripheral)> {
    return Observable.deferred({ [unowned source = self.base as CBCentralManager] () -> Observable<(central: CBCentralManager, peripheral: CBPeripheral)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didConnect:)))
        .filterMap { params in
          guard let peripheral = params[1] as? CBPeripheral else {
            return .ignore
          }
          return .map(central: source, peripheral: peripheral)
        }
    })
  }

  // - seealso: `CBCentralManagerDelegate`
  public var didFailToConnect: Observable<(central: CBCentralManager, peripheral: CBPeripheral, error: Error?)> {
    return Observable.deferred({ [unowned source = self.base as CBCentralManager] () -> Observable<(central: CBCentralManager, peripheral: CBPeripheral, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didFailToConnect:error:)))
        .filterMap { params in
          guard let peripheral = params[1] as? CBPeripheral else {
            return .ignore
          }
          return .map(central: source, peripheral: peripheral, error: params[2] as? Error)
        }
    })
  }

  // - seealso: `CBCentralManagerDelegate`
  public var didDisconnect: Observable<(central: CBCentralManager, peripheral: CBPeripheral, error: Error?)> {
    return Observable.deferred({ [unowned source = self.base as CBCentralManager] () -> Observable<(central: CBCentralManager, peripheral: CBPeripheral, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDisconnectPeripheral:error:)))
        .filterMap { params in
          guard let peripheral = params[1] as? CBPeripheral else {
            return .ignore
          }
          return .map(central: source, peripheral: peripheral, error: params[2] as? Error)
        }
    })
  }

  public func setDelegate(_ delegate: CBCentralManagerDelegate)
    -> Disposable {
      return RxCBCentralManagerDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
  }
}

extension Reactive where Base: CBCentralManager {
  func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]? = nil) -> Observable<(peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber)> {
    return Observable.deferred { [unowned source = self.base as CBCentralManager] () -> Observable<(peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber)> in

      guard source.isScanning else { return self.didDiscover }

      source.scanForPeripherals(withServices: serviceUUIDs, options: options)

      return source.rx.delegate
        .methodInvoked(#selector(CBCentralManagerDelegate.centralManager(_:didDiscover:advertisementData:rssi:)))
        .filterMap { params in
          guard let peripheral: CBPeripheral = params[1] as? CBPeripheral,
            let advertisementData: [String: Any] = params[2] as? [String: Any],
            let RSSI: NSNumber = params[3] as? NSNumber else {
              return .ignore
          }
          return .map(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI)
        }
    }
  }
}
