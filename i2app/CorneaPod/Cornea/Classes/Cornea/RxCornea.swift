//
//  RxCornea.swift
//  i2app
//
//  Created by Arcus Team on 7/14/17.
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
import PromiseKit
import RxSwift
import UIKit

final public class RxCornea: Cornea {
  public static let shared: RxCornea = RxCorneaFactory.build()

  public var session: ArcusSession?
  public var modelCache: ArcusModelCache?
  public var cacheLoader: ArcusModelCacheLoader?
  public var settings: ArcusSettings?
  public var legacyLogic: ArcusLegacyLogic?

  public required init() {}
  
}

public class CorneaHolder: NSObject {
  public static var shared: CorneaHolder {
    return CorneaHolder(RxCornea.shared)
  }

  internal(set) public var session: SessionHolder?
  internal(set) public var modelCache: CacheHolder?
  internal(set) public var settings: SettingsHolder?

  required public init(_ cornea: RxCornea) {
    super.init()

    if let rxSession = cornea.session as? RxArcusSession {
      self.session = SessionHolder(rxSession)
    }

    if let rxCache = cornea.modelCache as? RxArcusModelCache {
      self.modelCache = CacheHolder(rxCache)
    }

    if let rxSettings = cornea.settings as? RxArcusSettings {
      self.settings = SettingsHolder(rxSettings)
    }
  }
}

public class SessionHolder: NSObject {
  internal(set) public var session: RxArcusSession

  public var sessionInfo: SessionInfo? {
    guard let info = session.sessionInfo as? SessionInfo else { return nil }
    return info
  }

  required public init(_ session: RxArcusSession) {
    self.session = session

    super.init()
  }

  public func login(_ username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    session.login(username, password: password, completion: completion)
  }

  public func logout() {
    session.logout()
  }

  public func connect() {
    session.connect()
  }

  public func suspend() {
    session.suspend()
  }

  public func resume() {
    session.resume()
  }

  public func setActivePlaceWithSuspendedRouting(_ placeId: String) {
    RxCornea.shared.legacyLogic?.suspendCacheLoadRouting()
    setActivePlace(placeId)
  }

  public func setActivePlace(_ placeId: String) {
    session.setActivePlace(placeId)
  }

  public func fetchCameraPreview(_ cameraId: String, placeId: String) -> PMKPromise {
    return PMKPromise.new {
      (fulfiller: PMKFulfiller!, rejecter: PMKRejecter!) in
      self.session.fetchCameraPreview(cameraId, placeId: placeId, completion: {
        data, error in
        if data != nil && error == nil {
          fulfiller(data)
        } else {
          rejecter(error)
        }
      })
    }
  }
}

public class CacheHolder: NSObject {
  internal(set) public var modelCache: RxArcusModelCache

  required public init(_ modelCache: RxArcusModelCache) {
    self.modelCache = modelCache

    super.init()
  }

  public func addModel(_ model: Model) {
    modelCache.addModel(model)
  }

  public func addModels(_ models: [Model]) {
    modelCache.addModels(models)
  }

  public func addModels(_ models: Model...) {
    modelCache.addModels(models)
  }

  public func updateModel(_ address: String, changes: [String: AnyObject]) {
    modelCache.updateModel(address, changes: changes)
  }

  public func deleteModel(_ address: String) {
    modelCache.deleteModel(address)
  }

  public func fetchModel(_ address: String) -> Model? {
    return modelCache.fetchModel(address) as? Model
  }

  public func fetchModels(_ namespace: String) -> [Model]? {
    return modelCache.fetchModels(namespace) as? [Model]
  }

  public func flush() {
    modelCache.flush()
  }

  public func oldModelsDictionary() -> [String: AnyObject] {
    return modelCache.oldModelsDictionary
  }
}

public class SettingsHolder: NSObject {
  internal(set) public var settings: RxArcusSettings

  required public init(_ settings: RxArcusSettings) {
    self.settings = settings

    super.init()
  }

  public func currentAccount() -> AccountModel? {
    return settings.currentAccount
  }

  public func currentHub() -> HubModel? {
    return settings.currentHub
  }

  public func currentPerson() -> PersonModel? {
    return settings.currentPerson
  }

  public func currentPlace() -> PlaceModel? {
    return settings.currentPlace
  }

  // MARK: Acccount/Person Registration

  //  func currentAccountState() -> AccountState
  public func userHasFinishedRegisteringAccount() -> Bool {
    return settings.userHasFinishedRegisteringAccount()
  }

  public func userHasFinishedRegisteringPerson() -> Bool {
    return settings.userHasFinishedRegisteringPerson()
  }

  // MARK: Service Level

  public func isPremiumAccount() -> Bool {
    return settings.isPremiumAccount()
  }

  public func isProMonitoredAccount() -> Bool {
    return settings.isProMonitoredAccount()
  }

  public func isAddressGeoPrecisionEnabled() -> Bool {
    return settings.isAddressGeoPrecisionEnabled()
  }

  // MARK: Tutorials

  public func displayClimateTutorial() -> Bool {
    return settings.displayClimateTutorial()
  }

  public func displayRulesTutorial() -> Bool {
    return settings.displayRulesTutorial()
  }

  public func displayScenesTutorial() -> Bool {
    return settings.displayScenesTutorial()
  }

  public func displaySecurityTutorial() -> Bool {
    return settings.displaySecurityTutorial()
  }

  public func displayChoosePlaceTutorial() -> Bool {
    return settings.displayChoosePlaceTutorial()
  }

  public func displayHistoryTutorial() -> Bool {
    return settings.displayHistoryTutorial()
  }

  public func setDoNotShowClimateTutorial(_ dontShow: Bool) {
    settings.setDoNotShowClimateTutorial(dontShow)
  }

  public func setDoNotShowRulesTutorial(_ dontShow: Bool) {
    settings.setDoNotShowRulesTutorial(dontShow)
  }

  public func setDoNotShowScenesTutorial(_ dontShow: Bool) {
    settings.setDoNotShowScenesTutorial(dontShow)
  }

  public func setDoNotShowSecurityTutorial(_ dontShow: Bool) {
    settings.setDoNotShowSecurityTutorial(dontShow)
  }

  public func setDoNotShowChoosePlaceTutorial(_ dontShow: Bool) {
    settings.setDoNotShowChoosePlaceTutorial(dontShow)
  }

  public func setDoNotShowHistoryTutorial(_ dontShow: Bool) {
    settings.setDoNotShowHistoryTutorial(dontShow)
  }

}
