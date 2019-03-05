//
//  PersonViewModel.swift
//  i2app
//
//  Created by Arcus Team on 5/9/16.
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

enum PlaceAccessType: Int {
  case unknown = 0
  case owner = 1
  case fullAccess = 2
  case hobbit = 3
  case pending = 4
}

class PersonViewModel: NSObject {
  let defaultImageSize: CGSize = CGSize(width: 50, height: 50)

  var address: String?
  var modelId: String?
  var fullName: String?
  var phone: String?
  var email: String?
  var accessType: PlaceAccessType = .unknown
  var invitationDate: Date?
  var image: UIImage?
  var personModel: PersonModel?

  init(personModel: PersonModel, role: String) {
    super.init()

    self.address = personModel.address as String?
    self.modelId = personModel.modelId as String?
    self.fullName = personModel.fullName
    self.phone = personModel.phoneNumber
    self.email = personModel.emailAddress
    self.personModel = personModel

    self.image = AKFileManager.default().cachedImage(forHash: (self.modelId! as String),
                                                            at: defaultImageSize,
                                                            withScale: 1)

    self.accessType = self.accessTypeForRole(role)
  }

  init(pendingInfo: AnyObject) {
    super.init()

    if let code = pendingInfo["code"] as? String {
      self.modelId = code
    }

    if let firstName = pendingInfo["inviteeFirstName"] as? String {
      if let lastName = pendingInfo["inviteeLastName"] as? String {
        self.fullName = firstName + " " + lastName
      }
    }

    // No phone available in pendingInfo
    //if let phone: String? = pendingInfo["inviteePhone"] as? String {
    //    self.phone = phone
    //}

    if let email = pendingInfo["inviteeEmail"] as? String {
      self.email = email
    }

    if let date = pendingInfo["created"] as? Double {
      self.invitationDate = Date(timeIntervalSince1970: date/1000)
    }

    self.accessType = self.accessTypeForRole("PENDING")
  }

  // MARK: Helpers
  func accessTypeForRole(_ role: String) -> PlaceAccessType {
    var type: PlaceAccessType = PlaceAccessType.unknown
    if role == "OWNER" {
      type = PlaceAccessType.owner
    } else if role == "FULL_ACCESS" {
      type = PlaceAccessType.fullAccess
    } else if role == "HOBBIT" {
      type = PlaceAccessType.hobbit
    } else if role == "PENDING" {
      type = PlaceAccessType.pending
    }

    return type
  }

  func phoneEmailDescription() -> String {
    var result: String = ""
    if self.phone != nil {
      if self.email != nil {
        result = self.phone! + "\n" + self.email!
      } else {
        result = self.phone! + "\n"
      }
    } else if self.email != nil {
      result = "\n" + self.email!
    }

    return result
  }

  func invitationDateDescription() -> String {
    var result: String = ""

    if let date = self.invitationDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM dd, hh:mm a"

      result = "Invited " + dateFormatter.string(from: date)
    }

    return result

  }
}
