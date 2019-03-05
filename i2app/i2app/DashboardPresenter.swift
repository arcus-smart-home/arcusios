//
//  DashboardPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/14/16.
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

let kAlarmUpgradeSegue = "ShowUpgradeAlarmSegue"
let kCancelLegacySegue = "ShowLegacyCancelSegue"
let kAlarmSubsystemSegue = "AlarmSubystemSegue"

// MARK: DashboardPresenterProtocol
protocol DashboardPresenterProtocol: class {
  var headerImage: UIImage { get set }
  var currentPlaceName: String { get set }
  var viewModels: [DashboardCardViewModel] { get set }
  var hasMultiplePlaces: Bool { get set }
  weak var delegate: DashboardPresenterDelegate? { get set }

  func viewModelIndexForType(_ type: DashboardCardType) -> Int
  func updatePlaceForId(_ placeId: String)
  func removeDashboardObservers()
  func numberOfHistoryItems() -> Int
  func collectData()
  func startObserving()
  func stopObserving()
  func isAccountJustCreated() -> Bool
  func saveAccountCreation()
  func alarmSegueIdentifier() -> String?
  func tutorialTypeNeeded() -> TuturialType
}

// MARK: DashboardPresenterDelegate
protocol DashboardPresenterDelegate: class {
  func shouldPresentLoadingScreen()
  func shouldHideLoadingScreen()
  func shouldPresentTNCViewController()
  func shouldUpdateViews()
  func shouldUpdateHeaderElements()
  func shouldUpdateCards()
  func shouldUpdateCardAtIndex(_ index: IndexPath)
  func shouldPresentPeopleDetailViewController(_ viewController: PeopleDetailViewController)
  func shouldDismissViewController()
  func shouldShowLegacyAlarmCancel()
  func shouldShowChangingPlaceOverlay(_ loadingText: String?)
  func shouldDismissChangePlaceOverlay()
}

// MARK: DashboardPresenter
class DashboardPresenter: NSObject, BatchNotificationObserver, ArcusPlaceCapability {

  // MARK: Delegates
  weak var delegate: DashboardPresenterDelegate?

  // MARK: General Data
  var premiumAccountIndicator = false
  var hasMultiplePlaces = false
  var placeModalModels: [ArcusModalSelectionModel] = []
  var alarmSubsystem: SubsystemModel = SubsystemModel()

  // MARK: Header
  var headerImage: UIImage = UIImage()
  var currentPlaceName: String = ""

  // MARK: Cards Data
  var viewModels: [DashboardCardViewModel] = []
  var isObservingPrimaryThermoAddress: Bool = false

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: Functions
  init(delegate: DashboardPresenterDelegate) {
    self.delegate = delegate
    var legacyCheck: Bool = false
    if let alarmSubsystem: SubsystemModel = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.alarmSubsystem = alarmSubsystem
      legacyCheck = true
    }
    super.init()

    if legacyCheck {
      if legacyAlarmActiveBeforeUpgrade(self.alarmSubsystem) {
        delegate.shouldShowLegacyAlarmCancel()
      }
    }

    // Observe Place Changes
    guard let loader = RxCornea.shared.cacheLoader as? RxSwiftModelCacheLoader,
      let settings = RxCornea.shared.settings as? RxSwiftSettings else {
        return
    }
    observePlaceChanges(loader, settings: settings)
  }

  fileprivate var isObserving = false

  func viewModelIndexForType(_ type: DashboardCardType) -> Int {
    for (index, viewModel) in viewModels.enumerated() where viewModel.type == type {
      return index
    }

    return NSNotFound
  }

  func startObserving() {
    if !isObserving {
      isObserving = true
      observeUpdates()
    }
  }

  func stopObserving() {
    if isObserving {
      removeDashboardObservers()
      isObserving = false
    }
  }

  func handleFavoritesNotification() {
    fetchDashboardFavorites()
  }

  func fetchData(_ allData: Bool = false) {
    // Make sure the subsystem model is updated  before fetching data.
    if let alarmSubsystem: SubsystemModel = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.alarmSubsystem = alarmSubsystem
    }

    // TODO: Refactor Presenter to conform to protocol instead of using class.
    if SessionController.needsTermsAndConditionsConsent() {
      delegate?.shouldPresentTNCViewController()
    }

    // The card order must be fetched first
    fetchDashboardCardViewModelsArray()

    // Update service status
    if let settings: ArcusSettings =  RxCornea.shared.settings {
      premiumAccountIndicator = settings.isPremiumAccount()
    }

    // Only fetch the following data items when all the data is needed.
    if allData {
      fetchDashboardFavorites()
      fetchDashboardHistory()
      fetchDashboardPlaces()
    }

    // Fetching of sub
    fetchDashboardAlarms()
    fetchDashboardCameras()
    fetchDashboardCare()
    fetchDashboardClimate()
    fetchDashboardDoorsLocks()
    fetchDashboardHomeFamily()
    fetchDashboardLawnGarden()
    fetchDashboardLightsSwitches()
    fetchDashboardWater()
  }

  // MARK: Place Change Observing.

  /**
   Subscribe to observable event from `RxSwiftModelCacheLoader` & `RxSwiftSettings` in order to detect when a
   place change has been triggered and completed:  On initiation of place change, `CurrentPlaceChangeEvent`
   will be published by `RxSwiftSettings`, and on completion of the change `CacheLoadingStatus` will be
   published by `RxSwiftModelCacheLoader`.

   - Parameters:
   - cacheLoader: `RxSwiftModelCacheLoader` that can be used to subscribe to `ArcusModelCacheLoaderStatus`
      observable.
   - settings: `RxSwiftSetting` that can be use to subscribe to `ArcusSettingsEvent` observable.
   */
  func observePlaceChanges(_ cacheLoader: RxSwiftModelCacheLoader, settings: RxSwiftSettings) {
    settings.getEvents()
      .filter { event -> Bool in
        return event is CurrentPlaceChangeEvent
      }
      .subscribe(onNext: { [weak self] _ in
        self?.handlePlaceChangeEvent()
      })
      .addDisposableTo(disposeBag)

    cacheLoader.getStatus()
      .subscribe(onNext: { [weak self] status in
        guard status.contains(CacheLoadingStatus.modelsLoadedExcludeProductCatalogAlarms) else {
          return
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0, execute: {
          self?.updatePlaceResponseReceived()
        })
      })
      .addDisposableTo(disposeBag)
  }

  // MARK: Private
  
  private func handlePlaceChangeEvent() {
    let placeName = retrieveCurrentPlaceName()
    
    // Show Loading View
    let switchText = placeName.isEmpty ? "a new Place" : placeName
    var loadingText: String = "Switching to \"\(switchText)\""
    
    if placeName == currentPlaceName {
      let placeText = placeName.isEmpty ? "Current Place" : placeName
      loadingText = "Loading \"\(placeText)\""
    }
    
    delegate?.shouldShowChangingPlaceOverlay(loadingText)
  }
  
  fileprivate func retrieveCurrentPlaceName() -> String {
    guard let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace else {
      return ""
    }
    
    return getPlaceName(currentPlace) ?? ""
  }

  fileprivate func fetchNotifications() -> [String] {
    let result: [String] = [
      Notification.Name.subsystemInitialized.rawValue,
      Notification.Name.subsystemUpdated.rawValue,
      kAttrClimateSubsystemPrimaryThermostat,
      kAttrClimateSubsystemHumidity,
      kAttrCamerasSubsystemCameras,
      Notification.Name.activePlaceCleared.rawValue,
      kEvtDeviceOtaFirmwareUpdateProgress,
      "DashboardCardOrderSaved",
      kCardOrderupdated,
      kAttrWaterSubsystemPrimaryWaterHeater,
      Model.attributeChangedNotification(kAttrWaterHeaterHeatingstate),
      Model.attributeChangedNotification(kAttrWaterHeaterSetpoint),
      Model.attributeChangedNotification(kAttrWaterHeaterHotwaterlevel),
      Model.attributeChangedNotification(kAttrWaterSoftenerCurrentSaltLevel)
    ]
    return result
  }

  fileprivate func alarmSubsystemNotifications() -> [String] {
    let result: [String] = [
      Notification.Name.subsystemCacheInitialized.rawValue,
      Notification.Name.subsystemCacheUpdated.rawValue,
      Notification.Name.activeAlarmIncidentChanged.rawValue,
      kAttrAlarmSubsystemSecurityMode,
      "AlarmSubsystemUpdated"
      ] + fetchNotifications() // Added fetch notifications to help avoid race condition.
    return result
  }

  fileprivate func observeUpdates() {
    // Add Notifications
    observeBatchNotifications(fetchNotifications(),
                              selector: #selector(DashboardPresenter.fetchData))

    observeBatchNotifications(
      alarmSubsystemNotifications(),
      selector: #selector(DashboardPresenter.alarmSubsystemNotification(_:)))

    observeBatchNotifications([Model.attributeChangedNotification(kAttrHubState),
                               Model.attributeChangedNotification(kAttrHubPowerSource)],
                              selector: #selector(DashboardPresenter.updateDelegate))

    FavoriteOrderedManager.shareInstance().listenNotification(
      self, selector: #selector(DashboardPresenter.handleFavoritesNotification))

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updatePlaceResponseReceived),
                                           name: Notification.Name(rawValue: "NotificationPlaceChange"),
                                           object: nil)
  }

  fileprivate func populateHeaderData() {
    DispatchQueue.main.async { [weak self] in
      guard let settings: ArcusSettings = RxCornea.shared.settings else { return }

      if let modelId: String = settings.currentPlace?.modelId,
        let image: UIImage = settings.fetchHomeImage(modelId) {
        self?.headerImage = image
      }

      self?.currentPlaceName = self?.retrieveCurrentPlaceName() ?? ""
    }
  }
}

// MARK: DashboardPresenterProtocol
extension DashboardPresenter: DashboardPresenterProtocol {
  func collectData() {
    // Populate data that does not need fetching
    populateHeaderData()

    fetchData(true)

    updateDelegate()
  }

  func tutorialTypeNeeded() -> TuturialType {
    if let placesWithPin: [Any] = PersonCapability
      .getPlacesWithPin(from: RxCornea.shared.settings?.currentPerson),
      placesWithPin.count > 1 {
      return TuturialType.choosePlaces
    }

    return TuturialType.intro
  }

  func isAccountJustCreated() -> Bool {
    return UserDefaults.standard.bool(forKey: "accountJustCreated")
  }

  func saveAccountCreation() {
    UserDefaults.standard.set(false, forKey: "accountJustCreated")
  }

  func numberOfHistoryItems() -> Int {
    let index: Int = viewModelIndexForType(.History)

    if index != NSNotFound {
      if let history = viewModels[index] as? DashboardHistoryViewModel {
        return history.historyEntries.count
      }
    }

    return 0
  }

  func updatePlaceForId(_ placeId: String) {
    if placeId != RxCornea.shared.settings?.currentPlace?.modelId,
      let person: PersonModel = RxCornea.shared.settings?.currentPerson {
      DispatchQueue.global(qos: .background).async {
        _ = AccountController.changeToPlaceId(placeId, person: person)
          .swiftThenInBackground({
            _ in
            self.updatePlaceResponseReceived()
            return nil
          })
      }
    }
  }

  func updatePlaceResponseReceived() {
    guard let settings: ArcusSettings = RxCornea.shared.settings,
      let modelId = settings.currentPlace?.modelId else {
        return
    }

    if let image: UIImage = settings.fetchHomeImage(modelId) {
      headerImage = image
    }

    currentPlaceName = retrieveCurrentPlaceName()
    
    fetchDashboardHistory()
    fetchDashboardPlaces()

    delegate?.shouldHideLoadingScreen()
    delegate?.shouldUpdateHeaderElements()
    delegate?.shouldDismissChangePlaceOverlay()
  }

  func updateDelegate() {
    delegate?.shouldUpdateViews()
  }

  func removeDashboardObservers() {
    NotificationCenter.default.removeObserver(self)
  }

  func alarmSegueIdentifier() -> String? {
    if let alarmSubsystem: SubsystemModel = SubsystemCache.sharedInstance.alarmSubsystem() {
      if isSubsystemSuspended(alarmSubsystem) {
        return "ShowUpgradeAlarmSegue"
      } else {
        return "AlarmSubystemSegue"
      }
    }
    return nil
  }
}

// MARK: DashboardProvider
extension DashboardPresenter: DashboardProvider, DashboardAlarmsProvider,
  DashboardCamerasProvider, DashboardCareProvider, DashboardClimateProvider,
  DashboardDoorsLocksProvider, DashboardFavoritesProvider, DashboardHistoryProvider,
  DashboardHomeFamilyProvider, DashboardLawnGardenProvider,
DashboardLightsSwitchesProvider, DashboardWaterProvider {
  func storeViewModel(_ viewModel: DashboardCardViewModel) {
    DispatchQueue.main.async {
      let indexForType: Int = self.viewModelIndexForType(viewModel.type)
      if indexForType != NSNotFound &&
        indexForType < self.viewModels.count &&
        !viewModel.isEquals(self.viewModels[indexForType]) {
        self.viewModels[indexForType] = viewModel
        self.delegate?.shouldUpdateCards()
      }
    }
  }
}

// MARK: DashboardCardOrderProvider
extension DashboardPresenter: DashboardCardOrderProvider {
  func fetchCompletedDashboardCardViewModelsArray(_ viewModels: [DashboardCardViewModel]) {
    self.viewModels = viewModels
    updateDelegate()
    delegate?.shouldUpdateCards()
  }
}

// MARK: DashboardPlacesProvider
extension DashboardPresenter: DashboardPlacesProvider {
  func fetchCompletedDashboardPlaces(_ placeModalModels: [ArcusModalSelectionModel]) {
    self.placeModalModels = placeModalModels

    updateDelegate()
  }
}

// MARK: Place Removed/ Access Removed - handling
extension DashboardPresenter: UserAuthenticationController {

  func accessRemoveNotificationReceived(_ notification: Notification) {
    guard let info = notification.object as? [String: AnyObject],
      let attributes = info["attributes"] as? [String: AnyObject],
      let placeId = attributes["placeId"] as? String else {
        return
    }

    if let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace,
      currentPlace.modelId == placeId {
      DispatchQueue.global(qos: .background).async {
        // TODO: Refactor Presenter to conform to protocol instead of using class.
        _ = SessionController.listAvailablePlaces().swiftThenInBackground({
          modelAnyObject in

          guard let models = modelAnyObject as? [PlaceAndRoleModel] else {
            return nil
          }

          var ownedPlaceId: String = ""

          for model in models {
            if model.role == String(PlaceAndRoleModel.ownerString) {
              ownedPlaceId = model.placeId
            }
          }

          if ownedPlaceId.isEmpty {
            self.logout({})
          } else {
            self.updatePlaceForId(ownedPlaceId)
          }

          return nil
        })
      }
    }
  }
}

// MARK: AlarmSubsystemController
extension DashboardPresenter: AlarmSubsystemController {

  @objc func alarmSubsystemNotification(_ note: Notification) {
    guard let alarmSubsystem: SubsystemModel = SubsystemCache.sharedInstance.alarmSubsystem() else {
      return
    }
    self.alarmSubsystem = alarmSubsystem

    if legacyAlarmActiveBeforeUpgrade(self.alarmSubsystem) {
      delegate?.shouldShowLegacyAlarmCancel()
    }

    fetchDashboardAlarms()
  }
}

extension DashboardPresenter: UpgradeLegacySubsystemProvider {

}
