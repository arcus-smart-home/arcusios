//
//  PlaceController.swift
//  i2app
//
//  Created by Arcus Team on 5/27/16.
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
import PromiseKit
import Cornea

class PlaceController: NSObject {

  static func fetchAllPeopleWithRoleForPlace(_ place: PlaceModel) -> PMKPromise {
    var persons: [AnyObject]? = []
    var pending: [AnyObject]? = []
    let promise = PlaceCapability.listPersonsWithAccess(on: place)
      .swiftThenInBackground { (anyResponse: Any?) -> (PMKPromise?) in
        if let response = anyResponse as? PlaceListPersonsWithAccessResponse {
          if response.getPersons() != nil {
            persons = response.getPersons() as [AnyObject]?
          }
        }
        return PlaceCapability.pendingInvitations(on: place)
      }
      .swiftThen { (anyResponse: Any?) -> (PMKPromise?) in
        if let response: PlacePendingInvitationsResponse = anyResponse as? PlacePendingInvitationsResponse {
          if response.getInvitations() != nil {
            pending = response.getInvitations() as [AnyObject]?
          }
        }

        let personViewModels = self.personViewModelsForPersonModels(persons!, pendingArray: pending!)

        return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(personViewModels)
        }
    }
    return promise
  }

  fileprivate static func personViewModelsForPersonModels(_ personArray: [AnyObject],
                                                          pendingArray: [AnyObject]) -> [PersonViewModel] {
    var personViewModelList: [PersonViewModel] = [PersonViewModel]()
    for personInfo in personArray {
      guard let attributes = personInfo["person"] as? [String: AnyObject],
        let role = personInfo["role"] as? String else { continue }

      let person = PersonModel(attributes: attributes)

      // Need to add the person to modelCache
      RxCornea.shared.modelCache?.addModel(person)

      personViewModelList.append(PersonViewModel.init(personModel: person,
                                                      role: role))
    }

    for pendingInfo in pendingArray {
      personViewModelList.append(PersonViewModel.init(pendingInfo: pendingInfo))
    }

    return personViewModelList
  }

}
