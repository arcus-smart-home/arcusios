//
//  AddPersonModel.swift
//  i2app
//
//  Created by Arcus Team on 4/25/16.
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

enum PersonAccessType {
  case unknown
  case fullAccess
  case locksAlarmNotifications
  case alarmNotificationsOnly
}

class AddPersonModel: NSObject {
  var accessType: PersonAccessType? = PersonAccessType.unknown
  var firstName: String?
  var lastName: String?
  var emailAddress: String?
  var phoneNumber: String?
  var pinCode: String?
  var image: UIImage?
  var personAttributes = [String: String]()
  var relation: String? {
    didSet {
      if relation?.contains(" ") == true {
        self.relation = self.relation?
          .replacingOccurrences(of: " ", with: "_").lowercased()
      }
    }
  }
  var invitationMessage: String?
  var personalizedMessage: String?
  
  var modelAddress: String?
  var modelId: String?
  
  func setContactInfo(_ contact: ContactModel) {
    self.firstName = contact.firstName
    self.lastName = contact.lastName
    self.phoneNumber = contact.phoneNumber
    self.emailAddress = contact.emailAddress
    self.image = contact.image
  }
  
  func sendFullAccessInvitation(_ completionHandler: ((_ success: Bool, _ error: Error?) -> Void)!) {
    if self.accessType == PersonAccessType.fullAccess {
      DispatchQueue.global(qos: .background).async {
        PersonController.invitePerson(self.firstName,
                                      lastName: self.lastName,
                                      email: self.emailAddress,
                                      relationship: self.relation,
                                      greeting: self.personalizedMessage,
                                      toPlace: RxCornea.shared.settings?.currentPlace,
                                      completion: { (success: Bool, error: Error?) in
                                        completionHandler(success, error)
        })
      }
    } else {
      completionHandler(false, nil)
    }
  }
  
  func savePersonModel(_ initialSave: Bool,
                       completionHandler: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
    if self.accessType != PersonAccessType.fullAccess {
      DispatchQueue.global(qos: .background).async {
        let personModel: PersonModel = self.personModel()
        if initialSave {
          if let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace {
            PersonController
              .addPerson(personModel,
                         withPassword: "",
                         toPlace: currentPlace,
                         completion: { (newPersonAddress: String?, error: Error?) in
                          
                          let success: Bool = (newPersonAddress != nil)
                          
                          if success {
                            self.modelAddress = newPersonAddress
                            
                            self.modelId = Model.modelIdForAddress(newPersonAddress!)
                            
                            let newPersonModel: PersonModel = self.personModel()
                            
                            if let placeId = RxCornea.shared.settings?.currentPlace?.modelId,
                              self.pinCode != nil {
                              self.savePin(self.pinCode!,
                                           placeId: placeId,
                                           personModel: newPersonModel)
                            }
                            
                            if self.image != nil {
                              ImagePicker.save(self.image,
                                               imageName: newPersonModel.modelId as String)
                            }
                          }
                          completionHandler(success, error)
              })
          }
        } else {
          // Update person model
          if self.phoneNumber != nil {
            PersonCapabilityLegacy.setMobileNumber(self.phoneNumber!, model: personModel)
          }
          
          if self.firstName != nil {
            PersonCapabilityLegacy.setFirstName(self.firstName!, model: personModel)
          }
          
          if self.lastName != nil {
            PersonCapabilityLegacy.setLastName(self.lastName!, model: personModel)
          }
          
          if self.emailAddress != nil {
            PersonCapabilityLegacy.setEmail(self.emailAddress!, model: personModel)
          }
          
          _ = personModel.commit()
            .swiftThen ({ _ in
              if let placeId = RxCornea.shared.settings?.currentPlace?.modelId,
                self.pinCode != nil  {
                self.savePin(self.pinCode!,
                             placeId: placeId,
                             personModel: personModel)
              }
              
              if self.image != nil {
                ImagePicker.save(self.image,
                                 imageName: personModel.modelId as String)
              }
              completionHandler(true, nil)
              return nil
            })
            .swiftCatch({ _ in
              completionHandler(false, nil)
              return nil
            })
        }
      }
    } else {
      completionHandler(false, nil)
    }
  }
  
  func savePin(_ pin: String, placeId: String, personModel: PersonModel) {
    DispatchQueue.global(qos: .background).async {
      PersonController.setPin(pin,
                              placeId: placeId,
                              personModel: personModel,
                              completion: nil)
    }
  }
  
  func personModel() -> PersonModel {
    var personAttributes = [String: AnyObject]()
    
    if let modelAddress = self.modelAddress {
      personAttributes[kAttrAddress] = modelAddress as AnyObject
    }
    
    if let modelId = self.modelId {
      personAttributes[kAttrId] = modelId as AnyObject
    }
    
    if let firstName = self.firstName {
      personAttributes[kAttrPersonFirstName] = firstName as AnyObject
    }
    
    if let lastName = self.lastName {
      personAttributes[kAttrPersonLastName] = lastName as AnyObject
    }
    
    if let phoneNumber = self.phoneNumber {
      personAttributes[kAttrPersonMobileNumber] = phoneNumber as AnyObject
    }
    
    if let emailAddress = self.emailAddress {
      personAttributes[kAttrPersonEmail] = emailAddress as AnyObject
    }
    
    if let relation = self.relation {
      let tagsArray: [String] = [relation]
      personAttributes[kAttrTags] = tagsArray as AnyObject
    }
    
    return PersonModel(attributes: personAttributes)
  }
}
