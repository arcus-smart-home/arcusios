//
//  ClipFilter.swift
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

struct ClipFilter {

  var cameraFilter: ClipCameraFilter
  var timeFilter: ClipTimeFilter
  var pinnedOnly: Bool
  
  var latest: Double {
    return timeFilter.filterStartTime.millisecondsSince1970
  }
  
  var earliest: Double {
    return timeFilter.filterEndTime.millisecondsSince1970
  }

  var cameras: [String] {
    if let address = cameraFilter.address {
      return [address]
    } else {
      return []
    }
  }

  var tags: [String] {
    if pinnedOnly {
      return [kFavoriteTag]
    } else {
      return []
    }
  }

  /// Helper computed variable to display filter
  var selectedFacetCount: Int {
    var selected = 0
    if timeFilter != ClipTimeFilter.defaultFilter {
      selected += 1
    }
    if cameraFilter != ClipCameraFilter.defaultFilter {
      selected += 1
    }
    return selected
  }
}

extension ClipFilter: CustomStringConvertible {
  var description: String {
    return "latest: \(latest), earliest:\(earliest), cameras:\(cameras), " +
    "tags:\(tags)"
  }
}
