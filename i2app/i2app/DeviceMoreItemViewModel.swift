//
//  DeviceMoreItemViewModel.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

/*
 `DeviceMoreItem` struct which conforms to `DeviceMoreItemViewModel`
 **/
struct DeviceMoreItem: DeviceMoreItemViewModel {
  var title: String
  var description: String
  var info: String?
  var actionType: DeviceMoreActionType
  var actionIdentifier: String
  var cellIdentifier: String
  var metaData: [String: AnyObject]?

  init(_ title: String,
       description: String,
       info: String?,
       actionType: DeviceMoreActionType,
       actionIdentifier: String,
       cellIdentifier: String,
       metaData: [String: AnyObject]?) {
    self.title = title
    self.description = description
    self.info = info
    self.actionType = actionType
    self.actionIdentifier = actionIdentifier
    self.cellIdentifier = cellIdentifier
    self.metaData = metaData
  }
}
