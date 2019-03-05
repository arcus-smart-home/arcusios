//
//  CameraClipsFilterPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/18/17.
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

/// More of a datasource than a presenter, static functions that provide a list
class CameraClipsFilterPresenter {

  static var getCamerasToDisplay: OrderedDictionary? {
    // Get all the rooms
    guard let cameras = CameraClipsFilterPresenter.camerasFilters else {
        return nil
    }
    let mutableDict: NSMutableDictionary = NSMutableDictionary()
    for camera in cameras {
      mutableDict.setValue(camera.address, forKey: camera.name)
    }
    mutableDict.addEntries(from: [NSLocalizedString("ALL CAMERAS", comment: ""):
      NSLocalizedString("ALL CAMERAS", comment: "")])
    let returnVal = OrderedDictionary(dictionary: mutableDict)
    returnVal.sortArray()
    return returnVal
  }

  static var camerasFilters: [ClipCameraFilter]? {
    guard let camerasController = SubsystemsController.sharedInstance().camerasController,
      let cameraAddresses = camerasController.allDeviceIds as? [String] else {
        return nil
    }
    enum CameraMapError: Error {
      case cannotFindInCache
    }

    var builtCameras: [ClipCameraFilter]?
    do {
      builtCameras = try cameraAddresses.map { address -> DeviceModel in
        guard let device = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel else {
          throw CameraMapError.cannotFindInCache
        }
        return device
        } .map({ (device) -> ClipCameraFilter in
          guard let address = device.address as String?,
            let name = device.name as? String else {
              throw CameraMapError.cannotFindInCache
          }
          return ClipCameraFilter(address: address, name: name)
        })
    } catch {
      builtCameras = nil
    }
    return builtCameras
  }

  static var timeFilterDisplay: OrderedDictionary? {
    var i: UInt = 0
    let returnVal = OrderedDictionary()
    ClipTimeFilter.allClipTimeFilters.forEach( { filter in
      returnVal.insert(filter.filterName, forKey:filter.filterName, at:i)
      i += 1
    })
    return returnVal
  }

}
