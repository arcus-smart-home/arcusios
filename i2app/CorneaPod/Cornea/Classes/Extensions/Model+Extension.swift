//
//  Model+Extension.swift
//  i2app
//
//  Created by Arcus Team on 10/13/17.
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

extension Model {
  open var name: String {
    return getName()
  }

  open var tags: [AnyObject]? {
    return getTags()
  }

  open var caps: [String]? {
    return getCapabilities()
  }

  open var instances: [String: AnyObject]? {
    return getInstances()
  }

  open var type: String? {
    return getType()
  }
}
