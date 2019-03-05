//
//  WSSNetworkConfig.swift
//  i2app
//
//  Created by Arcus Team on 5/4/18.
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

import Foundation
import RxSwift

/**
 `WSSNetworkConfig` ViewModel is used by WiFi Smart Switch Pairing UI to take input from the user which can
 be used to pair the WiFi Smart Switch.
 */
struct WSSNetworkConfig: ArcusWiFiNetworkConfig {
  var ssid: Variable<String> = Variable<String>("")
  var key: Variable<String> = Variable<String>("")

  var isValid: Observable<Bool>

  init() {
    let ssidObservable = self.ssid.asObservable()
    let keyObservable = self.key.asObservable()

    // Create `isValid` by combining the observable streams of each property, and checking that all
    // required conditions have been met.
    self.isValid = Observable.combineLatest(ssidObservable, keyObservable) { (ssid, key) in
      // Input is valid if both fields are not empty.
      //return ssid.count > 0 && key.count > 0

      return ssid.count > 0
    }
  }
}
