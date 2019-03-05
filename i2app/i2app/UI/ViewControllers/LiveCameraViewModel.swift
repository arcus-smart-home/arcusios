//
//  LiveCameraViewModel.swift
//  i2app
//
//  Created by Arcus Team on 8/9/17.
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

enum CameraActivity {
  case firmware
  case offline
  case active
  case recording
  case hub4g
}

struct LiveCameraViewModel {
  var identifier: String = ""
  var cameraPreview: Data?
  var status: CameraActivity = .active
  var title = ""
  var isRecordEnabled = true
  
  /// If the CameraEvent has been set display it else display and empty string
  var subtitle: String {
    if let cameraEvent = cameraEvent {
      return cameraEvent
    } else {
      return ""
    }
  }
  var cameraEvent: String?
  var model: DeviceModel

  init(withCameraCapableDeviceModel device: DeviceModel,
       cameraPreview preview: Data? = nil,
       state cameraState: String,
       cellular isHub4g: Bool) {
    model = device
    cameraPreview = preview
    isRecordEnabled = !device.isSwannCamera
    
    //TODO: Subsystem enum constants should be defined somewhere in Cornea...?
    if device.isDeviceOffline() || cameraState == "OFFLINE" {
      title = device.name
      status = .offline
    } else if device.isUpdatingFirmware() {
      title = device.name
      status = .firmware
    } else if isHub4g {
      title = device.name
      status = .hub4g
    } else if cameraState == "RECORDING" {
      title = device.name
      status = .recording
    } else if cameraState == "IDLE" || cameraState == "STREAMING" {
      title = device.name
      status = .active
    }
  }
}

extension LiveCameraViewModel: Equatable {
  static func == (lhs: LiveCameraViewModel, rhs: LiveCameraViewModel) -> Bool {
    return lhs.model === rhs.model
  }
}
