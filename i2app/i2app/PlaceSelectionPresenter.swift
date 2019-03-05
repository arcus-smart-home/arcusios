//
//  PlaceSelectionPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/18/17.
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

import RxSwift
import Cornea

/**
 API to fetch and switch places.
 */
protocol PlaceSelectionPresenterProtocol {
  
  /**
   Delegate used for callbacks.
   */
  var delegate: PlaceSelectionPresenterDelegate? { get set }
  
  /**
   Data models representing the available places.
   */
  var placesAvailable: [PlaceSelectionViewModel] { get set }
  
  // MARK: Extended
  
  /**
   Fetches the available places for the current user.
   */
  func fetchPlaces()
  
  /**
   Switches the current place to the place with the given Id.
   */
  func changePlace(withPlaceId placeId: String)
}

/**
 Delegate used for transaction callbacks.
 */
protocol PlaceSelectionPresenterDelegate: class {
  
  /**
   Called when available places are ready.
   */
  func shouldUpdatePlaces()
  
  /**
   Called after successfully changing a place.
   */
  func placeChangeDidSucceed()
  
  /**
   Called after failing to change a place.
   */
  func placeChangeDidFail()
  
}

/**
 Presenter used to fetch the available places for place selection.
 */
class PlaceSelectionPresenter {
  weak var delegate: PlaceSelectionPresenterDelegate?
  var placesAvailable = [PlaceSelectionViewModel]()
  fileprivate let disposeBag = DisposeBag()
  
  required init(delegate: PlaceSelectionPresenterDelegate) {
    self.delegate = delegate
  }

  // MARK: Helpers

  fileprivate func updateHighlightedPlace(withPlaceId placeId: String) {
    var places = [PlaceSelectionViewModel]()
    for place in placesAvailable {
      var newPlace = place

      if place.identifier == placeId {
        newPlace.isSelected = true
      } else {
        newPlace.isSelected = false
      }

      places.append(newPlace)
    }
    DispatchQueue.main.async {
      self.placesAvailable = places
      self.delegate?.shouldUpdatePlaces()
    }
  }
}

// MARK: PlaceSelectionPresenterProtocol

extension PlaceSelectionPresenter: PlaceSelectionPresenterProtocol {
  
  func fetchPlaces() {
    DispatchQueue.global(qos: .background).async {
      _ = SessionController.listAvailablePlaces()
        .swiftThenInBackground({ modelAnyObject in
          
          var places = [PlaceSelectionViewModel]()
          
          if let models = modelAnyObject as? [PlaceAndRoleModel] {
            for model in models {
              var place = PlaceSelectionViewModel()
              place.identifier = model.placeId
              place.title = model.placeName
              place.description = model.placeLocation()
              
              if let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace {
                let isSelected = model.placeId == currentPlace.modelId as String
                place.isSelected = isSelected
              }
              
              if let settings: ArcusSettings = RxCornea.shared.settings,
                let image = settings.fetchHomeImage(model.placeId) {
                place.image = image
              }
              
              places.append(place)
            }
          }
          
          DispatchQueue.main.async {
            self.placesAvailable = places
            self.delegate?.shouldUpdatePlaces()
          }
          
          return nil
        })
    }
  }
  
  func changePlace(withPlaceId placeId: String) {
    updateHighlightedPlace(withPlaceId: placeId)

    if placeId != RxCornea.shared.settings?.currentPlace?.modelId {
      RxCornea.shared.session?.setActivePlace(placeId)
      guard let settings = RxCornea.shared.settings as? RxSwiftSettings else {
        return
      }

      var disposable: Disposable?
      disposable = settings.getEvents()
        .filter { (element) -> Bool in
          return element is CurrentPlaceChangeEvent
        }
        .subscribe(
          onNext: { [weak self] _ in
            DispatchQueue.main.async {
              RxCornea.shared.session?.sessionInfo?.lastKnownPlaceId = placeId
              self?.delegate?.placeChangeDidSucceed()
            }
            disposable?.dispose()
        })
      disposable?.addDisposableTo(disposeBag)
    }
  }

}
