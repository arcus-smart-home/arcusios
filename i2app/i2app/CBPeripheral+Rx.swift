//
//  CBPeripheral+Rx.swift
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
import Cornea
import RxSwift
import RxSwiftExt
import RxCocoa

extension CBPeripheral {
  /**
   Factory method.
   
   - Returns: `RxCBPeripheralDelegateProxy` wrapper for `CBPeripheralDelegateProxy`
   */
  public func rxDelegateProxy() -> RxCBPeripheralDelegateProxy {
    return RxCBPeripheralDelegateProxy(parentObject: self)
  }
}

extension Reactive where Base: CBPeripheral {
  // MARK: - Properties
  
  public var delegate: DelegateProxy {
    return RxCBPeripheralDelegateProxy.proxyForObject(base)
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didUpdateName: Observable<CBPeripheral> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<CBPeripheral> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheralDidUpdateName(_:)))
        .filterMap { params in
          guard let peripheral = params[0] as? CBPeripheral else {
            return .ignore
            
          }
          return .map(peripheral)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didModifyServices: Observable<(peripheral: CBPeripheral, invalidatedServices: [CBService])> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, invalidatedServices: [CBService])> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didModifyServices:)))
        .filterMap { params in
          guard let peripheral = params[0] as? CBPeripheral,
            let invalidatedServices = params[1] as? [CBService] else {
              return .ignore
          }
          return .map(peripheral, invalidatedServices)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didReadRSSI: Observable<(peripheral: CBPeripheral, RSSI: NSNumber, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, RSSI: NSNumber, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didReadRSSI:error:)))
        .filterMap { params in
          guard let peripheral = params[0] as? CBPeripheral,
            let RSSI = params[1] as? NSNumber else {
              return .ignore
          }
          return .map(peripheral, RSSI, params[2] as? Error)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didDiscoverServices: Observable<(peripheral: CBPeripheral, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverServices:)))
        .filterMap { params in
          guard let peripheral = params[0] as? CBPeripheral else {
            return .ignore
            
          }
          return .map(peripheral, params[1] as? Error)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didDiscoverIncludedServices: Observable<(peripheral: CBPeripheral, service: CBService, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, service: CBService, error: Error?)> in
      return source.rx.delegate.methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverIncludedServicesFor:error:)))
        .filterMap { params in
          guard let service = params[1] as? CBService else {
            return .ignore
          }
          return .map(source, service, params[2] as? Error)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didDiscoverCharacteristics: Observable<(peripheral: CBPeripheral, service: CBService, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, service: CBService, error: Error?)> in
      return source.rx.delegate.methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverCharacteristicsFor:error:)))
        .filterMap { params in
          guard let service = params[1] as? CBService else {
            return .ignore
          }
          return .map(source, service, params[2] as? Error)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didUpdateValueForCharacteristic: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
    let proxy = RxCBPeripheralDelegateProxy.proxyForObject(base)
    return proxy.didUpdateValueForCharacteristicPublishSubject
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didUpdateValueForDescriptor: Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> {
    let proxy = RxCBPeripheralDelegateProxy.proxyForObject(base)
    return proxy.didUpdateValueForDescriptorPublishSubject
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didWriteValueForCharacteristic: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
    let proxy = RxCBPeripheralDelegateProxy.proxyForObject(base)
    return proxy.didWriteValueForCharacteristicPublishSubject
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didWriteValueForDescriptor: Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> {
    let proxy = RxCBPeripheralDelegateProxy.proxyForObject(base)
    return proxy.didWriteValueForDescriptorPublishSubject
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didUpdateNotificationState: Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didUpdateNotificationStateFor:error:)))
        .filterMap { params in
          guard let characteristic = params[1] as? CBCharacteristic else {
            return .ignore
          }
          return .map(source, characteristic, params[2] as? Error)
      }
    }
  }
  
  // - seealso: `CBPeripheralDelegate`
  public var didDiscoverDescriptors: Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> {
    return Observable.deferred { [unowned source = self.base as CBPeripheral] () -> Observable<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)> in
      return source.rx.delegate
        .methodInvoked(#selector(CBPeripheralDelegate.peripheral(_:didDiscoverDescriptorsFor:error:)))
        .filterMap { params in
          guard let descriptor = params[1] as? CBDescriptor else {
            return .ignore
          }
          return .map(source, descriptor, params[2] as? Error)
      }
    }
  }
}

extension Observable where Element: CBCharacteristic {
  public func valueToString() -> Observable<String> {
    return map { characteristic in
      guard let responseData = characteristic.value,
        let response = String(data: responseData, encoding: .utf8)?
          .replacingOccurrences(of: "\0", with: "", options: .literal, range: nil) else {
            return ""
      }
      return response
    }
  }
}

extension PrimitiveSequence where Element: CBCharacteristic {
  public func valueToString() -> Observable<String> {
    return asObservable()
      .map { characteristic in
        guard let responseData = characteristic.value,
          let response = String(data: responseData, encoding: .utf8)?
            .replacingOccurrences(of: "\0", with: "", options: .literal, range: nil) else {
            return ""
        }

        return response
    }
  }

  func valueToConfigStatus() -> Observable<BLEPairingConfigStatus> {
    return valueToString()
      .asObservable()
      .map { stringValue in
        guard let status = BLEPairingConfigStatus(rawValue: stringValue.uppercased()) else {
          throw ClientError()
        }
        return status
      }
  }

  public func valueToDictionary() -> Observable<[String: AnyObject]> {
    return asObservable()
      .map { characteristic in
        do {
          guard let responseData = characteristic.value,
            let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
              as? [String: AnyObject] else {
                return ["scanresults" : [] as AnyObject, "more": "true" as AnyObject]
          }
          return json
        } catch {
          print("error: \(error.localizedDescription)")
        }

        if let responseData = characteristic.value,
          let responseString = String(data: responseData, encoding: .utf8), responseString == "N/A" {
          return ["scanresults" : [] as AnyObject, "more": "true" as AnyObject]
        }
        return ["scanresults" : [] as AnyObject, "more": "true" as AnyObject]
    }
  }

  // MARK - Currently Unused Operators
  
  public typealias CipherHandler = (Data) -> Data?
  
  public func encryptedValueToString(_ handler: @escaping CipherHandler) -> Observable<String> {
    return asObservable()
      .map { characteristic in
        guard let responseData = characteristic.value,
          let handlerData = handler(responseData),
          let responseString = String(data: handlerData, encoding: .utf8) else {
            return ""
        }
        return responseString
    }
  }
}
