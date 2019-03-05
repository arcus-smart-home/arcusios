//
//  PlaceProMonSettingsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/3/17.
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

import Cornea

protocol PlaceProMonSettingsProtocol {
  var certificateData: Data {get}
  var certificateURL: String {get}

  init(delegate: PlaceProMonSettingsDelegate, placeId: String)
  func fetchAlarmCertificate()
}

protocol PlaceProMonSettingsDelegate: class {
  func alarmCertificateRetrieved()
  func alarmCertificateFailure()
}

class PlaceProMonSettingsPresenter: ProMonitoringSettingsController {
  weak var delegate: PlaceProMonSettingsDelegate?

  fileprivate(set) var certificateData = Data()
  fileprivate(set) var certificateURL = ""
  var proMonitoringSettingsModel: ProMonitoringSettingsModel?
  var settingsProvider: ProMonitoringSettingsProvider = ProMonitoringSettingsProvider()

  required init(delegate: PlaceProMonSettingsDelegate, placeId: String) {

    self.delegate = delegate

    DispatchQueue.global(qos: .background).async {
      _ = self.settingsProvider.modelForPlaceId(placeId).swiftThenInBackground({ response in
        if let model = response as? ProMonitoringSettingsModel {
          _ = model.refresh().swiftThen { _ in
            self.proMonitoringSettingsModel = model
            return nil
          }
        }

        return nil
      })
    }
  }
}

// MARK: PlaceProMonSettingsProtocol

extension PlaceProMonSettingsPresenter: PlaceProMonSettingsProtocol {
  func fetchAlarmCertificate() {
    let url = certificateURL()

    // Something went wrong creating the URL from the url string
    guard let urlForCertificate = URL(string: url) else {
      delegate?.alarmCertificateFailure()
      return
    }

    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    let request = URLRequest(url: urlForCertificate)

    let task = session.dataTask(
      with: request,
      completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        guard let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          error == nil else {
          self.delegate?.alarmCertificateFailure()
          return
        }

        self.certificateData = data
        self.certificateURL = url
        self.delegate?.alarmCertificateRetrieved()
    })
    task.resume()
  }
}
