//
//  ModalAlertRoutingDriver.swift
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

extension Constants {
  static let kDismissNotification: String = "DismissModalAlertNotification"
}

extension Notification.Name {
  static let dismissModalAlert = Notification.Name(Constants.kDismissNotification)
}

class ModalAlertRoutingDriver: ArcusRoutingDriver, AlertHandler {
  var isRouting: Bool = true

  var currentPlace: PlaceModel = PlaceModel()

  internal var alertControllers: [AlertController] = []
  internal var activeAlertModalPresenter: ModalAlertPresenter?

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: Life Cycle

  required init(currentPlace: PlaceModel? = RxCornea.shared.settings?.currentPlace) {
    if let currentPlace = currentPlace {
      self.currentPlace = currentPlace
    }

    // Observe Settings Events to determine when the app changes places.
    if let settings = RxCornea.shared.settings as? RxSwiftSettings {
      observeSettingsEvents(settings)
    }

    startAlertControllers()
    observeNotifications()
  }

  func observeSettingsEvents(_ settings: RxSwiftSettings) {
    settings.getEvents()
      .filter {
        return $0 is CurrentPlaceChangeEvent
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        self?.placeModelUpdated()
      })
      .addDisposableTo(disposeBag)
  }

  deinit {
    removeNotficationObservation()
    stopAlertControllers()
  }

  // MARK: Notification Handling

  func observeNotifications() {
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(dismissAlertNotificationReceived(_:)),
                   name: Notification.Name.dismissModalAlert,
                   object: nil)
  }

  func removeNotficationObservation() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func dismissAlertNotificationReceived(_ notification: Notification) {
    dismissModalAlertViewController({})
  }

  func placeModelUpdated() {
    if let place = RxCornea.shared.settings?.currentPlace,
      place.modelId != currentPlace.modelId {
      currentPlace = place
      if activeAlertModalPresenter != nil {
        dismissModalAlertViewController({})
      }
      stopAlertControllers()
      startAlertControllers()
    }
  }

  // MARK: Convenience Methods

  func startAlertControllers() {
    var controllers: [AlertController] = []
    let presmokeAlertController: PresmokeAlertController =
      PresmokeAlertController.init(delegate: self,
                                   currentPlace: currentPlace)

    controllers.append(presmokeAlertController)

    let weatherAlertController: WeatherAlertController =
      WeatherAlertController.init(delegate: self,
                                  currentPlace: currentPlace)

    controllers.append(weatherAlertController)

    alertControllers = controllers
  }

  func stopAlertControllers() {
    for alertController: AlertController in alertControllers {
      alertController.removeAllAlertNotificationObservers()
    }
    alertControllers = []
  }

  // MARK: AlertControllerDelegate

  func showAlertModal(_ modalAlertPresenter: ModalAlertPresenter) {
    let priorityCheck = alertHasPriorityToDisplay(modalAlertPresenter)
    if priorityCheck.hasPriority == true {
      if priorityCheck.requiresDismiss == true {
        self.dismissModalAlertViewController({
          self.presentModalAlertViewController(modalAlertPresenter)
        })
      } else {
        self.presentModalAlertViewController(modalAlertPresenter)
      }
    }
  }

  func presentModalAlertViewController(_ modalAlertPresenter: ModalAlertPresenter) {
    activeAlertModalPresenter = modalAlertPresenter
    if isRouting {
      ApplicationRoutingService.defaultService.showModalAlert(modalAlertPresenter)
    }
  }

  func dismissModalAlertViewController(_ completion: (() -> Void)?) {
    activeAlertModalPresenter = nil
    if isRouting {
      ApplicationRoutingService.defaultService.dismissModals(animated: true, completion: completion)
    }
  }

  func alertHasPriorityToDisplay(_ modalAlertPresenter: ModalAlertPresenter)
  -> (hasPriority: Bool, requiresDismiss: Bool) {
      if activeAlertModalPresenter != nil {
        if modalAlertPresenter.alertIdentifier != activeAlertModalPresenter!.alertIdentifier {
          if modalAlertPresenter.alertPriority.rawValue > activeAlertModalPresenter!.alertPriority.rawValue {
            return (hasPriority: true, requiresDismiss: true)
          } else {
            return (hasPriority: false, requiresDismiss: false)
          }
        } else {
          return (hasPriority: false, requiresDismiss: false)
        }
      }
      return (hasPriority: true, requiresDismiss: false)
  }

  func dismissAlertModal(_ modalAlertPresenter: ModalAlertPresenter) {
    if activeAlertModalPresenter != nil {
      if modalAlertPresenter.alertIdentifier == activeAlertModalPresenter!.alertIdentifier {
        dismissModalAlertViewController({})
      }
    }
  }
}
