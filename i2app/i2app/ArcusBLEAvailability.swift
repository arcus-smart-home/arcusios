//
//  ArcusBLEAvailability.swift
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

/**
 The `ArcusBLEAvailability` protocol allows the conforming class to expose the ability to check if
 BLE communication is available without requiring the import of CoreBluetooth at the UI level.
 */
protocol ArcusBLEAvailability: ArcusBLEUtility {
  /**
   Method that can be used to observe if Bluetooth is on and available.

   - Returns: `Observable<Bool>` sequence that can be bound to/observered to monitor Bluetooth availability.
   */
  func isBLEAvailable() -> Observable<Bool>
}

extension ArcusBLEAvailability {
  func isBLEAvailable() -> Observable<Bool> {
    return centralManager.rx.state
      .map {
        return $0 == .poweredOn
      }
      .observeOn(MainScheduler.asyncInstance)
  }
}
