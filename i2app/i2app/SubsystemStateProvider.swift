//
//  SubsystemStateProvider.swift
//  i2app
//
//  Created by Arcus Team on 3/2/17.
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

import PromiseKit
import Cornea

protocol SubsystemStateProvider {
  // MARK: Extended
  func activateSubsystem(_ subsystem: SubsystemModel) -> PMKPromise
  func suspendSubsystem(_ subsystem: SubsystemModel) -> PMKPromise
  func subsystemState(_ subsystem: SubsystemModel) -> String
}

extension SubsystemStateProvider {
  func activateSubsystem(_ subsystem: SubsystemModel) -> PMKPromise {
    return setSubsystemState(subsystem, state: kEnumSubsystemStateACTIVE)
  }

  func suspendSubsystem(_ subsystem: SubsystemModel) -> PMKPromise {
    return setSubsystemState(subsystem, state: kEnumSubsystemStateSUSPENDED)
  }

  func setSubsystemState(_ subsystem: SubsystemModel, state: String) -> PMKPromise {
    if state == kEnumSubsystemStateACTIVE {
      return SubsystemCapability.activate(on: subsystem)
    } else if state == kEnumSubsystemStateSUSPENDED {
      return SubsystemCapability.suspend(on: subsystem)
    }
    return PMKPromise.new {
      (_: PMKFulfiller?, rejecter: PMKRejecter?) in
      let error = NSError(domain: "Arcus", code: 999, userInfo: ["Error": "Invalid Subsystem State"])
      rejecter?(error)
    }
  }

  func subsystemState(_ subsystem: SubsystemModel) -> String {
    guard let state: String = SubsystemCapabilityLegacy.getState(subsystem) else { return ""}
    return state
  }
}
