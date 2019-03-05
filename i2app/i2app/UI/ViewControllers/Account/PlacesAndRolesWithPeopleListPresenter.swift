//
//  PlacesAndRolesWithPeopleListPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/4/16.
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

struct PlaceAndRoleWithPeople {
  let placeAndRole: PlaceAndRoleModel
  var people: [PersonViewModel]
}

protocol PlacesAndRolesWithPeopleListPresenterDelegate: class {
  func didReceivePlacesAndRolesWithPeople(_ ownedPlacesWithPeople: [PlaceAndRoleWithPeople],
                                          guestPlacesWithPeople: [PlaceAndRoleWithPeople])
}

protocol PlacesAndRolesWithPeopleListPresenter {
  var ownedPlaceAndRoles: [PlaceAndRoleModel] { get set }
  var guestPlaceAndRoles: [PlaceAndRoleModel] { get set }

  weak var delegate: PlacesAndRolesWithPeopleListPresenterDelegate? { get set }

  func fetchList()
}

class ConcretePlacesAndRolesWithPeopleListPresenter: PlacesAndRolesWithPeopleListPresenter {
  //The PlaceAndRoleModels to use for fetching data
  var ownedPlaceAndRoles: [PlaceAndRoleModel]
  var guestPlaceAndRoles: [PlaceAndRoleModel]

  weak var delegate: PlacesAndRolesWithPeopleListPresenterDelegate?

  //Private queue for locking write access to the fetched places plus people arrays
  fileprivate let privateQueue = DispatchQueue(label: "", attributes: [])

  init(owned: [PlaceAndRoleModel], guest: [PlaceAndRoleModel]) {
    self.ownedPlaceAndRoles = owned
    self.guestPlaceAndRoles = guest
  }

  func fetchList() {
    DispatchQueue.global(qos: .background).async {
      var fetchedOwnedPlacesPlusPeople = [PlaceAndRoleWithPeople]()
      var fetchedGuestPlacesPlusPeople = [PlaceAndRoleWithPeople]()

      //Dispatch group for waiting for all individual fetches to complete
      let dispatchGroup = DispatchGroup()

      //Threadsafe way to manipulate the ownedPlacesPlusPeople array
      let appendToOwnedPlaces = { (placeRoleWithPeople: PlaceAndRoleWithPeople) in
        dispatchGroup.enter()//Enter group for handling people
        self.privateQueue.async {//Enter private queue for manipulating the array
          fetchedOwnedPlacesPlusPeople.append(placeRoleWithPeople)
          dispatchGroup.leave()//Leave group for handling people
        }
      }
      //Threadsafe way to manipulate the guestPlacesPlusPeopleArray
      let appendToGuestPlaces = { (placeRoleWithPeople: PlaceAndRoleWithPeople) in
        dispatchGroup.enter()//Enter group for handling people
        self.privateQueue.async {//Enter private queue for manipulating the array
          fetchedGuestPlacesPlusPeople.append(placeRoleWithPeople)
          dispatchGroup.leave()//Leave group for handling people
        }
      }

      for placeAndRole in self.ownedPlaceAndRoles {
        dispatchGroup.enter()//Enter group for each placeAndRole
        var placeRoleWithPeople = PlaceAndRoleWithPeople(placeAndRole: placeAndRole,
                                                         people: [])
        guard let place = PlaceModel
          .createPlaceModelContainingAddressForModelId(placeAndRole.placeId) else { continue }
        _ = PlaceController.fetchAllPeopleWithRoleForPlace(place)
          .swiftThenInBackground {
            (personViewModels: Any?) -> PMKPromise? in
            if let personViewModels = personViewModels as? [PersonViewModel] {
              // Sort people
              placeRoleWithPeople.people = personViewModels.sorted {
                if let name1 = $0.0.fullName,
                  let name2 = $0.1.fullName {
                    return name1.caseInsensitiveCompare(name2) == .orderedAscending
                }
                return false
              }
            }
            appendToOwnedPlaces(placeRoleWithPeople)
            dispatchGroup.leave()//Leave group for each placeAndRole
            return nil
        }
      }

      for placeAndRole in self.guestPlaceAndRoles {
        dispatchGroup.enter()//Enter group for each placeAndRole
        var placeRoleWithPeople = PlaceAndRoleWithPeople(placeAndRole: placeAndRole, people: [])
        _ = PlaceController.fetchAllPeopleWithRoleForPlace(PlaceModel
          .createPlaceModelContainingAddressForModelId(placeAndRole.placeId)!)
          .swiftThenInBackground {
            (personViewModels: Any?) -> PMKPromise? in
            if let personViewModels = personViewModels as? [PersonViewModel] {
              // Sort people
              placeRoleWithPeople.people = personViewModels.sorted {
                return $0.0.fullName?.caseInsensitiveCompare($0.1.fullName ?? "") == .orderedAscending
              }
            }
            appendToGuestPlaces(placeRoleWithPeople)
            dispatchGroup.leave()//Leave group for each placeAndRole
            return nil
        }
      }

      //Wait for all fetches and processing to complete
      _ = dispatchGroup.wait(timeout: DispatchTime.distantFuture)
      self.delegate?.didReceivePlacesAndRolesWithPeople(fetchedOwnedPlacesPlusPeople,
                                                        guestPlacesWithPeople: fetchedGuestPlacesPlusPeople)
    }
  }
}
