//
//  SelectionPersonPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/13/17.
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

protocol SelectionPersonPresenterDelegate: class {

  /// Called on the Main Thread
  func updateLayout()
}

/// Presenter that will expose to its delegate a list of persons
protocol SelectionPersonPresenterProtocol {

  /// delegate that is called when data changes
  var delegate: SelectionPersonPresenterDelegate! { get set }

  /// persons that should be displayed, updateLayout is called when this is changed
  var persons: [PersonModel]? { get }

  /// handles background fetching of persons
  func fetchPersons()
}

class SelectionPersonPresenter: SelectionPersonPresenterProtocol {

  weak var delegate: SelectionPersonPresenterDelegate!
  fileprivate(set) var persons: [PersonModel]?
  fileprivate var place: PlaceModel

  init(delegate incDelegate: SelectionPersonPresenterDelegate,
       place incPlace: PlaceModel) {
    delegate = incDelegate
    place = incPlace
  }

  func fetchPersons() {
    guard let place = RxCornea.shared.settings?.currentPlace else {
      return
    }
    DispatchQueue.global(qos: .background).async {
      _ = PersonController.listPersons(for: place )
        .swiftThen { res in
          guard let values = RxCornea.shared.modelCache?
            .fetchModels(PersonCapability.namespace()) as? [PersonModel] else {
              return nil
          }
          self.persons = values
          self.delegate.updateLayout()
          return nil
      }
    }
  }
}
