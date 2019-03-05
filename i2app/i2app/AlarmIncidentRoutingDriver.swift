//
//  AlarmIncidentRoutingDriver.swift
//  i2app
//
//  Created by Arcus Team on 2/6/18.
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
import RxSwift

class AlarmIncidentRoutingDriver: ArcusRoutingDriver, AlarmSubsystemController {
  var isRouting: Bool = true
  var subsystemModel: SubsystemModel {
    if let model = SubsystemCache.sharedInstance.alarmSubsystem() {
      return model
    }
    return SubsystemModel()
  }
  var careSubsystemController: CareSubsystemController? = SubsystemsController.sharedInstance().careController
  var disposeBag: DisposeBag = DisposeBag()

  fileprivate var incident: String?

  required init() {
    // Observe Cache Events to determine when the AlarmSubsystem has changed.
    if let cache = RxCornea.shared.modelCache as? RxSwiftModelCache {
      observeModelCacheEvents(cache)
    }

    // Observe Session Events to determine when the app has logged the current user out.
    if let session = RxCornea.shared.session as? RxSwiftSession {
      observeSessionEvents(session)
    }

    // Observe Settings Events to determine when the app changes places.
    if let settings = RxCornea.shared.settings as? RxSwiftSettings {
      observeSettingsEvents(settings)
    }
  }

  func observeModelCacheEvents(_ cache: RxSwiftModelCache) {
    cache.getEvents()
      .filter { [weak self] in
        if self?.subsystemModel.hasAttributes() ?? false {
          // Filter out events not related to Alarm or Care subsystems.
          let careSubsystem = self?.careSubsystemController?.subsystemModel
          
          if careSubsystem != nil {
            return $0.address == self?.subsystemModel.address ||
              $0.address == careSubsystem!.address
          }
          
          return $0.address == self?.subsystemModel.address
        } else {
          return false
        }
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        // Process subsystem change.
        self?.onSubsystemChange()
      })
      .addDisposableTo(disposeBag)
  }

  func observeSessionEvents(_ session: RxSwiftSession) {
    session.getEvents()
      .filter {
        return $0 is SessionEndedEvent
      }
      .subscribe(onNext: { [weak self] _ in
        // Clear current subystem and incidentId
        self?.clearState()
      })
      .addDisposableTo(disposeBag)
  }

  func observeSettingsEvents(_ settings: RxSwiftSettings) {
    settings.getEvents()
      .filter {
        return $0 is CurrentPlaceChangeEvent
      }
      .delay(0.2, scheduler: ConcurrentDispatchQueueScheduler(qos: .utility))
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        self?.onSubsystemChange()
        self?.clearState()
      })
      .addDisposableTo(disposeBag)
  }

  func onSubsystemChange() {
    if let careSubsystemController = SubsystemsController.sharedInstance().careController {
      self.careSubsystemController = careSubsystemController
    }
    updateState()
  }

  func updateState() {
    // If AlarmSubsystem is in PREALERT or ALERT then show Alarm Tracker.
    if self.subsystemModel.hasAttributes(),
      let currentIncident = currentIncident(subsystemModel),
      currentIncident != "",
      incident != currentIncident,
      let state = alarmState(subsystemModel),
      (state == kEnumAlarmSubsystemAlarmStatePREALERT || state == kEnumAlarmSubsystemAlarmStateALERTING) {

      // Update Incident Id
      incident = currentIncident

      if isRouting {
        // Route Tracker to Current Incident.
        ApplicationRoutingService.defaultService.showAlarmIncident(subsystemModel,
                                                                   incidentId: currentIncident)
      }
    } else if let careController = SubsystemsController.sharedInstance().careController,
      careController.isAlarmTriggered {

      if isRouting {
        // Route to Care Alarm.
        ApplicationRoutingService.defaultService.showCareIncident()
      }
    } else if let currentHub = RxCornea.shared.settings?.currentHub, currentHub.isDown == true
      && provider(subsystemModel) == kEnumAlarmSubsystemAlarmProviderHUB {

      if isRouting {
        // Route to Hub Offline Warning.
        ApplicationRoutingService.defaultService.showAlarmOfflineWarning()
      }
    } else if RxCornea.shared.settings?.currentHub == nil && allSwannCamerasOffline() && isRouting {
      ApplicationRoutingService.defaultService.showAlarmOfflineWarning()
    }
  }

  func clearState() {
    careSubsystemController = nil
    incident = nil
  }
  
  private func allSwannCamerasOffline() -> Bool {
    guard let devices = RxCornea.shared.modelCache?.fetchModels(Constants.deviceNamespace) as? [DeviceModel] else {
      return false
    }
    
    let swannCameras = devices.filter { $0.isSwannCamera }
    let offlineSwannCameras = swannCameras.filter { $0.isDeviceOffline() }
    
    return swannCameras.count > 0 && swannCameras.count == offlineSwannCameras.count
  }
}
