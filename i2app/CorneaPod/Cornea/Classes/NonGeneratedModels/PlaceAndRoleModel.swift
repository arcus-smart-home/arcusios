//
//  PlaceAndRoleModel.swift
//  i2app
//
//  Created by Arcus Team on 5/5/16.
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

@objc
public class PlaceAndRoleModel: NSObject {

  public static let ownerString = "OWNER"
  public static let guestString = "FULL_ACCESS"

  public var placeName: String = ""
  public var placeId: String = ""
  public var role: String = ""
  public var primary: Bool = false

  public var streetAddress1: String = ""
  public var streetAddress2: String = ""
  public var city: String = ""
  public var state: String = ""
  public var zipCode: String = ""

  public let defaultImageSize: CGSize = CGSize(width: 50, height: 50)

  public required init(dict: [String : AnyObject]) {
    super.init()

    let attributes: [String : AnyObject] = dict
    if let name: String = attributes["name"] as? String {
      self.placeName = name
    }
    if let placeId: String = attributes["placeId"] as? String {
      self.placeId = placeId
    }
    if let role: String = attributes["role"] as? String {
      self.role = role
    }
    if let primary: Bool = attributes["primary"] as? Bool {
      self.primary = primary
    }

    if let streetAddress1: String = attributes["streetAddress1"] as? String {
      self.streetAddress1 = streetAddress1
    }
    if let streetAddress2: String = attributes["streetAddress2"] as? String {
      self.streetAddress2 = streetAddress2
    }
    if let city: String = attributes["city"] as? String {
      self.city = city
    }
    if let state: String = attributes["state"] as? String {
      self.state = state
    }
    if let zipCode: String = attributes["zipCode"] as? String {
      self.zipCode = zipCode
    }
  }

  // MARK: Convenience Methods
  public func placeLocation() -> String {
    return "\(streetAddress1) \(streetAddress2)\n\(city), \(state) \(zipCode)"
  }
}
