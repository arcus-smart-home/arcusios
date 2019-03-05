//
//  BLEPairingClient.swift
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
import CocoaLumberjack
import RxSwift
import RxCocoa
import RxSwiftExt
import RxDataSources

extension Constants {
  static let wifiCfgService = CBUUID(string: "9DAB269A-0000-4C87-805F-BC42474D3C0B")
  static let wifiCfgScanResult = CBUUID(string: "9DAB269A-0001-4C87-805F-BC42474D3C0B")
  static let wifiCfgSupModes = CBUUID(string:"9DAB269A-0002-4C87-805F-BC42474D3C0B")
  static let wifiCfgSupFreq = CBUUID(string: "9DAB269A-0003-4C87-805F-BC42474D3C0B")
  static let wifiCfgMode = CBUUID(string: "9DAB269A-0004-4C87-805F-BC42474D3C0B")
  static let wifiCfgFreq = CBUUID(string: "9DAB269A-0005-4C87-805F-BC42474D3C0B")
  static let wifiCfgSSID = CBUUID(string: "9DAB269A-0006-4C87-805F-BC42474D3C0B")
  static let wifiCfgAuth = CBUUID(string: "9DAB269A-0007-4C87-805F-BC42474D3C0B")
  static let wifiCfgEncrypt = CBUUID(string: "9DAB269A-0080-4C87-805F-BC42474D3C0B")
  static let wifiCfgPasswd = CBUUID(string: "9DAB269A-0009-4C87-805F-BC42474D3C0B")
  static let wifiCfgStatus = CBUUID(string: "9DAB269A-000A-4C87-805F-BC42474D3C0B")

  static let bleGeneralService = CBUUID(string: "000010-10-00805F9B34FB")
  static let bleDeviceInformation = CBUUID(string: "0000180A-00-805F9B34FB")
  static let bleDeviceName = CBUUID(string: "00002A00-00-805F9B34FB")
  static let bleModelNumber = CBUUID(string: "00002A24-00-805F9B34FB")
  static let bleSerialNumber = CBUUID(string: "00002A25-00-805F9B34FB")
  static let bleFirmwareRevision = CBUUID(string: "00002A26-00-805F9B34FB")
  static let bleHardwareRevision = CBUUID(string: "00002A27-00-805F9B34FB")
  static let bleManufacturer = CBUUID(string: "00002A29-00-805F9B34FB")

  static let bleArcusFilter: String = "Arcus"
  static let bleCameraFilter: String = "Arcus_Cam"
  static let bleHubFilter: String = "Arcus_Hub"
  static let bleWSSFilter: String = "Arcus_Plug"

  static let wifiCameraShortName: String = "Security Camera"
  static let wifiPlugShortName: String = "Smart Plug"
}

class BLEPairingClient: ArcusBLEAvailability,
  ArcusBLEScannable,
  ArcusBLEConnectable,
  ArcusBLEConfigurable,
  ArcusBLEWiFiConfigurable,
  ArcusWiFiScanResultFactory,
  ArcusBLEPairable,
  ArcusCipher,
SwannCameraConfig{

  // Required by `ArcusBLEUtility`
  var centralManager: CBCentralManager!
  var disposeBag: DisposeBag = DisposeBag()

  // Required by `ArcusBLEScannable`
  var searchFilter: String!
  var isScanning: Variable<Bool> = Variable(false)
  var discoveredDevices: Variable<[ArcusBLEViewModel]> = Variable([])
  var discoveredDevicesDisposable: Disposable?

  // Required by `ArcusBLEConnectable`
  var connectedDevice: Variable<ArcusBLEViewModel?> = Variable(nil)
  var connectedDisposable: Disposable?

  // Required by `ArcusBLEConfigurable`
  var discoveredCharacteristics: Variable<[CBCharacteristic]> = Variable([])
  var discoveredCharacteristicsDisposable: Disposable?

  // Required by `ArcusBLEWifiConfigurable`
  var availableNetworks: Variable<[WiFiScanItem]> = Variable([])
  var selectedNetwork: Variable<WiFiScanItem?> = Variable(nil)
  var configStatus: Variable<BLEPairingConfigStatus> = Variable(.intial)
  var isSearching: Variable<Bool> = Variable<Bool>(false)
  var availableNetworksDisposable: Disposable?
  var configStatusDisposable: Disposable?

  // Required by `ArcusBLEPairable`
  var ipcdDeviceType: String!

  required init(_ centralManager: CBCentralManager, searchFilter: String? = Constants.bleArcusFilter, ipcdDeviceType: String = "") {
    self.centralManager = centralManager
    self.searchFilter = searchFilter
    self.ipcdDeviceType = ipcdDeviceType

    bindConnectedDevice()
  }

  func bindConnectedDevice() {
    // Subscribe to connectedDevice, and discover services when not nil.
    connectedDevice
      .asObservable()
      .filter { device in
        return device != nil
      }
      .subscribe(onNext: { [unowned self] _ in
        self.discoverCharacteristics()
      })
      .disposed(by: disposeBag)
  }

  func cleanUp() {
    centralManager.stopScan()
    if let peripheral = connectedDevice.value?.peripheral {
      centralManager.cancelPeripheralConnection(peripheral)
    }
    discoveredCharacteristics.value = []
    availableNetworks.value = []
  }
}
