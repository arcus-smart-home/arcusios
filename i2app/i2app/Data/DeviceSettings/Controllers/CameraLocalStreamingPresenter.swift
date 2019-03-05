//
//  CameraLocalStreamingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/10/16.
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

struct LocalStream {
  let streamUrl: String
  let ipAddress: String
  let username: String
  let password: String

  init(streamUrl: String, ipAddress: String, username: String, password: String) {
    self.streamUrl = streamUrl
    self.ipAddress = ipAddress
    self.username = username
    self.password = password
  }
}

protocol CameraLocalStreamingCallback: class {
  func showStreamingInformation(_ localStream: LocalStream)
  func showCredentialsFetchError()
}

class CameraLocalStreamingPresenter {
  fileprivate let model: DeviceModel
  fileprivate weak var callback: CameraLocalStreamingCallback?

  init(model: DeviceModel, callback: CameraLocalStreamingCallback) {
    self.model = model
    self.callback = callback

    self.fetchStreamingInformation()
  }

  func fetchStreamingInformation() {
    // Get HubId
    DispatchQueue.global(qos: .background).async {
      if let hub = RxCornea.shared.settings?.currentHub,
        let localIp = IpInfoCapability.getIpFrom(self.model) {
        let username = hub.modelId
        _ =  HubSercommCapability.getCameraPassword(on: hub).swiftThen {
          response in
          guard let response = response as? HubSercommGetCameraPasswordResponse else { return nil }

          if let fullPassword = response.getPassword() {
            let index = fullPassword.characters.index(fullPassword.startIndex, offsetBy: 8)

            let password = fullPassword.substring(to: index)
            let streamUrl = "\"/img/video.sav\""
            let ipAddress = localIp

            self.callback?.showStreamingInformation(LocalStream(streamUrl: streamUrl,
                                                                ipAddress: ipAddress,
                                                                username: username as String,
                                                                password: password))
          } else {
            self.callback?.showCredentialsFetchError()
          }

          return nil
          }
          .swiftCatch { _ in
            DispatchQueue.main.async {
              self.callback?.showCredentialsFetchError()
            }

            return nil
        }
      } else {
        DispatchQueue.main.async {
          self.callback?.showCredentialsFetchError()
        }
      }
    }
  }
}
