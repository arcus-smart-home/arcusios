//
//  PlaceInfo.swift
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
 `PlaceInfo` class is used to conform to `ArcusPlaceInfo`, and can be used by classes
 conforming `ArcusSessionInfo`.
 */
public class PlaceInfo: ArcusPlaceInfo {
  public var placeId: String?
  public var placeName: String?
  public var accountId: String?
  public var role: String?
  public var promonAdEnabled: Bool?

  public required init(_ place: PlaceModel) {
    self.placeId = place.modelId
    self.placeName = place.name
    self.accountId  = place.attributes["place:account"] as? String
  }

  public required init(_ attributes: [String: AnyObject]?) {
    if let placeId = attributes?["placeId"] as? String {
      self.placeId = placeId
    }

    if let placeName = attributes?["placeName"] as? String {
      self.placeName = placeName
    }

    if let accountId = attributes?["accountId"] as? String {
      self.accountId = accountId
    }

    if let role = attributes?["role"] as? String {
      self.role = role
    }

    if let promonAdEnabled = attributes?["promonAdEnabled"] as? Bool {
      self.promonAdEnabled = promonAdEnabled
    }
  }
}
