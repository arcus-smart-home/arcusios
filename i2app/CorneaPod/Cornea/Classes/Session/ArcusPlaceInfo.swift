//
//  ArcusPlaceInfo.swift
//  i2app
//
//  Created by Arcus Team on 8/7/17.
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

/**
 `ArcusPlaceInfo` protocol defines required properties for a class containing Place Info received
 with Session Info when opening a session with the platform.
 */
public protocol ArcusPlaceInfo {
  var placeId: String? { get set }
  var placeName: String? { get set }
  var accountId: String? { get set }
  var role: String? { get set }
  var promonAdEnabled: Bool? { get set }
}
