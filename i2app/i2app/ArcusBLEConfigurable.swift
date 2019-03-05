//
//  ArcusBLEConfigurable.swift
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

import Cornea
import CoreBluetooth
import RxSwift

/**
 The `ArcusBLEConfigurable` protocol allows the conforming class to expose the ability to discover services &
 characteristics as well as read, write, and setNotify on the discovered characteristics.
 */
protocol ArcusBLEConfigurable: ArcusBLEUtility {
  var discoveredCharacteristics: Variable<[CBCharacteristic]> { get set }
  var discoveredCharacteristicsDisposable: Disposable? { get set }

  /**
   Discover services for the bleDevice, and then discover characteristics for the returned services.

   - Parameters:
   - bleModel: `ArcusBLEModel` to attempt to discover characterisics for.

   - Returns: `Observable` emitting the array of discovered `[CBCharacteristics]`.
   */
  func discoverCharacteristics() -> Observable<[CBCharacteristic]>

  /**
   Read value from Characteristic in DiscoveredCharacteristics with matching uuid.

   - Parameters:
   - uuid: `CBUUID` of the Characteristic to attemppt to read value from.

   - Returns: `Single` with the Characteristic that can be used to pull the value out of.
   */
  func readValueForCharacteristic(_ uuid: CBUUID) -> Single<CBCharacteristic>

  /**
   Attempt to setNotify for Characteristic in DiscoveredCharacteristics with matching uuid.

   - Parameters:
   - uuid: `CBUUID` of the Characteristic to attemppt to read value from
   - shouldNotify: `Bool` value inidicating if Characteristic should notify or not.

   - Returns: `Single` with the Characteristic that can be used verify the notify value.
   */
  func setNotifyForCharacteristic(_ uuid: CBUUID,
                                  shouldNotify: Bool) -> Single<CBCharacteristic>

  /**
   Attempt to write value to Characteristic in DiscoveredCharacteristics with matching uuid.

   - Parameters:
   - uuid: `CBUUID` of the Characteristic to attemppt to read value from
   - value: `Data` value to write to Characteristic.

   - Returns: `Single` indicating success/failuree.
   */
  func writeValueForCharacteristic(_ uuid: CBUUID, value: Data) -> Single<Void>

  func observeCharacteristicDidNotfiy(_ uuid: CBUUID) -> Observable<CBCharacteristic>
}

extension ArcusBLEConfigurable where Self: ArcusBLEConnectable {
  @discardableResult
  func discoverCharacteristics() -> Observable<[CBCharacteristic]> {
    discoveredCharacteristicsDisposable?.dispose()

    discoveredCharacteristicsDisposable = performDiscoverCharacteristics()
      .catchErrorJustReturn([])
      .bind(to: discoveredCharacteristics)
    discoveredCharacteristicsDisposable?.disposed(by: disposeBag)

    return discoveredCharacteristics.asObservable()
  }

  func readValueForCharacteristic(_ uuid: CBUUID) -> Single<CBCharacteristic> {
    return Single<CBCharacteristic>.create { [unowned self] single in
      // Only attempt operation if connectedDevice is set, otherwise return error.
      guard let bleModel = self.connectedDevice.value else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))

        return Disposables.create()
      }

      // Get Characteristic from DicoveredCharacteristics, if not found return error.
      if let characteristic = self.getDiscoveredCharacteristicForUUID(uuid) {
        bleModel.peripheral.readValue(for: characteristic)
      } else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // Add timer in case of communication timeout.  If hit, return an error.
      let timerDisposable = Observable<Int>.interval(60, scheduler: MainScheduler.asyncInstance)
        .subscribe(onNext: { _ in
          single(.error(ClientError(errorType: .unknown)))
        })
      timerDisposable.disposed(by: self.disposeBag)

      // Observe the result of the read attempt, and return result.
      let readDisposable = bleModel.peripheral.rx
        .didUpdateValueForCharacteristic
        .filter {
          $0.1.uuid == uuid
        }
        .subscribe(onNext: { (_, characteristic, error) in
          guard error == nil else {
            single(.error(error!))
            return
          }
          single(.success(characteristic))
        })
      readDisposable.disposed(by: self.disposeBag)

      return Disposables.create {
        timerDisposable.dispose()
        readDisposable.dispose()
      }
    }
  }

  func setNotifyForCharacteristic(_ uuid: CBUUID,
                                  shouldNotify: Bool) -> Single<CBCharacteristic> {
    return Single<CBCharacteristic>.create { [unowned self] single in
      // Only attempt operation if connectedDevice is set, otherwise return error.
      guard let bleModel = self.connectedDevice.value else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // Get Characteristic from DicoveredCharacteristics, if not found return error.
      if let characteristic = self.getDiscoveredCharacteristicForUUID(uuid) {
        bleModel.peripheral.setNotifyValue(shouldNotify, for: characteristic)
      } else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // Add timer in case of communication timeout.  If hit, return an error.
      let timerDisposable = Observable<Int>.interval(60, scheduler: MainScheduler.asyncInstance)
        .subscribe(onNext: { _ in
          single(.error(ClientError(errorType: .unknown)))
        })
      timerDisposable.disposed(by: self.disposeBag)

      // Observe the result of the read attempt, and return result.
      let notifyDisposable = bleModel.peripheral.rx
        .didUpdateNotificationState
        .filter {
          $0.1.uuid == uuid
        }
        .subscribe(onNext: { (_, characteristic, error) in
          guard error == nil else {
            single(.error(error!))
            return
          }
          single(.success(characteristic))
        })
      notifyDisposable.disposed(by: self.disposeBag)

      return Disposables.create {
        timerDisposable.dispose()
        notifyDisposable.dispose()
      }
    }
  }

  func writeValueForCharacteristic(_  uuid: CBUUID, value: Data) -> Single<Void> {
    return Single<Void>.create { [unowned self] single in
      // Only attempt operation if connectedDevice is set, otherwise return error.
      guard let bleModel = self.connectedDevice.value else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // Get Characteristic from DicoveredCharacteristics, if not found return error.
      if let characteristic = self.getDiscoveredCharacteristicForUUID(uuid) {
        bleModel.peripheral.writeValue(value, for: characteristic, type: .withResponse)
      } else {
        // TODO: Update Error
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // Add timer in case of communication timeout.  If hit, return an error.
      let timerDisposable = Observable<Int>.interval(60, scheduler: MainScheduler.asyncInstance)
        .subscribe(onNext: { _ in
          single(.error(ClientError(errorType: .unknown)))
        })
      timerDisposable.disposed(by: self.disposeBag)

      // Observe the result of the write attempt, and return result.
      let writeDisposable = bleModel.peripheral.rx
        .didWriteValueForCharacteristic
        .filter {
          $0.1.uuid == uuid
        }
        .subscribe(onNext: { (_, _, error) in
          guard error == nil else {
            single(.error(error!))
            return
          }
          single(.success())
        })
      writeDisposable.disposed(by: self.disposeBag)

      return Disposables.create {
        timerDisposable.dispose()
        writeDisposable.dispose()
      }
    }
  }

  func observeCharacteristicDidNotfiy(_ uuid: CBUUID) -> Observable<CBCharacteristic> {
    return Observable<CBCharacteristic>.create { observable in
      // Only attempt operation if connectedDevice is set, otherwise return error.
      guard let bleModel = self.connectedDevice.value else {
        // TODO: Update Error
        observable.onError(ClientError(errorType: .unknown))
        return Disposables.create()
      }

      // Observe the notify attempt, and return result.
      let readDisposable = bleModel.peripheral.rx
        .didUpdateValueForCharacteristic
        .filter {
          $0.1.uuid == uuid
        }
        .subscribe(onNext: { (_, characteristic, error) in
          guard error == nil else {
            observable.onError(error!)
            return
          }
          observable.onNext(characteristic)
        })
      readDisposable.disposed(by: self.disposeBag)

      return Disposables.create {
        readDisposable.dispose()
      }
    }
  }

  // MARK: - Private Methods

  private func performDiscoverCharacteristics() -> Observable<[CBCharacteristic]> {
    return Observable<[CBCharacteristic]>.create { [unowned self] observer in
      // Only attempt operation if connectedDevice is set, otherwise return error.
      guard let bleModel = self.connectedDevice.value else {
        // TODO: Update Error
        observer.onError(ClientError(errorType: .unknown))
        return Disposables.create()
      }

      var result: [CBCharacteristic] = []
      observer.onNext(result)

      bleModel.peripheral.discoverServices(nil)

      // Subscribe to didDiscoverServices, and discover characteristic when not nil & services have been discovered.
      let serviceDisposable: Disposable = bleModel.peripheral.rx
        .didDiscoverServices
        .subscribe(onNext: { (peripheral, error) in
          guard error == nil else {
            DDLogError("CBPeripheral.rx.didDiscoverServicesS error: \(error!.localizedDescription)")
            return
          }

          guard let services = peripheral.services else { return }

          for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
          }
        })
      serviceDisposable.disposed(by: self.disposeBag)

      // Subscribe to didDiscoverCharacteristics, and collect characteristics for services as they are discovered.
      let characteristicDisposable: Disposable = bleModel.peripheral.rx
        .didDiscoverCharacteristics
        .subscribe(onNext: { (_, service, error) in
          guard error == nil else {
            DDLogError("CBPeripheral.rx.didDiscoverCharacteristics error: \(error!.localizedDescription)")
            return
          }

          guard let characteristics = service.characteristics else { return }

          result.append(contentsOf: characteristics)
          observer.onNext(result)
        })
      characteristicDisposable.disposed(by: self.disposeBag)

      return Disposables.create {
        serviceDisposable.dispose()
        characteristicDisposable.dispose()
      }
    }
  }

  /**
   Private helper method to check `discoveredCharacteristics` for Characteristic matching the provided uuid.

   - Parameters:
   - uuid: `CBUUID` of the Characteristic to attemppt to read value from

   - Returns: `CBCharacteristic` if found.
   */
  private func getDiscoveredCharacteristicForUUID(_ uuid: CBUUID) -> CBCharacteristic? {
    var result: CBCharacteristic?

    for characteristic in self.discoveredCharacteristics.value where characteristic.uuid == uuid {
      result = characteristic
    }

    return result
  }
}
