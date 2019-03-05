//
//  AddPersonContactTypeSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/22/16.
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

import UIKit
import Cornea
import Contacts
import AddressBook

class AddPersonContactTypeSelectionViewController: UIViewController {
  @IBOutlet var headerLabel: ArcusLabel!
  @IBOutlet var descriptionLabel: ArcusLabel!

  @IBOutlet var useContactsButton: ArcusButton!
  @IBOutlet var enterManuallyButton: ArcusButton!

  internal var addPersonModel: AddPersonModel?

  var contactsArray: [ContactModel]? = []

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)
  }

  // MARK: IBActions
  @IBAction func useContactsButtonPressed(_ sender: ArcusButton) {
    self.requestAccess { (accessGranted) -> Void in
      if accessGranted {
        self.contactsArray = self.retrieveContacts()
        self.performSegue(withIdentifier: "AddPersonSelectContactModalSegue", sender: self)
      } else {
        let errorTitle: String = "Cannot Access Contacts"
        let errorMessage: String = "Go to your iOS Settings > Privacy > \nContacts " +
        "to allow \"Arcus\" to \naccess your contacts."

        self.displayErrorMessage(errorMessage, withTitle: errorTitle)
      }
    }
  }

  @available(iOS 9.0, *)
  func retrieveContacts() -> [ContactModel]? {
    var retrievedContacts: [ContactModel]? = []
    let store = CNContactStore()
    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                       CNContactIdentifierKey,
                       CNContactPhoneticGivenNameKey,
                       CNContactPhoneticFamilyNameKey,
                       CNContactPhoneNumbersKey,
                       CNContactEmailAddressesKey,
                       CNContactImageDataAvailableKey,
                       CNContactThumbnailImageDataKey] as [Any]
    if let descKeys = keysToFetch as? [CNKeyDescriptor] {
      let request = CNContactFetchRequest(keysToFetch: descKeys)
      do {
        try store.enumerateContacts(with: request) { contact, _ in
          let contactModel = ContactModel(contact: contact)
          retrievedContacts?.append(contactModel)
        }
      } catch {}
    }
    return retrievedContacts
  }

  func requestAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
    self.requestContactsAccess(completionHandler)
  }

  @available(iOS 9.0, *)
  func requestContactsAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
    let authorizationStatus =
      CNContactStore.authorizationStatus(for: CNEntityType.contacts)

    switch authorizationStatus {
    case .authorized:
      completionHandler(true)

    case .denied, .notDetermined:
      CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: {
        (access, _) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
          completionHandler(access)
        })
      })

    default:
      completionHandler(false)
    }
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonBasicInfoSegue" {
      if let basicInfoViewController = segue.destination as? AddPersonBasicInfoViewController {
        basicInfoViewController.addPersonModel = self.addPersonModel
      }
    } else if segue.identifier == "AddPersonSelectContactModalSegue" {
      let selectContactViewController = segue.destination as? AddPersonSelectContactViewController
      selectContactViewController?
        .configureWithContacts(self.contactsArray,
                               completionHandler: {
                                (selectedContact: ContactModel) -> Void in
                                self.addPersonModel!.setContactInfo(selectedContact)

                                self.navigationController?.dismiss(animated: true, completion: {
                                  self.performSegue(withIdentifier: "AddPersonBasicInfoSegue", sender: self)
                                })
        })
    }
  }
}
