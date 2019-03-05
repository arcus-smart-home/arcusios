//
//  ArcusBLEWiFiConfigurable.swift
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
 The `ArcusBLEWiFiConfigurable` protocol allows the conforming class to expose the ability to read/write
 characteristics related to the configuration of a peripheral's WiFI network.
 */
protocol ArcusBLEWiFiConfigurable: ArcusBLEUtility {
  // Will be updated with results from `discoverAvailableNetworks()`/can be bound to/observed at the UI level.
  var availableNetworks: Variable<[WiFiScanItem]> { get set }
  var selectedNetwork: Variable<WiFiScanItem?> { get set }
  var configStatus: Variable<BLEPairingConfigStatus> { get set }
  var isSearching: Variable<Bool> { get set }


  var availableNetworksDisposable: Disposable? { get set }
  var configStatusDisposable: Disposable? { get set }

  /**
   Attempt to discover available WiFI Networks found by the peripheral
   */
  func discoverAvailableNetworks() -> Observable<[WiFiScanItem]>

  /**
   Attempt to configure the peripheral's WiFi network.

   - Parameters:
   - network: `WiFiScanItem` representing the network to attempt to configure.
   - networkKey: `String` representing the network key of the network to attempt to configure.

   - Returns: `Single` indicating if the configuration was successful.
   */
  func configureWifiNetwork(_ network: WiFiScanItem, networkKey: String) -> Single<Void>

  /**
   Attempt to configure the peripheral's WiFi network with `selectedNetwork`.

   - Parameters:
   - networkKey: `String` representing the network key of the network to attempt to configure.

   - Returns: `Single` indicating if the configuration was successful.
   */
  func configureSelectedWifiNetwork(_ networkKey: String) -> Single<Void>

  /**
   Attempt to read the peripheral's serial number.

   - Returns: `Single` returning the serial number if found.
   */
  func getDeviceSerial() -> Single<String>

  /**
   Attempt to read the peripheral's config status.

   - Returns: `Single` returning the status if found.
   */
  func getDeviceConfigStatus() -> Observable<BLEPairingConfigStatus>

  func setNotifyForStatus() -> Single<Void>
}

// swiftlint:disable:next line_length
extension ArcusBLEWiFiConfigurable where Self: ArcusBLEConnectable & ArcusBLEConfigurable & ArcusCipher & SwannCameraConfig & ArcusWiFiScanResultFactory & ArcusBLEPairable {
  func discoverAvailableNetworks() -> Observable<[WiFiScanItem]> {
    isSearching.value = true
    performNetworkDiscovery()
    return availableNetworks.asObservable()
  }

  func configureWifiNetwork(_ network: WiFiScanItem, networkKey: String) -> Single<Void> {
    return configureWifiNetworSSID(network.ssid)
      .flatMap { [unowned self] _ in
        return self.configureWifiNetworkSecurityType(network.security)
      }
      .flatMap { [unowned self] result in
        return self.configureWifiNetworkKey(networkKey)
    }
  }

  func configureSelectedWifiNetwork(_ networkKey: String) -> Single<Void> {
    guard let selectedNetwork = selectedNetwork.value else {
      return Single<Void>.create { single in
        single(.error(ClientError()))
        return Disposables.create()
      }
    }

    return configureWifiNetworSSID(selectedNetwork.ssid)
      .flatMap { [unowned self] _ in
        return self.configureWifiNetworkSecurityType(selectedNetwork.security)
      }
      .flatMap { [unowned self] result in
        return self.configureWifiNetworkKey(networkKey)
      }
  }

  func getDeviceSerial() -> Single<String> {
    return readValueForCharacteristic(Constants.bleSerialNumber)
      .valueToString()
      .asSingle()
  }

  func getDeviceConfigStatus() -> Observable<BLEPairingConfigStatus> {
    configStatusDisposable?.dispose()

    configStatusDisposable = readValueForCharacteristic(Constants.wifiCfgStatus)
      .valueToConfigStatus()
      .distinctUntilChanged()
      .catchErrorJustReturn(.failed)
      .bind(to: configStatus)
    configStatusDisposable?.disposed(by: disposeBag)

    return configStatus.asObservable()
  }

  func setNotifyForStatus() -> Single<Void> {
    return setNotifyForCharacteristic(Constants.wifiCfgScanResult, shouldNotify: true).map { _ in
      return ()
    }
  }

  // MARK: - Private Methods

  private func performNetworkDiscovery() {
    let readObservable: Observable<[String: AnyObject]> =
      readValueForCharacteristic(Constants.wifiCfgScanResult)
        .valueToDictionary()

    let availableNetworksObservable: Observable<([WiFiScanItem], Bool)> = readObservable
      .map { [unowned self] dictionary in
        let existingItems = self.availableNetworks.value
        let newItems = self.buildScanItemsForResult(dictionary)
        let mergedItems = self.mergeScanItems(newItems, existingItems: existingItems)
        let hasMore = self.scanHasMoreResults(dictionary)

        return (mergedItems, hasMore)
      }

    availableNetworksDisposable = availableNetworksObservable
      .do(onNext: { [unowned self] (_, hasMore) in
        if hasMore {
          self.performNetworkDiscovery()
        } else {
          self.isSearching.value = false
        }
      })
      .filterMap { args in
        return args.0.count > 0 ? .map(args.0) : .ignore
      }
      .asObservable()
      .catchErrorJustReturn([])
      .bind(to: availableNetworks)
    availableNetworksDisposable?.disposed(by: disposeBag)
  }

  /**
   Private method used to configure the periperhal's network SSID.

   - Parameters:
   - ssid: The ssid to attempt to write to peripheral.

   - Returns: `Single` indicating if the ssid write was successful.
   */
  private func configureWifiNetworSSID(_ ssid: String) -> Single<Void> {
    guard let ssidData = ssid.data(using: .utf8) else {
      return Single<Void>.create { single in
        single(.error(ClientError()))
        return Disposables.create()
      }
    }
    return writeValueForCharacteristic(Constants.wifiCfgSSID, value: ssidData)
  }

  /**
   Private method used to configure the periperhal's network security type.

   - Parameters:
   - security: The security type to attempt to write to peripheral.

   - Returns: `Single` indicating if the security write was successful.
   */
  private func configureWifiNetworkSecurityType(_ security: String) -> Single<Void> {
    guard let secData = security.data(using: .utf8) else {
      return Single<Void>.create { single in
        single(.error(ClientError()))
        return Disposables.create()
      }
    }
    return writeValueForCharacteristic(Constants.wifiCfgAuth, value: secData)
  }

  /**
   Private method used to configure the periperhal's network key.

   - Parameters:
   - networkKey: The key to attempt to write to peripheral.

   - Returns: `Single` indicating if the networkKey write was successful.
   */
  private func configureWifiNetworkKey(_ networkKey: String) -> Single<Void> {
    guard let networkKeyData = networkKey.data(using: .utf8),
      let mac = self.connectedDevice.value?.macAddress,
      let keyData = keyData(mac),
      let ivData = initVector.dataFromHexString() as Data?,
      let encryptedKey = aes128CBCEncrypt(networkKeyData, key: keyData, initVector:  ivData) else {
        return Single<Void>.create { single in
          single(.error(ClientError(errorType: .unknown)))
          return Disposables.create()
        }
    }

    return writeValueForCharacteristic(Constants.wifiCfgPasswd, value: encryptedKey)
  }
}
