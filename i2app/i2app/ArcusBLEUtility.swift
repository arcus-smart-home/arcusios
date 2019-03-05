//
//  ArcusBLEUtility.swift
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
import CocoaLumberjack
import RxSwift
import RxCocoa
import RxSwiftExt
import RxDataSources

/**
 The `ArcusBLEUtility` protocol provides the contract for basic functionality needed by other `ArcusBLE`
 prefixed protocols.
 */
protocol ArcusBLEUtility: class {
  var centralManager: CBCentralManager! { get set }
  var disposeBag: DisposeBag { get set }

  /**
   Use to clean-up/shut down the use of CoreBluetooth when finished.
   */
  func cleanUp()
}

extension ArcusBLEUtility {
  func cleanUp() {}
}
