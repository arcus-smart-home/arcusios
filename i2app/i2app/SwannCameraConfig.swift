//
//  SwannCameraConfig.swift
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

extension Constants {
  fileprivate struct SwannCamera {
    static let initVector: String = "BE988AEC227543F692CAB1E7EC7B0AC0"
    static let sharedKey: String = "2E2C183DBB77493DB08A"
  }
}

/**
 `SwannCameraConfig` protocol providers helpers for configuring the ivData and keyData needed to
 encrypt/decrypt BLE communication with the camera.
 */
protocol SwannCameraConfig {
  // String used for creating iv `Data` for encryption/decryption.
  var initVector: String { get }

  /**
   Method will generate key `Data` used for encryption/decryption using provided mac & sharedKey.

   - Parameters:
   - mac: Hex `String` representing the device's MAC address.
   - sharedKey: The `String` of the shared key to be used for encryption/decryption.

   - Returns: The keyData `Data` if mac anad sharedKey are configured properly.
   */
  func keyData(_ mac: String, sharedKey: String) -> Data?
}

extension SwannCameraConfig {
  var initVector: String {
    return Constants.SwannCamera.initVector
  }

  func keyData(_ mac: String, sharedKey: String = Constants.SwannCamera.sharedKey) -> Data? {
    guard let macData: Data = mac.dataFromHexString() as Data?,
      let sharedKeyData: Data = sharedKey.dataFromHexString() as Data? else {
        return nil
    }

    let macBytes: [UInt8] = macData.bytes
    let sharedBytes: [UInt8] = sharedKeyData.bytes

    var keyBytes: [UInt8] = []
    keyBytes.append(sharedBytes[0])
    keyBytes.append(sharedBytes[1])
    keyBytes.append(macBytes[5])
    keyBytes.append(sharedBytes[2])
    keyBytes.append(macBytes[4])
    keyBytes.append(sharedBytes[3])
    keyBytes.append(macBytes[3])
    keyBytes.append(sharedBytes[4])
    keyBytes.append(sharedBytes[5])
    keyBytes.append(macBytes[2])
    keyBytes.append(sharedBytes[6])
    keyBytes.append(macBytes[1])
    keyBytes.append(sharedBytes[7])
    keyBytes.append(macBytes[0])
    keyBytes.append(sharedBytes[8])
    keyBytes.append(sharedBytes[9])

    return Data(bytes: keyBytes)
  }
}
