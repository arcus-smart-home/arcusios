//
//  RxArcusSettings.swift
//  i2app
//
//  Created by Arcus Team on 10/31/17.
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
import RxSwift
import CocoaLumberjack

public class RxArcusSettings: ArcusSettings,
RxSwiftSettings,
ArcusNotificationConverter,
DeviceTokenController {
  public var currentAccount: AccountModel? {
    didSet {
      let event = CurrentAccountChangeEvent(currentAccount: currentAccount)
      eventObservable.onNext(event)
    }
  }
  public var currentHub: HubModel? {
    didSet {
      let event = CurrentHubChangeEvent(currentHub: currentHub)
      eventObservable.onNext(event)
    }
  }
  public var currentPerson: PersonModel? {
    didSet {
      let event = CurrentPersonChangeEvent(currentPerson: currentPerson)
      eventObservable.onNext(event)
    }
  }
  public var currentPlace: PlaceModel? {
    didSet {
      let event = CurrentPlaceChangeEvent(currentPlace: currentPlace)
      notifyForEvent(event)
      eventObservable.onNext(event)
    }
  }

  public var eventObservable: PublishSubject<ArcusSettingsEvent> = PublishSubject<ArcusSettingsEvent>()
  public var disposeBag: DisposeBag = DisposeBag()

  func observeSessionEvents(_ session: ArcusSession & RxSwiftSession) {
    
    session.getEvents()
      .subscribe(
        onNext: { [weak self] event in
          // If SessionEndedEvent received, clear settings
          guard event is SessionEndedEvent == false else {
            self?.clearSettings()
            return
          }

          // If event is SessionServiceSetActivePlaceResponse, and contains settings ids
          guard let event = event as? SessionServiceSetActivePlaceResponse,
            let placeId = event.getPlaceId() else {
              return
          }

          let accountId = session.sessionInfo?.getPlaceInfo(placeId)?.accountId
          let personId = session.sessionInfo?.personId

          // Configure Settings
          self?.configureSettings(accountId, placeId: placeId, personId: personId)
      })
      .disposed(by: disposeBag)

    session.getEvents()
      .filter { $0 is SessionActivePlaceClearedEvent }
      .map { $0 as? SessionActivePlaceClearedEvent }
      .subscribe(
        onNext: { event in
          guard let eventPlaceId = event?.placeId,
            let currentPlaceId = RxCornea.shared.settings?.currentPlace?.modelId,
            let filteredPlaces = session.sessionInfo?.places?.filter({$0.placeId != eventPlaceId}),
            let nextPlaceId = filteredPlaces.first?.placeId else {
              RxCornea.shared.session?.logout()
              return
          }
          if eventPlaceId == currentPlaceId {
            // If the deleted place is the current Place select a new place
            RxCornea.shared.session?.setActivePlace(nextPlaceId)
          } else {
            // If the deleted place is not current place reselect it as the current place to reload the cache
            // This will prevent the user from selecting the deleted place in the place selection View
            // Delete place does not sent a `base:Deleted` event
            RxCornea.shared.session?.setActivePlace(currentPlaceId)
          }

      })
      .disposed(by: disposeBag)

    session.getEvents()
      .filter({ (event: ArcusSessionEvent) -> Bool in
        guard let res = event as? PlaceRegisterHubV2Response,
          let registrationState = res.getState(),
          registrationState == .registered,
          let progress = res.getProgress(),
          progress == 100 else {
            // no action is needed unless things are complete
            return false
        }
        return true
      })
      .map({ (event: ArcusSessionEvent) -> HubModel in
        // convert response to a hub model
        // swiftlint:disable:next force_cast
        let hubAttributes = (event as! PlaceRegisterHubV2Response).getHub() as! [String: AnyObject]
        return HubModel(attributes: hubAttributes)
      })
      .flatMapLatest({ hubModel in
        // refresh the hub model to set it in the model cache
        return hubModel.refresh(hubModel.address)
      })
      .subscribe(
        onNext: { event in
          if let res = event as? BaseGetAttributesResponse,
            let cache = RxCornea.shared.modelCache as? RxArcusModelCache,
            let hubModel = cache.fetchModel(res.source) as? HubModel {
            self.currentHub = hubModel
          }
       })
      .disposed(by: disposeBag)
  }

  func observeModelCacheEvents(_ cache: ArcusModelCache & RxSwiftModelCache) {
    cache.getEvents()
      .filter {
        return $0 is ModelUpdatedEvent
          && ($0.address == self.currentAccount?.address
            || $0.address == self.currentHub?.address
            || $0.address == self.currentPerson?.address
            || $0.address == self.currentPlace?.address)
      }
      .subscribe(
        onNext: { [weak self] event in
          guard let event = event as? ModelUpdatedEvent else { return }

          if event.address == self?.currentAccount?.address {
            self?.currentAccount?.modelUpdated(event.changes)
          } else if event.address == self?.currentHub?.address {
            self?.currentHub?.modelUpdated(event.changes)
          } else if event.address == self?.currentPerson?.address {
            self?.currentPerson?.modelUpdated(event.changes)
          } else if event.address == self?.currentPlace?.address {
            self?.currentPlace?.modelUpdated(event.changes)
          }
      })
      .addDisposableTo(disposeBag)
    
    cache.getEvents()
      .subscribe(
        onNext: { [weak self] event in
          guard self?.currentHub == nil,
          let event = event as? ModelAddedEvent,
          let hub = event.model as? HubModel else { return }
          self?.currentHub = hub
      })
      .addDisposableTo(disposeBag)

    cache.getEvents()
      .subscribe(
        onNext: { [weak self] event in
          guard self?.currentHub != nil,
            let event = event as? ModelDeletedEvent,
            let hub = event.model as? HubModel,
            hub.address == self?.currentHub?.address else { return }
          self?.currentHub = nil
      })
      .addDisposableTo(disposeBag)
  }

  func configureSettings(_ accountId: String?, placeId: String?, personId: String?) {
    if let accountId: String = accountId {
      initializeCurrentAccount(accountId)
    }

    if let placeId: String = placeId {
      initializeCurrentPlace(placeId)
    }

    if let personId: String = personId {
      initializeCurrentPerson(personId)
    }
  }

  func setCurrentAccount(_ account: AccountModel) {
    _ = account.refresh(account.address)
      .subscribe(
        onNext: { [weak self] event in
          self?.currentAccount = AccountModel(attributes: event.attributes)
      })
      .disposed(by: disposeBag)
  }

  func setCurrentPerson(_ person: PersonModel) {
    person.refreshModel().subscribe(onNext: { [weak self] event in
      self?.currentPerson = PersonModel(attributes: event.attributes)
    }).disposed(by: disposeBag)

    getEvents()
      .filter {
        return $0 is CurrentPersonChangeEvent
      }
      .map {
        return $0 as! CurrentPersonChangeEvent
      }
      .flatMap { _ in
        return self.getDeviceToken()
      }
      .subscribe(onNext: { keychain in
        guard let person = self.currentPerson else {
          return
        }

        RxCornea.shared.legacyLogic?.sendDeviceInfo(person,
                                                    deviceToken: keychain.value)
      }).disposed(by: disposeBag)
  }

  func setCurrentPlace(_ place: PlaceModel) {
    _ = place.refresh(place.address)
      .subscribe(
        onNext: { [weak self] event in
          self?.currentPlace = PlaceModel(attributes: event.attributes)
      })
      .disposed(by: disposeBag)
  }

  // MARK: Private Methods

  private func clearSettings() {
    currentAccount = nil
    currentHub = nil
    currentPerson = nil
    currentPlace = nil

    eventObservable.onNext(CurrentSettingsClearedEvent())
  }

  private func initializeCurrentAccount(_ accountId: String) {
    let accountAddress = Model.addressForNamespace( Constants.accountNamespace, modelId: accountId)
    let initialAccount: AccountModel = AccountModel(attributes: ["base:id": accountId as AnyObject,
                                                                 "base:address": accountAddress as AnyObject])
    setCurrentAccount(initialAccount)
  }

  private func initializeCurrentPerson(_ personId: String) {
    let personAddress = Model.addressForNamespace(Constants.personNamespace, modelId: personId)
    let initialPerson: PersonModel = PersonModel(attributes: ["base:id": personId as AnyObject,
                                                              "base:address": personAddress as AnyObject])
    setCurrentPerson(initialPerson)
  }

  private func initializeCurrentPlace(_ placeId: String) {
    let placeAddress = Model.addressForNamespace(Constants.placeNamespace, modelId: placeId)
    let initialPlace: PlaceModel = PlaceModel(attributes: ["base:id": placeId as AnyObject,
                                                           "base:address": placeAddress as AnyObject])
    setCurrentPlace(initialPlace)
  }
}
