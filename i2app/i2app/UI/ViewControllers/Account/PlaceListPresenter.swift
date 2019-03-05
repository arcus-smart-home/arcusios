//
//  PlaceListPresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/6/16.
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

protocol PlaceListPresenterDelegate: class {
  func didReceivePlaceList(_ placeList: [PlaceAndRoleModel], presenter: PlaceListPresenter)
}

class PlaceListPresenter: NSObject {
  weak var delegate: PlaceListPresenterDelegate?

  var placeList: [PlaceAndRoleModel] = []
  var currentPlace: PlaceAndRoleModel?
  fileprivate var cachedSelectedIndex: Int = -1

  // MARK: Initialization
  required init(delegate: PlaceListPresenterDelegate) {
    self.delegate = delegate
  }

  func setCurrentPlaceFromIndex(_ selectedIndex: Int) {
    if self.placeList.indices.contains(selectedIndex) {
      self.currentPlace = self.placeList[selectedIndex]
    } else {
      self.currentPlace = nil
    }
  }

  func selectedIndex() -> Int {
    var selectedIndex: Int = -1

    if self.currentPlace != nil {
      for place: PlaceAndRoleModel in self.placeList where place.placeId == self.currentPlace?.placeId {
        selectedIndex = self.placeList.index(of: place)!
        break
      }
    }

    if selectedIndex > -1 {
      self.cachedSelectedIndex = selectedIndex
    } else {
      // Current Person has been deleted
      self.cachedSelectedIndex -= 1
      selectedIndex = self.cachedSelectedIndex
      self.setCurrentPlaceFromIndex(selectedIndex)
    }

    return selectedIndex
  }

  // MARK: Data I/O
  func fetchPlaceList() {
    DispatchQueue.global(qos: .background).async {
      // TODO:  Refactor to conform to protocol instead.
      _ = SessionController.listAvailablePlaces()
        .swiftThen { (anyResponse: Any?) -> (PMKPromise?) in
          if let availablePlaces: [PlaceAndRoleModel] =
            anyResponse as? [PlaceAndRoleModel] {
            self.placeList = availablePlaces
            self.fetchPromMonSettings(availablePlaces)
            self.delegate?.didReceivePlaceList(self.placeList, presenter: self)
          }
          return nil
      }
    }
  }

  func fetchPromMonSettings(_ availablePlaces: [PlaceAndRoleModel]) {
    for place in availablePlaces {
      let address = ProMonitoringSettingsModel.addressForId(place.placeId)
      let _ = ProMonitoringSettingsModel(attributes: [kAttrAddress: address as AnyObject]).refresh(address)
    }
  }
}
