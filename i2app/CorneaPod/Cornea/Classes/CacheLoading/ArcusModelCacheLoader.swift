//
//  ArcusModelCacheLoader.swift
//  i2app
//
//  Created by Arcus Team on 12/15/17.
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

public struct ArcusModelCacheLoaderError: Error {
  enum ErrorType {
    case loadingAlreadyInProgress
  }

  let type: ErrorType
}

public protocol ArcusModelCacheLoader {
  var status: CacheLoadingStatus { get }
  var isLoading: Bool { get }

  // The placeId of the place being loaded into cache.
  var placeId: String? { get set }

  func clearModelCache()
  /// fetchModelCache will also call clearModelCache()
  func fetchModelCache(_ place: PlaceModel, account: AccountModel)
  func fetchAlarmModels(_ alarmSubsystem: SubsystemModel)
  func fetchDeviceModels(_ place: PlaceModel)
  func fetchHubModel(_ place: PlaceModel)
  func fetchRuleModels(_ place: PlaceModel)
  func fetchPersonModels(_ place: PlaceModel)
  func fetchPlaceModels(_ account: AccountModel)
  func fetchProductModels(_ place: PlaceModel)
  func fetchSceneModels(_ place: PlaceModel)
  func fetchSchedulerModels(_ place: PlaceModel)
  func fetchSubsystemModels(_ place: PlaceModel)
  func fetchPairingDeviceModels(_ subsystem: SubsystemModel)
}

extension ArcusModelCacheLoader {
  public func fetchModelCache(_ place: PlaceModel, account: AccountModel) {
    clearModelCache()

    fetchDeviceModels(place)
    fetchHubModel(place)
    fetchPersonModels(place)
    fetchPlaceModels(account)
    fetchProductModels(place)
    fetchRuleModels(place)
    fetchSchedulerModels(place)
    fetchSubsystemModels(place)
    fetchSceneModels(place)
  }

  public func clearModelCache() {
    guard let cache = RxCornea.shared.modelCache else { return }
    cache.flush()
  }
}
