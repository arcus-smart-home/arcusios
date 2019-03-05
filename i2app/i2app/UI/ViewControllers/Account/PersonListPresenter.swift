//
//  PeopleListPresenter.swift
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
import PromiseKit

@objc
protocol PersonListPresenterDelegate {
  func didReceivePersonList(_ peopleList: [PersonViewModel], presenter: PersonListPresenter)
  func didSetCurrentPerson(_ person: PersonViewModel, presenter: PersonListPresenter)
  @objc optional func shouldAllowPersonInList(_ person: PersonViewModel,
                                              presenter: PersonListPresenter) -> Bool
}

class PersonListPresenter: NSObject {
  var currentPlace: PlaceModel?

  weak var delegate: PersonListPresenterDelegate?
  var personList: [PersonViewModel] = []

  fileprivate var persons: [PersonViewModel] = [PersonViewModel]()
  fileprivate var pending: [PersonViewModel] = [PersonViewModel]()

  internal var currentPerson: PersonViewModel?
  fileprivate var cachedSelectedIndex: Int = -1

  // MARK: Initialization
  required init(place: PlaceModel, delegate: PersonListPresenterDelegate) {
    self.currentPlace = place
    self.delegate = delegate

    super.init()

    self.observePersonAddedRemovedEvents()
  }

  deinit {
    self.removeObserverOfPersonAddRemovedEvents()
  }

  // MARK: Person Added/Removed Observation
  func observePersonAddedRemovedEvents() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(personListChanged(_:)),
                                           name: Notification.Name.modelAdded,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(personListChanged(_:)),
                                           name: Notification.Name.modelDeleted,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(personListChanged(_:)),
                                           name: Notification.Name(rawValue: "UpdatePersonModelNotification"),
                                           object: nil)
  }

  func removeObserverOfPersonAddRemovedEvents() {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Notification Handling
  func personListChanged(_ notification: Notification) {
    if notification.object is PersonModel {
      self.fetchPeopleList()
    }
  }

  func setCurrentPersonFromIndex(_ selectedIndex: Int) {
    if self.personList.indices.contains(selectedIndex) {
      self.currentPerson = self.personList[selectedIndex]
    }
  }

  func selectedIndex() -> Int {
    return updateSelectedIndexAndCurrentPerson()
  }

  fileprivate func updateSelectedIndexAndCurrentPerson() -> Int {
    var selectedIndex: Int = -1

    if self.currentPerson != nil {
      for person: PersonViewModel in self.personList
        where person.modelId! as String == self.currentPerson!.modelId! as String {
          selectedIndex = self.personList.index(of: person)!
          break
      }
    }

    if selectedIndex > -1 {
      self.cachedSelectedIndex = selectedIndex
    } else {
      // Current Person has been deleted
      self.cachedSelectedIndex = max(self.cachedSelectedIndex - 1, 0)
      selectedIndex = self.cachedSelectedIndex
      self.setCurrentPersonFromIndex(selectedIndex)
    }

    return selectedIndex
  }

  // MARK: Data I/O
  func fetchPeopleList() {
    DispatchQueue.global(qos: .background).async {
      if let currPlace = self.currentPlace {
        _ = PlaceController.fetchAllPeopleWithRoleForPlace(currPlace)
          .swiftThen { (personViewModels: Any?) -> PMKPromise? in
            if let personViewModels = personViewModels as? [PersonViewModel] {
              var allowedPersonModels = [PersonViewModel]()
              for person in personViewModels {
                if let allow = self.delegate?.shouldAllowPersonInList?(person, presenter: self),
                  allow == true {
                  allowedPersonModels.append(person)
                }
               }
              self.personList = allowedPersonModels
              _ = self.updateSelectedIndexAndCurrentPerson()
              self.delegate?.didReceivePersonList(self.personList, presenter: self)
              return nil
            }
            return nil
        }
      }
    }
  }

  func deleteInvitation(_ person: PersonViewModel) {
    if person.accessType == PlaceAccessType.pending {
      DispatchQueue.global(qos: .background).async {
        _ = PlaceCapability.cancelInvitation(withCode: person.modelId, on: self.currentPlace!)
          .swiftThen { _ in
            self.fetchPeopleList()
            return nil
        }
      }
    }
  }
}
