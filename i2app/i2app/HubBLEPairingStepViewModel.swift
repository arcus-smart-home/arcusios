//
//  HubBLEPairingStepViewModel.swift
//  i2app
//
//  Created by Arcus Team on 7/16/18.
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

protocol HubBLEPairingStep: ArcusPairingStepViewModel {
  ///Title default is NEXT but here in case it needs to change
  var purpleButtonTitle: String? { get set }
  var purpleButtonEnabled: Bool { get set }
  var config: Any? { get set }
}

struct HubBLEPairingStepViewModel: HubBLEPairingStep {
  ///Title default is NEXT but here in case it needs to change
  var purpleButtonTitle: String? = "NEXT"
  var purpleButtonEnabled: Bool = false
  var config: Any?
}

extension HubBLEPairingStepViewModel: Equatable {
  public static func == (lhs: HubBLEPairingStepViewModel,
                         rhs: HubBLEPairingStepViewModel) -> Bool {
    return (lhs.purpleButtonTitle == rhs.purpleButtonTitle &&
      lhs.purpleButtonEnabled == rhs.purpleButtonEnabled)
  }
}
