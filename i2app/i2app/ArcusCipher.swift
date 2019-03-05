//
//  ArcusCipher.swift
//  i2app
//
//  Created by Arcus Team on 6/8/18.
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

import CryptoSwift

/**
 `ArcusCipher` protocol provides the ability to encrypt/decrypt data using AES-128.
 */
protocol ArcusCipher {
  /**
   Encrypt data using AES 128.

   - Parameters:
   - value: The `Data` to encrypt.
   - key: The `Data` key used to encrypt the received value.
   - initVector: The `Data` of the initVector used to encrypt the received data.

   - Returns: `Data` for the encrypted value if successful.
   */
  func aes128CBCEncrypt(_ value: Data, key: Data, initVector: Data) -> Data?

  /**
   Decrypt data using AES 128.

   - Parameters:
   - value: The `Data` to decrypt.
   - key: The `Data` key used to decrypt the received value.
   - initVector: The `Data` of the initVector used to decrypt the received data.

   - Returns: `Data` for the decrypted value if successful.
   */
  func aes128CBCDecrypt(_ value: Data, key: Data, initVector: Data) -> Data?
}

extension ArcusCipher {
  func aes128CBCEncrypt(_ value: Data, key: Data, initVector: Data) -> Data? {
    do {
      let aesCipher = try AES(key: key.bytes, blockMode: CBC(iv: initVector.bytes), padding: .pkcs7)
      let resultBytes = try aesCipher.encrypt(value.bytes)

      return Data(bytes: resultBytes)
    } catch {
      print(error)
    }
    return nil
  }

  func aes128CBCDecrypt(_ value: Data, key: Data, initVector: Data) -> Data? {
    do {
      let aesCipher = try AES(key: key.bytes, blockMode: CBC(iv: initVector.bytes), padding: .pkcs7)
      let resultBytes = try aesCipher.decrypt(value.bytes)

      return Data(bytes: resultBytes)
    } catch {
      print(error)
    }
    return nil
  }
}
