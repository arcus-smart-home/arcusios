//
//  ArcusDebugItemViewModel.swift
//  i2app
//
//  Created by Arcus Team on 12/5/17.
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

extension Constants {
  static let kSwitchCell: String = "switchCell"
  static let kInfoCell: String = "infoCell"
}

enum ArcusDebugMenuItemType {
  case switchCell
  case infoCell
}

typealias DebugSwitchHandler = (Bool) -> Void

protocol ArcusDebugMenuViewModel {
  var title: String { get set }
  var identifier: String { get set }
  var description: String? { get set }
  var switchHandler: DebugSwitchHandler? { get set }
  var switchState: Bool? { get set }
}

struct DebugMenuViewModel: ArcusDebugMenuViewModel {
  var title: String = ""
  var identifier: String = ""
  var description: String?
  var switchHandler: DebugSwitchHandler?
  var switchState: Bool? = false

  init(title: String,
       identifier: String = Constants.kInfoCell,
       description: String? = nil,
       switchHandler: DebugSwitchHandler? = nil,
       switchState: Bool? = nil) {
    self.title = title
    self.identifier = identifier
    self.description = description
    self.switchHandler = switchHandler
    self.switchState = switchState
  }
}
