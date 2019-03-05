//
//  Invitation.swift
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
import Cornea

@objc class Invitation: NSObject, NSCopying {
    var code: String?
    var inviteeEmail: String?
    var inviteeFirstName: String?
    var inviteeLastName: String?

    var invitorFirstName: String?
    var invitorLastName: String?

    var placeName: String?
    var streetAddress1: String?
    var streetAddress2: String?
    var city: String?

    var placeId: String?

    required init(attributes: NSDictionary?) {
        if attributes != nil {
            self.code = attributes!["code"] as? String
            self.inviteeEmail = attributes!["inviteeEmail"] as? String
            self.inviteeFirstName = attributes!["inviteeFirstName"] as? String
            self.inviteeLastName = attributes!["inviteeLastName"] as? String

            self.invitorFirstName = attributes!["invitorFirstName"] as? String
            self.invitorLastName = attributes!["invitorLastName"] as? String

            self.placeName = attributes!["placeName"] as? String
            self.streetAddress1 = attributes!["streetAddress1"] as? String
            self.streetAddress2 = attributes!["streetAddress2"] as? String
            self.city = attributes!["city"] as? String

            self.placeId = attributes!["placeId"] as? String
        }
    }

    required init(_ model: Invitation) {
        self.code = model.code
        self.inviteeEmail = model.inviteeEmail
        self.inviteeFirstName = model.inviteeFirstName
        self.inviteeLastName = model.inviteeLastName
        self.invitorFirstName = model.invitorFirstName
        self.invitorLastName = model.invitorLastName
        self.placeName = model.placeName
        self.streetAddress1 = model.streetAddress1
        self.streetAddress2 = model.streetAddress2
        self.city = model.city
        self.placeId = model.placeId
    }

    func copy(with zone: NSZone?) -> Any {
        // This is the reason why `init(_ model: GameModel)`
        // must be required, because `GameModel` is not `final`.
        return type(of: self).init(self)
    }

    override func isEqual(_ object: Any?) -> Bool {
      if let invite = object as? Invitation, let email = invite.inviteeEmail {
        return self.code == invite.code && self.inviteeEmail == email
      }
      return false
    }

}
