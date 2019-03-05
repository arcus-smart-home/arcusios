//
//  SwannCameraKeepAwakePresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/21/18.
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

protocol SwannCameraKeepAwakePresenterProtocol: class {
  func startKeepAwake()
  func stopKeepAwake()
  
  init(cameraAddress: String)
}

class SwannCameraKeepAwakePresenter: NSObject, ArcusSwannBatteryCameraCapability {
  // Required by ArcusSwannBatteryCameraCapability
  var disposeBag = DisposeBag()
  
  // Dependencies
  var cache: ArcusModelCache? = RxCornea.shared.modelCache
  
  // Private Properties
  fileprivate let secondsToKeepCameraAwake = 30
  fileprivate let secondsInBetweenRequest: TimeInterval = 20
  fileprivate var requestTimer: Timer?
  fileprivate var cameraModel: DeviceModel?
  private var cameraAddress = ""
  
  required init(cameraAddress: String) {
    super.init()
    
    self.cameraAddress = cameraAddress
    cameraModel = swannCameraDeviceModel(forAddress: cameraAddress)
  }
  
  deinit {
    stopKeepAwake()
  }
  
  private func swannCameraDeviceModel(forAddress address: String) -> DeviceModel? {
    guard let cache = cache,
      let deviceModel = cache.fetchModel(address) as? DeviceModel,
      deviceModel.isSwannCamera else {
      return nil
    }
    
    return deviceModel
  }
}

extension SwannCameraKeepAwakePresenter: SwannCameraKeepAwakePresenterProtocol {
  func startKeepAwake() {
    stopKeepAwake()
    sendKeepAwakeRequest()
    
    requestTimer = Timer.scheduledTimer(withTimeInterval: secondsInBetweenRequest,
                                        repeats: true,
                                        block: { [weak self] _ in
      self?.sendKeepAwakeRequest()
    })
  }

  func stopKeepAwake() {
    requestTimer?.invalidate()
    requestTimer = nil
  }
  
  private func sendKeepAwakeRequest() {
    guard let deviceModel = cameraModel else {
      DDLogError("No swann camera model to send keep awake request.")
      return
    }
    
    do {
     _ = try requestSwannBatteryCameraKeepAwake(deviceModel, seconds: secondsToKeepCameraAwake)
    } catch {
      DDLogError("Request to keep Swann Camera Awake has thrown an exception.")
    }
  }
}
