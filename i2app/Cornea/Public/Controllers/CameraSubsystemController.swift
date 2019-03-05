//
//  CamerasSubsystemController.swift
//  i2app
//
//  Created by Arcus Team on 8/11/17.
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
import Cornea

protocol CamerasSubsystemController {

  //EXTENDED
  func cameraStatuses(_ subsystem: SubsystemModel?) -> [CameraStatusModel]
  func cameraStatus(_ subsystem: SubsystemModel?, forCamera deviceAddress: String) -> CameraStatusModel?
}

extension CamerasSubsystemController {

  func cameraStatus(_ subsystem: SubsystemModel?, forCamera deviceAddress: String) -> CameraStatusModel? {
    for thisCameraStatus: CameraStatusModel in cameraStatuses(subsystem) {
      if let address = CameraStatusCapabilityLegacy.getCamera(thisCameraStatus) {
        if address == deviceAddress {
          return thisCameraStatus
        }
      }
    }
    
    return nil
  }

  func cameraStatuses(_ subsystem: SubsystemModel?) -> [CameraStatusModel] {
    guard subsystemAvailable(subsystem) == true else {
      return [CameraStatusModel]()
    }

    if let instances = subsystem?.instances,
      let attributes = subsystem?.get() {
      return cameraStatuses(attributes, instances: instances)
    } else {
      return [CameraStatusModel]()
    }
  }

  func cameraStatuses(_ attributes: [String: AnyObject], instances: [String : AnyObject]) -> [CameraStatusModel] {
    var models = [CameraStatusModel]()

    for (instanceType, capabilities) in instances {
      guard let capabilityFilters: [String] = capabilities as? [String] else {
        continue
      }
      if let model: CameraStatusModel = MultiCapabilityInstancedModelFactory
        .createCameraModel(attributes,
                          instanceFilter: instanceType,
                          attributesFilters: capabilityFilters) {
        models.append(model)
      }
    }
    return models
  }

  fileprivate func subsystemAvailable(_ subsystem: SubsystemModel?) -> Bool {
    if let subsystem = subsystem {
      return subsystem.hasAttributes()
    }
    return false
  }
}
