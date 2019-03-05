//
//  CameraPreviewPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/9/17.
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
import CocoaLumberjack

protocol CameraPreviewPresenterProtocol {
  init(delegate: CameraPreviewPresenterDelegate,
       deviceModel: DeviceModel,
       subsystemsController: SubsystemsController,
       notificationCenter: NotificationCenter)
  func addObservers()
  func removeObservers()
  func stopRefreshTimer()
  var deviceModel: DeviceModel { get set }
  var card: LiveCameraViewModel { get set }
}

protocol CameraPreviewPresenterDelegate: class {
  func update(withCameraPreviewPresenter: CameraPreviewPresenter)
}

class CameraPreviewPresenter: CameraStatusController, CamerasSubsystemController {

  let kImagePreviewTimerInterval: TimeInterval = 20.0

  let deviceModel: DeviceModel

  var refreshTimer: Timer?

  var notificationCenter: NotificationCenter?

  var cellularPresenter: CellularBackupPresenter?

  var inCellularState: Bool = false
  
  var cameraState: String = "IDLE"

  var card: LiveCameraViewModel!

  weak var delegate: CameraPreviewPresenterDelegate?

  init(delegate: CameraPreviewPresenterDelegate,
       deviceModel: DeviceModel,
       subsystemsController: SubsystemsController = SubsystemsController.sharedInstance(),
       notificationCenter: NotificationCenter = NotificationCenter.default) {
    self.delegate = delegate
    self.deviceModel = deviceModel
    self.notificationCenter = notificationCenter

    let selector = #selector(self.getDeviceStateChangedNotification(_:))
    notificationCenter.addObserver(self,
                                   selector: selector,
                                   name: Notification.Name(self.deviceModel.modelChangedNotification()),
                                   object: nil)

    self.cellularPresenter = CellularBackupPresenter(callback: self)
    addObservers()
    fetchCameraStatus()
    updateCard()
    fetchPreview()
    startRefreshTimer()
  }

  func addObservers() {
    removeObservers()
    observeNotifications()
  }

  func removeObservers() {
    NotificationCenter.default
      .removeObserver(self,
                   name: Notification.Name.subsystemInitialized,
                   object: nil)
    NotificationCenter.default
    .removeObserver(self,
                    name: Notification.Name.subsystemUpdated,
                    object: nil)
    NotificationCenter.default
      .removeObserver(self,
                      name: Notification.Name.subsystemCacheCleared,
                      object: nil)
  }

  func observeNotifications() {
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CameraPreviewPresenter.cameraSubsystemNotification(_:)),
                   name: Notification.Name.subsystemInitialized,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CameraPreviewPresenter.cameraSubsystemNotification(_:)),
                   name: Notification.Name.subsystemUpdated,
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(CameraPreviewPresenter.cameraSubsystemNotification(_:)),
                   name: Notification.Name.subsystemCacheCleared,
                   object: nil)
  }

  deinit {
    notificationCenter?.removeObserver(self)
  }

  fileprivate func updateCard() {
    card = LiveCameraViewModel(withCameraCapableDeviceModel: self.deviceModel,
              state: cameraState,
              cellular: inCellularState)
    
    self.delegate?.update(withCameraPreviewPresenter:self)
  }

  @objc func cameraSubsystemNotification(_ note: Notification) {
    DispatchQueue.main.async {
      let lastCameraState = self.cameraState
      self.fetchCameraStatus()
      
      // Create new card if camera state changed...
      if lastCameraState != self.cameraState {
        self.updateCard()
      }
      // ... otherwise just update the existing card.
      else {
        self.delegate?.update(withCameraPreviewPresenter: self)
      }
    }
  }

  @objc private func getDeviceStateChangedNotification(_ note: Notification) {
    // These are not the models you are looking for
    guard let model = note.userInfo!["Model"] as? Model,
      model.modelId as String == self.deviceModel.modelId as String,
      let keys = (note.object as AnyObject).allKeys,
      keys.contains(where: {
        $0 as? String == kAttrDeviceConnectionState || $0 as? String == kAttrDeviceOtaStatus
      }) else {
        return
    }
    DispatchQueue.main.async {
      self.updateCard()
    }
  }

  private func fetchCameraStatus() {
    guard SubsystemsController.sharedInstance().camerasController != nil,
      let cameraSubsystem = SubsystemsController.sharedInstance().camerasController.subsystemModel else {
      DDLogInfo("CameraPreviewPresenterDelegate.fetchCameraStatus() Called before Cache is built")
      return
    }

    if let cameraStatus = cameraStatus(cameraSubsystem, forCamera: deviceModel.address),
      let state = state(cameraStatus) {

      self.cameraState = state
    }
  }

  @objc private func fetchPreview() {
    if let placeModel: PlaceModel = RxCornea.shared.settings?.currentPlace,
      let controller: CameraSubsystemController  = SubsystemsController.sharedInstance().camerasController {
      DispatchQueue.global(qos: .background).async {
        if let placeId = placeModel.modelId as String?,
          let modelId = self.deviceModel.modelId as String? {
          _ = controller.getCameraPreview(withCameraId: modelId, placeId: placeId)
            .swiftThenInBackground { response in
              guard let responseData = response as? Data else {
                return nil
              }
              self.card.cameraPreview = responseData
              self.card.cameraEvent = NSDate().formatFullDate()
              DispatchQueue.main.async {
                // Inform of change in card
                self.delegate?.update(withCameraPreviewPresenter:self)
              }
              return nil
            }
            .swiftCatch { _ in
              // No Last Recording
              DispatchQueue.main.async {
                // Inform of change in card
                self.delegate?.update(withCameraPreviewPresenter:self)
              }
              return nil
          }
        }
      }
    }
  }

  private func isCurrentStreamingWithRecord(_ lastRecording: RecordingModel) -> Bool {
    return (RecordingCapability.getTypeFrom(lastRecording) == kEnumRecordingTypeRECORDING
      && RecordingCapability.getSizeFrom(lastRecording) == 0)
  }

  // MARK: Preview Fetch Timer

  private func startRefreshTimer() {
    self.stopRefreshTimer()

    if !Thread.isMainThread {
      DispatchQueue.main.async {
        self.startRefreshTimer()
        return
      }
    }

    if self.refreshTimer == nil || !(self.refreshTimer!.isValid) {
      self.refreshTimer = Timer.scheduledTimer(timeInterval: kImagePreviewTimerInterval,
                                               target: self,
                                               selector: #selector(fetchPreview),
                                               userInfo: nil,
                                               repeats: true)
    }
  }

  /// Stop the timer and invalidate it, Remember Timers retain their targets while they're alive!
  func stopRefreshTimer() {
    if self.refreshTimer != nil {
      self.refreshTimer?.invalidate()
      self.refreshTimer = nil
    }
  }
}

// MARK: CellularBackupCallback
extension CameraPreviewPresenter: CellularBackupCallback {

  func showOnBroadband() {
    self.inCellularState = false
    self.updateCard()
  }

  func showOnCellularBackup() {
    self.inCellularState = true
    self.updateCard()
  }
}

extension CameraPreviewPresenter: Equatable {
  static func == (lhs: CameraPreviewPresenter, rhs: CameraPreviewPresenter) -> Bool {
    return lhs.deviceModel === rhs.deviceModel
  }
}
