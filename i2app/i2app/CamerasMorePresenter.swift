//
//  CamerasMorePresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/22/17.
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

/**
 `CamerasMoreTabPresenter` protocol
 */
protocol CamerasMoreTabPresenter {
  var options: [CamerasMoreOptionViewModel] { get }
  weak var delegate: CamerasMoreTabDelegate? { get set }

  /**
   Performs the action specified by the viewModel.

   - Parameter viewModel: The `CamerasMoreOptionViewModel` chosen to determine the action
   to perform.
   */
  func performAction(_ viewModel: CamerasMoreOptionViewModel)

  /**
   Prepare a viewController to be presented.  Used to configure a ViewController that will
   be presented from a segue specified by a viewModel.

   - Parameter viewController: The UIViewController to prepare.
   */
  func prepareDesination(_ viewController: UIViewController)
}

/**
 `CamerasMoreTabDelegate` protocol
 */
protocol CamerasMoreTabDelegate: class {
  /**
   Used to update the layout of `CamerasMoreTabDelegate`.
   */
  func updateLayout()

  /**
   Used to have CamerasMoreTabDelegate perform a specified segue.

   - Parameter identifier: The string of the segue to perform.
   */
  func performSegue(_ identifier: String)

  /**
   Used to have CamerasMoreTabDelegate present a specified viewController.

   - Parameter viewController: The UIViewController to be preseneted.
   */
  func present(_ viewController: UIViewController?)
}

class CamerasMorePresenter: CamerasMoreTabPresenter, AlarmSubsystemController {
  var options: [CamerasMoreOptionViewModel] {
    return [CamerasMoreViewModel("Video Storage",
                                 description: "Manage Your Video Clips",
                                 actionType: .segue,
                                 actionIdentifier: determineActionIdentifier(),
                                 cellIdentifier: "CameraMoreSegueCell",
                                 metaData: nil),
            CamerasMoreViewModel("Record Security Alarm",
                                 description: "Initiate a recording of all Cameras "
                                  + "upon a triggered security Alarm. "
                                  + "Battery powered cameras can only "
                                  + "record for a short duration unless motion is detected.",
                                 actionType: .toggle,
                                 actionIdentifier: "ToggleRecordOnSecurityAlarm",
                                 cellIdentifier: "CameraMoreToggleCell",
                                 metaData: ["toggleState": shouldRecordSecurityAlarm() as AnyObject])]
  }

  weak var delegate: CamerasMoreTabDelegate?

  required init(delegate: CamerasMoreTabDelegate?) {
    self.delegate = delegate
    self.delegate?.updateLayout()
    observeNotifications()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func determineActionIdentifier() -> String {
    // If settings isn't available, return the basic segue
    guard let settings = RxCornea.shared.settings else { return "CameraMoreVideoStorageBasicSegue" }
    
    var segue = ""
    
    if settings.isProMonitoredAccount() {
      segue = "CameraMoreVideoStoragePromonSegue"
    } else if settings.isPremiumAccount() {
      segue = "CameraMoreVideoStoragePremiumSegue"
    } else {
      segue = "CameraMoreVideoStorageBasicSegue"
    }
    return segue
  }

  private func observeNotifications() {
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CamerasMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheInitialized,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CamerasMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheUpdated,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CamerasMorePresenter.alarmSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheCleared,
                   object: nil)  }

  @objc private func alarmSubsystemNotification(_ note: Notification) {
    DispatchQueue.main.async {
      self.delegate?.updateLayout()
    }
  }

  func shouldRecordSecurityAlarm() -> Bool {
    guard let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() else {
      return false
    }
    return getRecordOnSecurity(alarmSubsystem)
  }

  func performAction(_ viewModel: CamerasMoreOptionViewModel) {
    if viewModel.actionType == .segue {
      delegate?.performSegue(viewModel.actionIdentifier)
    } else if viewModel.actionType == .popup {
      // No actions currently use .popup.
    } else if viewModel.actionType == .toggle
      && viewModel.actionIdentifier == "ToggleRecordOnSecurityAlarm",
      let selected = viewModel.metaData?["toggleState"] as? Bool {
      toggleRecordOnSecurity(!selected)
    }
  }

  func prepareDesination(_ viewController: UIViewController) {

  }

  private func toggleRecordOnSecurity(_ recordOnSecurity: Bool) {
    guard let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() else {
      return
    }
    DispatchQueue.global(qos: .background).async {
      _ = self.setRecordOnSecurity(alarmSubsystem, recordOnSecurity: recordOnSecurity)
        .swiftThen({ _ in
          self.delegate?.updateLayout()
          return nil
        })
    }
  }
}
