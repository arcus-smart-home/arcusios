//
//  WSSNetworkConfigurator.swift
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
 `WSSNetworkConfigurator` protocol is presenter used to define the properties & methods required by a
 ViewController in order to capture input from the user to configure a WiFi Smart Switch's network settings.
 */
protocol WSSNetworkConfigurator {
  // The Configuration ViewModel
  var config: ArcusWiFiNetworkConfig { get }

  // Required to dispose of Observers
  var disposeBag: DisposeBag { get set }

  /**
   Use this function to bind the `config` viewModel to the ViewController's UI.
   Example: Binding config.ssid to a textField.
      ssidTextField.rx.text
        .orEmpty
        .bind(to: config.ssid)
        .disposed(by: disposeBag)
    */
  func configureBindings()
}
