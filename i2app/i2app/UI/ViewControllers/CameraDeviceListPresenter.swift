//
//  CameraDeviceListPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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
import RxSwift

protocol CameraDeviceListPresenterProtocol {
  init(delegate: CameraDeviceListPresenterDelegate)

  var delegate: CameraDeviceListPresenterDelegate? { get }

  var hasSetup: Bool { get }
  func fetchData()
  func addObservers()
  func removeObservers()

  /// If empty the presenter is loading initial data
  var devices: [CameraPreviewPresenter] { get }

  func playButtonPressed(onRow: Int)
  func recordButtonPressed(onRow: Int)
}

protocol CameraDeviceListPresenterDelegate: GenericListPresenterDelegate, CameraPlaybackViewController {
}

class CameraDeviceListPresenter: CameraDeviceListPresenterProtocol, CamerasSubsystemController,
CameraStatusController, ArcusDeviceCapability {
  var disposeBag = DisposeBag()

  weak var delegate: CameraDeviceListPresenterDelegate?
  var hasSetup = false
  var cameraPlaybackPresenter: CameraPlaybackPresenter?
  var swawnnKeepAwakePresenters: [SwannCameraKeepAwakePresenterProtocol] = []

  private(set) var devices: [CameraPreviewPresenter] = [] {
    didSet {
      delegate?.updateLayout()
    }
  }

  required init(delegate: CameraDeviceListPresenterDelegate) {
    self.delegate = delegate
    self.cameraPlaybackPresenter = CameraPlaybackPresenter(delegate: self)
    addObservers()
  }

  deinit {
    removeObservers()
    swawnnKeepAwakePresenters.forEach { $0.stopKeepAwake() }
    devices.forEach { $0.stopRefreshTimer() }
    NotificationCenter.default.removeObserver(self)
  }

  func addObservers() {
    removeObservers()
    devices.forEach { $0.removeObservers() }
    observeNotifications()
    devices.forEach { $0.addObservers() }
  }

  func removeObservers() {
    devices.forEach { $0.removeObservers() }
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

  fileprivate func observeNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(CameraDeviceListPresenter.handleSubsystemUpdate),
      name: Notification.Name.subsystemInitialized,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(CameraDeviceListPresenter.handleSubsystemUpdate),
      name: Notification.Name.subsystemUpdated,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(CameraDeviceListPresenter.handleSubsystemUpdate),
      name: Notification.Name.subsystemCacheCleared,
      object: nil)
  }

  @objc fileprivate func handleSubsystemUpdate(_ note: Notification) {
    DispatchQueue.main.async {
      self.fetchData()
    }
  }

  func fetchData() {
    guard let camerasController = SubsystemsController.sharedInstance().camerasController,
      let cameraAddresses = camerasController.allDeviceIds as? [String] else {
        DDLogInfo("CameraDeviceListPresenter.fetchData() Called before Cache is built")
        return
    }

    if !hasSetup {
      // Inform the Delegate that we have at least tried to start
      hasSetup = true
    }

    enum CameraMapError: Error {
      case cannotFindInCache
    }
    
    swawnnKeepAwakePresenters = []
    var cameras: [CameraPreviewPresenter]?
   
    do {
      cameras = try cameraAddresses.map { address -> DeviceModel in
        guard let device = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel else {
          throw CameraMapError.cannotFindInCache
        }
        return device
      }.map { device -> CameraPreviewPresenter in
        let cameraPreviewPresenter = CameraPreviewPresenter(delegate: self, deviceModel: device)
        
        if device.isSwannCamera {
          let newKeepAwakePresenter = SwannCameraKeepAwakePresenter(cameraAddress: device.address)
          newKeepAwakePresenter.startKeepAwake()
          swawnnKeepAwakePresenters.append(newKeepAwakePresenter)
        }
        
        return cameraPreviewPresenter
      }
    } catch {
      cameras = nil
    }
    if let cameras = cameras {
      devices = cameras
    }
  }

  func playButtonPressed(onRow row: Int) {
    guard let cameraPreviewPresenter = devices[safe: row],
      let camera = cameraPreviewPresenter.card,
      camera.status != .firmware,
      camera.status != .offline,
      camera.status != .hub4g  else {
        // must find a camera card and it must be able to stream
        return
    }
    let modelAddress = cameraPreviewPresenter.deviceModel.address as String
    if let camerasController = SubsystemsController.sharedInstance().camerasController.subsystemModel,
      camerasController.hasAttributes(),
      let cameraStatus = cameraStatus(camerasController,
                                      forCamera: cameraPreviewPresenter.deviceModel.address as String),
      let playback = cameraPlaybackPresenter,
      playback.fetchActive != true {
      delegate?.displayLoadingIndicator()
      if let activeRecording = activeRecording(cameraStatus),
        activeRecording != "" {
        playback.piggyBack(onRecordingModelAddress: activeRecording)
      } else {
        playback.startStreaming(withDeviceAddress: modelAddress)
      }
    }
  }

  func recordButtonPressed(onRow row: Int) {
    guard let cameraPreviewPresenter = devices[safe: row],
      let camera = cameraPreviewPresenter.card,
      let playback = cameraPlaybackPresenter,
      playback.fetchActive != true,
      camera.status != .firmware,
      camera.status != .offline,
      camera.status != .hub4g  else {
        // must find a camera card and it must be able to stream
        return
    }
    delegate?.displayLoadingIndicator()
    let modelAddress = cameraPreviewPresenter.deviceModel.address as String
    playback.startRecording(withDeviceAddress:modelAddress)
  }
}

extension CameraDeviceListPresenter: CameraPlaybackDelegate {
  func cameraPlayback(presenter: CameraPlaybackPresenter, didReceiveStreamUrl streamUrl: URL) {
    DispatchQueue.main.async {
      self.delegate?.shouldDisplayVideo(withURL: streamUrl)
    }
  }

  func cameraPlayback(presenter: CameraPlaybackPresenter, didFailWithError error: Error) {
    DispatchQueue.main.async {
      self.delegate?.shouldDisplayVideoError(err: error)
    }
  }
}

extension CameraDeviceListPresenter: CameraPreviewPresenterDelegate {
  func update(withCameraPreviewPresenter previewPresenter: CameraPreviewPresenter) {
    if let idx = devices.index(of:previewPresenter) {
      DispatchQueue.main.async {
        self.delegate?.updateAtIndexPath(IndexPath(indexes:[0, idx]))
      }
    }
  }
}
