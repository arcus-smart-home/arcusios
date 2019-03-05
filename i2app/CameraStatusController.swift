//
//  CameraModelController.swift
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

protocol CameraStatusController {

  //EXTENDED
  func activeRecording(_ model: CameraStatusModel) -> String?
  func cameraAddress(_ model: CameraStatusModel) -> String?
  func lastRecordingAddress(_ model: CameraStatusModel) -> String?
  //func lastRecordingTime(_ model: CameraStatus) -> String
  func state(_ model: CameraStatusModel) -> String?
}


extension CameraStatusController {
  func activeRecording(_ model: CameraStatusModel) -> String? {
    if let record = CameraStatusCapabilityLegacy.getActiveRecording(model) {
      return record
    }
    return nil
  }

  func cameraAddress(_ model: CameraStatusModel) -> String? {
    return CameraStatusCapabilityLegacy.getCamera(model)
  }

  func lastRecordingAddress(_ model: CameraStatusModel) -> String? {
    return CameraStatusCapabilityLegacy.getLastRecording(model)
  }

  //func lastRecordingTime(_ model: CameraStatus) -> String {
  //  let time = model.getAttribute("camerastatus:lastRecordingTime") as! NSValue
  //  return time.doubleValue
  //}

  func state(_ model: CameraStatusModel) -> String? {
    return CameraStatusCapabilityLegacy.getState(model)
  }
}
