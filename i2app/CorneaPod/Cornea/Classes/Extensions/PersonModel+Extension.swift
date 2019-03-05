//
//  PersonModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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

extension PersonModel {
  public var fullName: String {
    if let firstName = firstName,
      let lastName = lastName {
      return "\(firstName) \(lastName)"
    } else if let firstName = firstName {
      return firstName
    } else if let lastName = lastName {
      return lastName
    }
    return ""
  }

  public var firstName: String? {
    return PersonCapabilityLegacy.getFirstName(self)
  }

  public var lastName: String? {
    return PersonCapabilityLegacy.getLastName(self)
  }

  public var emailAddress: String? {
    return PersonCapabilityLegacy.getEmail(self)
  }

  public var phoneNumber: String? {
    return PersonCapabilityLegacy.getMobileNumber(self)
  }

  public var isAccountOwner: Bool {
    if let currentAccount = RxCornea.shared.settings?.currentAccount {
      if let currentId = AccountCapabilityLegacy.getOwner(currentAccount) {
        return modelId as String == currentId
      }
    }
    return false
  }

  public var hasPin: Bool {
    if let hasPinNum: NSNumber = PersonCapabilityLegacy.getHasPin(self),
      let personHasPin: Bool = hasPinNum.boolValue {
      return personHasPin
    }
    return false
  }

//  var image: UIImage? {
//    if let idString = modelId as String? {
//      return AKFileManager.default().cachedImage(forHash: idString,
//                                                 at: UIScreen.main.bounds.size,
//                                                 withScale: UIScreen.main.scale)
//    }
//    return nil
//  }

  public var getSubtitle: String? {
    if isAccountOwner == true {
      return "ACCOUNT OWNER"
    } else {
      // ITWO-4928 - Updated conversion of relation tags to string to continue to diplay
      // to diplay "Spouse/Partner" for SPOUSE
      var mutableTags = [String]()

      if let tags = getTags() {
        for tag in tags {
          if var tagString = tag as? String {
            let relationArray = PersonModel.personRelationArray()
            for relationshipInfo in relationArray {
              if relationshipInfo.keys.contains(where: { return $0 == tagString }) {
                if let relation = relationshipInfo[tagString] {
                  tagString = relation
                  break
                }
              }
            }
            mutableTags.append(tagString)
          }
        }
      }

      if mutableTags.count > 0 {
        return mutableTags.joined(separator: ", ")
      }
    }
    return nil
  }

  public var phoneEmailDescription: String? {
    if let phone = phoneNumber {
      if let email = emailAddress {
        return "\(phone)\n\(email)"
      } else {
        return "\(phone)\n"
      }
    } else if let email = emailAddress {
      return "\n\(email)"
    }
    return nil
  }

  func ownsAccount(_ account: AccountModel) -> Bool {
    if let ownerId = AccountCapabilityLegacy.getOwner(account),
      let currentId = self.modelId as String? {
      return currentId == ownerId
    }
    return false
  }

  public static func createPersonModelContainingAddressForModelId(_ modelId: String) -> PersonModel? {
    let personWithoutAddress = PersonModel(attributes: ["base:id": modelId as AnyObject])
    let address = personWithoutAddress.getAddressForNamespace(Constants.personNamespace)

    return PersonModel(attributes: ["base:id": modelId as AnyObject,
                                    "base:address": address as AnyObject])
  }

//  public static func filterOwner(_ personList: [PersonModel]) -> [PersonModel]? {
//    if let currentAccount = RxCornea.shared.settings?.currentAccount,
//      let currentId = AccountCapability.getOwnerFrom(currentAccount) {
//      return personList.filter({ return $0.modelId as String == currentId })
//    }
//    return nil
//  }

  public static func personRelationArray() -> [[String: String]] {
    return [["people_family": NSLocalizedString("Family", comment: "")],
            ["people_friend": NSLocalizedString("Friend", comment: "")],
            ["people_guest": NSLocalizedString("Guest", comment: "")],
            ["people_neighbor": NSLocalizedString("Neighbor", comment: "")],
            ["people_landlord": NSLocalizedString("Landlord", comment: "")],
            ["people_renter": NSLocalizedString("Renter", comment: "")],
            ["people_roommate": NSLocalizedString("Roommate", comment: "")],
            ["people_service_person": NSLocalizedString("Service Person", comment: "")],
            ["people_other": NSLocalizedString("Other", comment: "")]]
  }

  public static func subrelationArrayForRelationKey(_ relationKey: String) -> [[String: String]]? {
    if relationKey == "people_family" {
      return [["people_family_spouse": NSLocalizedString("Spouse/Partner", comment: "")],
              ["people_family_child_home": NSLocalizedString("Child (Lives at Home)", comment: "")],
              ["people_family_child_not_home": NSLocalizedString("Child (Doesn't Live at Home)", comment: "")],
              ["people_family_mother": NSLocalizedString("Mother", comment: "")],
              ["people_family_father": NSLocalizedString("Father", comment: "")],
              ["people_family_grandmother": NSLocalizedString("Grandmother", comment: "")],
              ["people_family_grandfather": NSLocalizedString("Grandfather", comment: "")],
              ["people_family_aunt": NSLocalizedString("Aunt", comment: "")],
              ["people_family_uncle": NSLocalizedString("Uncle", comment: "")],
              ["people_family_cousin": NSLocalizedString("Cousin", comment: "")]]

    } else if relationKey == "people_service_person" {
      return [["people_service_babysitter": NSLocalizedString("Babysitter (Nanny)", comment: "")],
              ["people_service_dogwalker": NSLocalizedString("Dog Walker", comment: "")],
              ["people_service_electrician": NSLocalizedString("Electrician", comment: "")],
              ["people_service_handyman": NSLocalizedString("Handyman", comment: "")],
              ["people_service_homecleaner": NSLocalizedString("Home Cleaner (Maid)", comment: "")],
              ["people_service_hvac": NSLocalizedString("HVAC Specialist", comment: "")],
              ["people_service_landscaper": NSLocalizedString("Landscaper", comment: "")],
              ["people_service_nurse": NSLocalizedString("Nurse", comment: "")],
              ["people_service_painter": NSLocalizedString("Painter", comment: "")],
              ["people_service_pestcontrol": NSLocalizedString("Pest Control", comment: "")],
              ["people_service_plumber": NSLocalizedString("Plumber", comment: "")],
              ["people_service_other": NSLocalizedString("Other", comment: "")]]
    }
    return nil
  }
}
