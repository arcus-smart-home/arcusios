//
//  ContactModel.swift
//  i2app
//
//  Created by Arcus Team on 4/26/16.
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
import Contacts

class ContactModel: NSObject {
  var contactIdentifier: String?
  var firstName: String?
  var lastName: String?
  var filterName: String?
  var phoneNumber: String?
  var emailAddress: String?
  var image: UIImage?

  @available(iOS 9.0, *)
  init(contact: CNContact) {
    self.contactIdentifier = contact.identifier
    self.firstName = contact.givenName
    self.lastName = contact.familyName

    if let isEmpty: Bool = self.lastName?.isEmpty {
      if isEmpty {
        self.filterName = self.firstName
      } else {
        self.filterName = self.lastName
      }
    }

    if contact.phoneNumbers.count > 0 {
      for labelledValue in contact.phoneNumbers {
        if labelledValue.label == CNLabelPhoneNumberMobile ||
          labelledValue.label == CNLabelPhoneNumberMain {
          let labelledPhone = labelledValue.value
          let phoneNumber: String? = labelledPhone.stringValue
          self.phoneNumber = phoneNumber
          break
        }
      }

      if self.phoneNumber == nil {
        self.phoneNumber = contact.phoneNumbers[0].value.stringValue
      }
    }

    if contact.emailAddresses.count > 0 {
      for labelledValue in contact.emailAddresses where labelledValue.label == CNLabelHome {
          self.emailAddress = String(describing: labelledValue.value)
      }

      if self.emailAddress == nil {
        self.emailAddress = String(describing:  contact.emailAddresses[0].value)
      }
    }

    if contact.imageDataAvailable, contact.thumbnailImageData != nil {
      self.image = UIImage(data: contact.thumbnailImageData!)
    }
  }
}
