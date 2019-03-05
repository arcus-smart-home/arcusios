//
//  ArcusBLEViewModel.swift
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

/**
 The `WiFiScanItem` protocol defines the required properties needed to represent a discovered peripheral.
 */
protocol ArcusBLEViewModel {
  var name: String { get set }
  var peripheral: CBPeripheral { get set }
  var macAddress: String? { get set }
}

class BLEViewModel: ArcusBLEViewModel {
  var name: String
  var peripheral: CBPeripheral
  var macAddress: String?

  required init(_ name: String, peripheral: CBPeripheral, macAddress: String? = nil) {
    self.name = name
    self.peripheral = peripheral
    self.macAddress = macAddress

    if macAddress == nil, name.count > 12 {
      let index = name.index(name.endIndex, offsetBy: -12)
      self.macAddress = name.substring(from: index)
    }
  }
}
