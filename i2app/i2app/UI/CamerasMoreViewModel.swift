//
//  CamerasMoreViewModel.swift
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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
 `CamerasMoreActionType` enum is used to define the types of actions that may be triggered by
 selecting a `CamerasMoreOptionViewModel`.
 **/
enum CamerasMoreActionType {
  case none
  case popup
  case segue
  case toggle
}

/*
 `CamerasMoreOptionViewModel` protocol is used to define a view model which represents a cell's data in
 Cameras -> More.
 **/
protocol CamerasMoreOptionViewModel {
  var title: String { get set }
  var description: String { get set }
  var actionType: CamerasMoreActionType { get set }
  var actionIdentifier: String { get set }
  var cellIdentifier: String { get set }
  var metaData: [String: AnyObject]? { get set }
}

/*
 `CamerasMoreViewModel` struct which conforms to `CamerasMoreOptionViewModel`
 **/
struct CamerasMoreViewModel: CamerasMoreOptionViewModel {
  var title: String
  var description: String
  var actionType: CamerasMoreActionType
  var actionIdentifier: String
  var cellIdentifier: String
  var metaData: [String: AnyObject]?

  init(_ title: String,
       description: String,
       actionType: CamerasMoreActionType,
       actionIdentifier: String,
       cellIdentifier: String,
       metaData: [String: AnyObject]?) {
    self.title = title
    self.description = description
    self.actionType = actionType
    self.actionIdentifier = actionIdentifier
    self.cellIdentifier = cellIdentifier
    self.metaData = metaData
  }
}
