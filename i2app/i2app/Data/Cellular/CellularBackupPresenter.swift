//
//  CellularBackupPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/19/16.
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

@objc protocol CellularBackupCallback: class {
  @objc optional func showOnBroadband()
  @objc optional func showOnCellularBackup()
  @objc optional func showNeedsServicePlan()
  @objc optional func showNeedsActivation()
  @objc optional func showNeedsConfiguration()
}

class CellularBackupPresenter: NSObject {
  fileprivate weak var callback: CellularBackupCallback?

  fileprivate var subsystemController: SubsystemsController
  fileprivate var notificationCenter: NotificationCenter

  init(callback: CellularBackupCallback,
       subsystemController: SubsystemsController = SubsystemsController.sharedInstance(),
       notificationCenter: NotificationCenter = NotificationCenter.default) {
    self.callback = callback
    self.subsystemController = subsystemController
    self.notificationCenter = notificationCenter

    super.init()

    notificationCenter
      .addObserver(self,
                   selector: #selector(update(_:)),
                   name: Model
                    .attributeChangedNotificationName(kAttrCellBackupSubsystemStatus),
                   object: nil)

    notificationCenter
      .addObserver(self,
                   selector: #selector(update(_:)),
                   name: Model
                    .attributeChangedNotificationName(kAttrCellBackupSubsystemErrorState),
                   object: nil)

    notificationCenter
      .addObserver(self,
                   selector: #selector(update(_:)),
                   name: Model
                    .attributeChangedNotificationName(kAttrCellBackupSubsystemNotReadyState),
                   object: nil)
    update(nil)
  }

  deinit {
    self.notificationCenter.removeObserver(self)
  }

  func update(_ note: Notification?) {
    DispatchQueue.main.async { [weak self] _ in

      if let state = self?.subsystemController.cellBackupSubsystemController?.state() {
        switch state {
        case .cellular:
          self?.callback?.showOnCellularBackup?()
          break
        case .broadband:
          self?.callback?.showOnBroadband?()
          break
        case .suspended: // Banned
          self?.callback?.showNeedsActivation?()
          break
        case .notReady: // Needs Sub
          self?.callback?.showNeedsServicePlan?()
          break
        case .configuration: // Needs Config
          self?.callback?.showNeedsConfiguration?()
          break
        }
      }
    }
  }
}
