//
//  RxArcusModelCacheLoader.swift
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
import CocoaLumberjack
import RxSwift

public class RxArcusModelCacheLoader: ArcusModelCacheLoader, RxSwiftModelCacheLoader,
  ArcusSceneService, ArcusRuleService, ArcusSchedulerService, ArcusSubsystemService, ArcusProductCatalogService,
ArcusPlaceCapability, ArcusPersonCapability, ArcusAccountCapability, ArcusAlarmSubsystemCapability,
ArcusPairingSubsystemCapability {
  public var status: CacheLoadingStatus = [] {
    didSet {
      DDLogInfo("RxArcusModelCacheLoader.status = \(status)")
      if status == .modelsLoaded {
        isLoading = false
        placeId = nil
      }
      
      // Don't emit duplicate events
      do {
        if try self.statusObservable.value() != status {
          self.statusObservable.onNext(self.status)
        }
      } catch {}
    }
  }
  public var isLoading: Bool = false
  public var placeId: String?

  public var statusObservable: BehaviorSubject<CacheLoadingStatus> =
    BehaviorSubject<CacheLoadingStatus>(value: [])

  public var disposeBag: DisposeBag = DisposeBag()

  // MARK: RxSwift Methods
  // MARK: Observe Settings Events

  func observeSettingsEvents(_ settings: RxSwiftSettings) {
    settings.getEvents()
      .filter { event -> Bool in
        return !(event is CurrentHubChangeEvent)
      }
      .subscribe(
        onNext: { [weak self] event in
          // If event is CurrentSettingsClearedEvent, then clear cache.
          guard event is CurrentSettingsClearedEvent == false else {
            self?.clearModelCache()

            // Legacy Compatibility:  Clear SubsystemsController & SubsystemCache.
            RxCornea.shared.legacyLogic?.clearCurrentUserStates()

            return
          }

          // Only Load Cache or CurrentPlace have changed.
          guard event is CurrentPlaceChangeEvent else {
              return
          }

          // Check that both Account and Place are present.
          guard let account: AccountModel = RxCornea.shared.settings?.currentAccount,
            let place: PlaceModel = RxCornea.shared.settings?.currentPlace else {
              return
          }

          let log: String = "RxArcusModelCacheLoader: fetching model cache with acount: \(account.address)," +
          "place: \(place.address)"
          DDLogInfo(log)

          _ = self?.loadCache(place, account: account)
      })
      .addDisposableTo(disposeBag)
  }

  public func loadCache(_ place: PlaceModel, account: AccountModel) -> Observable<CacheLoadingStatus> {
    let observable: Observable<CacheLoadingStatus> = getStatus()
    let loadForPlaceId: String = place.modelId

    if !isLoading || placeId != loadForPlaceId {
      isLoading = true
      placeId = place.modelId
      fetchModelCache(place, account: account)
    }

    return observable
  }

  // MARK: Clear Methods

  public func clearModelCache() {
    guard let cache = RxCornea.shared.modelCache else { return }
    cache.flush()
    status = []
  }

  // MARK: Fetch Methods

  public func fetchAlarmModels(_ alarmSubsystem: SubsystemModel) {
    try? _ = requestAlarmSubsystemListIncidents(alarmSubsystem)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? AlarmSubsystemListIncidentsResponse else { return }
          self?.processFetchAlarmResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchDeviceModels(_ place: PlaceModel) {
    try? _ = requestPlaceListDevices(place)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? PlaceListDevicesResponse else { return }
          self?.processFetchDeviceResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchPairingDeviceModels(_ subsystem: SubsystemModel) {
    try? _ = self.requestPairingSubsystemListPairingDevices(subsystem)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? PairingSubsystemListPairingDevicesResponse else { return }
          self?.processFetchPairingDeviceResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchHubModel(_ place: PlaceModel) {
    try? _ = requestPlaceGetHub(place)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? PlaceGetHubResponse else { return }
          self?.processFetchHubResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchPersonModels(_ place: PlaceModel) {
    try? _ = requestPlaceListPersons(place)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? PlaceListPersonsResponse else { return }
          self?.processFetchPersonResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchPlaceModels(_ account: AccountModel) {
    try? _ = requestAccountListPlaces(account)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? AccountListPlacesResponse else { return }
          self?.processFetchPlaceResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchProductModels(_ place: PlaceModel) {
    try? _ = requestProductCatalogServiceGetProducts(place.address, include: "ALL", hubRequired: nil)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? ProductCatalogServiceGetProductsResponse else { return }
          self?.processFetchProductResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchRuleModels(_ place: PlaceModel) {
    try? _ = requestRuleServiceListRules(place.modelId)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? RuleServiceListRulesResponse else { return }
          self?.processFetchRuleResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchSceneModels(_ place: PlaceModel) {
    try? _ = requestSceneServiceListScenes(place.modelId)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? SceneServiceListScenesResponse else { return }
          self?.processFetchSceneResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchSchedulerModels(_ place: PlaceModel) {
    try? _ = requestSchedulerServiceListSchedulers(place.modelId, includeWeekdays: false)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? SchedulerServiceListSchedulersResponse else { return }
          self?.processFetchSchedulerResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  public func fetchSubsystemModels(_ place: PlaceModel) {
    RxCornea.shared.legacyLogic?.retrieveSubsystems(forPlaceId: place.modelId)
    try? _ = requestSubsystemServiceListSubsystems(place.modelId)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? SubsystemServiceListSubsystemsResponse else { return }
          self?.processFetchSubsystemResponse(event)
      })
      .addDisposableTo(disposeBag)
  }

  // MARK: Private Methods
  // MARK: Response Handling

  private func processFetchAlarmResponse(_ event: AlarmSubsystemListIncidentsResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventIncidents = event.getIncidents() as? [[String: AnyObject]] {
      let incidents = eventIncidents.map { AlarmIncidentModel(attributes: $0) }
      cache.addModels(incidents)
    }
    status = status.union(.alarmsLoaded)
  }

  private func processFetchDeviceResponse(_ event: PlaceListDevicesResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventDevices = event.getDevices() as? [[String: AnyObject]] {
      let devices = eventDevices.map { DeviceModel(attributes: $0) }
      cache.addModels(devices)
    }
    status = status.union(.devicesLoaded)
  }

  private func processFetchPairingDeviceResponse(_ event: PairingSubsystemListPairingDevicesResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventDevices = event.getDevices() as? [[String: AnyObject]] {
      let devices = eventDevices.map { PairingDeviceModel(attributes: $0) }
      cache.addModels(devices)
    }
    status = status.union(.pairingDevicesLoaded)
  }

  private func processFetchHubResponse(_ event: PlaceGetHubResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }
    
    guard let eventHub = event.getHub() as? [String: AnyObject],
      eventHub.count > 0 else {
        status = status.union(.hubLoaded)
        RxCornea.shared.settings?.currentHub = nil
        return
    }
    let hub = HubModel(attributes: eventHub)
    cache.addModels(hub)
    RxCornea.shared.settings?.currentHub = hub
    status = status.union(.hubLoaded)
  }

  private func processFetchPersonResponse(_ event: PlaceListPersonsResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventPersons = event.getPersons() as? [[String: AnyObject]] {
      let persons = eventPersons.map { PersonModel(attributes: $0) }
      cache.addModels(persons)
    }
    status = status.union(.peopleLoaded)
  }

  private func processFetchPlaceResponse(_ event: AccountListPlacesResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventPlaces = event.getPlaces() as? [[String: AnyObject]] {
      let places = eventPlaces.map { PlaceModel(attributes: $0) }
      cache.addModels(places)
    }
    status = status.union(.placesLoaded)
  }

  private func processFetchProductResponse(_ event: ProductCatalogServiceGetProductsResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventProducts = event.getProducts() as? [[String: AnyObject]] {
      let products = eventProducts.map { ProductModel(attributes: $0) }
      cache.addModels(products)
    }
    status = status.union(.productsLoaded)
  }

  private func processFetchRuleResponse(_ event: RuleServiceListRulesResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventRules = event.getRules() as? [[String: AnyObject]] {
      let rules = eventRules.map { RuleModel(attributes: $0) }
      cache.addModels(rules)
    }
    status = status.union(.rulesLoaded)
  }

  private func processFetchSceneResponse(_ event: SceneServiceListScenesResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventScenes = event.getScenes() as? [[String: AnyObject]] {
      let scenes = eventScenes.map { SceneModel(attributes: $0) }
      cache.addModels(scenes)
    }
    status = status.union(.scenesLoaded)
  }

  private func processFetchSchedulerResponse(_ event: SchedulerServiceListSchedulersResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventSchedulers = event.getSchedulers() as? [[String: AnyObject]] {
      let schedulers = eventSchedulers.map { SchedulerModel(attributes: $0) }
      cache.addModels(schedulers)
    }
    status = status.union(.schedulersLoaded)
  }

  private func processFetchSubsystemResponse(_ event: SubsystemServiceListSubsystemsResponse) {
    guard let cache = RxCornea.shared.modelCache else {
      DDLogError("cache not created before a cache event received")
      return
    }

    if let eventSubsystems = event.getSubsystems() as? [[String: AnyObject]] {
      let subsystems = eventSubsystems.map { SubsystemModel(attributes: $0) }
      cache.addModels(subsystems)

      // Once subsystems have been added to the cache.
      // Go ahead and fetch alarms if alarmSusbsystem is present.
      if let alarmSubsystem: SubsystemModel = subsystems.filter({ element in
        return SubsystemCapabilityLegacy.getName(element) == Constants.alarmSubsystemName
      }).first {
        self.fetchAlarmModels(alarmSubsystem)
      }

      // pairingSubsystem needs the same logic as the alarmSubsystem for Pairing Device Models
      if let pairingSubsystem: SubsystemModel = subsystems.filter({ (element: SubsystemModel) in
        return SubsystemCapabilityLegacy.getName(element) == Constants.pairingSubsystemName
      }).first {
        self.fetchPairingDeviceModels(pairingSubsystem)
      }
    }
    status = status.union(.subsystemsLoaded)
  }
}
