//
//  AlarmAddContactPresenter.swift
//  i2app
//
//  Arcus Team on 4/10/17.
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
import PromiseKit
import Contacts

protocol AlarmAddContactPresenterProtocol {
  weak var alarmAddContactDelegate: AlarmAddContactDelegate? {get set}
  init (delegate: AlarmAddContactDelegate)

  func addMonitoringStationContact()
}

protocol AlarmAddContactDelegate: class {
  func onContactAdded()
  func onCantAccessContact()
  func onErrorAddingContact()
}

struct AlarmAddContactConstants {
  static let kContactDisplayName = "Monitoring Station"
  static let kUserHasBeenPromptedToAddContact = "user-prompted-to-add-contact"
  static let kUserAddedContact = "user-added-contact"
  static let supportUrl = NSURL.SupportProMonitoring
}

class AlarmAddContactPresenter: AlarmAddContactPresenterProtocol {

  weak var alarmAddContactDelegate: AlarmAddContactDelegate?

  required init(delegate: AlarmAddContactDelegate) {
    self.alarmAddContactDelegate = delegate
  }

  func addMonitoringStationContact() {
    if hasUserPreviouslyAddedContact() {
      alarmAddContactDelegate?.onContactAdded()
    } else {
      self.checkContactsAuthorization()
    }
  }

  private func hasUserPreviouslyAddedContact() -> Bool {
    return UserDefaults.standard.bool(forKey: AlarmAddContactConstants.kUserAddedContact)
  }

  private func getMonitoringStationPhoneNumbers(_ completionHandler: @escaping ([String]) -> Void) {
    DispatchQueue.global(qos: .background).async {
      _ = ProMonitoringService.getMetaData().swiftThen({ (response) -> (PMKPromise?) in
        // Got UCC phone numbers from platform
        if let response = response as? ProMonitoringServiceGetMetaDataResponse {
          var phoneNumbers: [String] = []

          if let responseData = response.getMetadata() {
            for thisNumber in responseData {
              if let thisNumberString = thisNumber as? String {
                phoneNumbers.append(thisNumberString)
              }
            }
          }
          completionHandler(phoneNumbers)
        }
        return nil
      }).swiftCatch({ (_) -> (PMKPromise?) in
        // Error occured fetching UCC phone numbers from platform
        self.alarmAddContactDelegate?.onErrorAddingContact()
        return nil
      })
    }

  }

  // MARK: - Contacts API for iOS 9 (and above)

  @available(iOS 9, *)
  private func checkContactsAuthorization() {
    let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

    switch authorizationStatus {
    case .authorized:
      self.getMonitoringStationPhoneNumbers({ (phoneNumbers) in
        self.addRecordToContacts(phoneNumbers)
      })
      break

    case .restricted, .denied:
      alarmAddContactDelegate?.onCantAccessContact()
      break

    case .notDetermined:
      promptToAuthorizeContacts()
      break
    }
  }

  @available(iOS 9, *)
  private func promptToAuthorizeContacts() {
    CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: {
      (_, _) -> Void in
      DispatchQueue.main.async {
        self.getMonitoringStationPhoneNumbers({ (phoneNumbers) in
          self.addRecordToContacts(phoneNumbers)
        })
      }
    })
  }

  @available(iOS 9, *)
  private func addRecordToContacts(_ phoneNumbers: [String]) {

    let record = CNMutableContact()

    record.organizationName = AlarmAddContactConstants.kContactDisplayName

    for thisPhoneNumber in phoneNumbers {
      record.phoneNumbers.append(CNLabeledValue(label: CNLabelPhoneNumberMain,
                                                value: CNPhoneNumber(stringValue: thisPhoneNumber)))
    }

    do {
      let saveRequest = CNSaveRequest()
      let contactStore = CNContactStore()

      saveRequest.add(record, toContainerWithIdentifier: nil)
      try contactStore.execute(saveRequest)

      // Success!
      UserDefaults.standard.set(true, forKey: AlarmAddContactConstants.kUserAddedContact)
      alarmAddContactDelegate?.onContactAdded()

    } catch {
      alarmAddContactDelegate?.onErrorAddingContact()
    }
  }

}
