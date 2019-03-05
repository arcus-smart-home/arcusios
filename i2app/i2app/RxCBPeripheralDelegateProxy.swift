//
//  RxCBPeripheralDelegateProxy.swift
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
import RxCocoa

public class RxCBPeripheralDelegateProxy: DelegateProxy, CBPeripheralDelegate, DelegateProxyType {
  public weak fileprivate(set) var peripheral: CBPeripheral?

  var didUpdateValueForCharacteristicPublishSubject =
    PublishSubject<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)>()
  var didUpdateValueForDescriptorPublishSubject =
    PublishSubject<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)>()

  var didWriteValueForCharacteristicPublishSubject =
    PublishSubject<(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?)>()
  var didWriteValueForDescriptorPublishSubject =
    PublishSubject<(peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?)>()

  // MARK: - Initialization

  public required init(parentObject: AnyObject) {
    self.peripheral = parentObject as? CBPeripheral
    super.init(parentObject: parentObject)
  }

  // MARK: - Delegate Proxy

  public override class func createProxyForObject(_ object: AnyObject) -> AnyObject {
    guard let peripheral: CBPeripheral = object as? CBPeripheral else { fatalError() }
    return peripheral.rxDelegateProxy()
  }

  public static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    guard let central: CBPeripheral = object as? CBPeripheral else { fatalError() }
    central.delegate = delegate as? CBPeripheralDelegate
  }

  public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    guard let peripheral: CBPeripheral = object as? CBPeripheral else { fatalError() }
    return peripheral.delegate
  }

  public func peripheral(_ peripheral: CBPeripheral,
                         didUpdateValueFor characteristic: CBCharacteristic,
                         error: Error?) {
    didUpdateValueForCharacteristicPublishSubject.onNext((peripheral, characteristic, error))
  }

  public func peripheral(_ peripheral: CBPeripheral,
                         didUpdateValueFor descriptor: CBDescriptor,
                         error: Error?) {
    didUpdateValueForDescriptorPublishSubject.onNext((peripheral, descriptor, error))
  }

  public func peripheral(_ peripheral: CBPeripheral,
                         didWriteValueFor characteristic: CBCharacteristic,
                         error: Error?) {
    didWriteValueForCharacteristicPublishSubject.onNext((peripheral, characteristic, error))
  }

  public func peripheral(_ peripheral: CBPeripheral,
                         didWriteValueFor descriptor: CBDescriptor,
                         error: Error?) {
    didWriteValueForDescriptorPublishSubject.onNext((peripheral, descriptor, error))
  }
}
