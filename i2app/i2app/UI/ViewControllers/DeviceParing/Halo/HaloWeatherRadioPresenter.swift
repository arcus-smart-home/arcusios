//
//  HaloWeatherRadioPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/16/16.
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
import PromiseKit

typealias BoolCompletionBlock = (Bool) -> Void

class WeatherRadioStation: NSObject {
  var id: Int
  var frequency: String
  var rssiValue: float_t

  init(id: Int, frequency: String, rssiValue: float_t) {
    self.id = id
    self.frequency = frequency
    self.rssiValue = rssiValue
  }
}

class HaloWeatherRadioPresenter: NSObject {

  var deviceModel: DeviceModel?

  init (deviceModel: DeviceModel) {
    self.deviceModel = deviceModel
  }

  func getRadioStations(_ deviceModel: DeviceModel,
                        completionBlock: @escaping ([WeatherRadioStation]) -> Void) {
    DispatchQueue.global(qos: .background).async {
      _ = WeatherRadioCapability.scanStations(on: deviceModel)
        .swiftThenInBackground { result in
          let stations = (result as? WeatherRadioScanStationsResponse)!.getStations()
          var stationsArray: [WeatherRadioStation] = [WeatherRadioStation]()
          for dict: Dictionary in (stations as? [[String: AnyObject]])! {
            let rssi: float_t = ((dict["rssi"] as? NSNumber)!).floatValue
            if rssi != 0 {
              let radioStation = WeatherRadioStation(id: (dict["id"] as? Int)!,
                                                     frequency: (dict["freq"] as? String)!,
                                                     rssiValue: rssi)
              stationsArray.append(radioStation)
            }
          }
          let sortedStationsArray = stationsArray.sorted { return $0.0.rssiValue > $0.1.rssiValue }
          completionBlock(sortedStationsArray)
          return nil
      }
    }
  }

  func setDefaultRadioStation(_ stationId: Int, completionBlock: @escaping BoolCompletionBlock) {
    DispatchQueue.global(qos: .background).async {
      _ = WeatherRadioCapability.selectStation(withStation: Int32(stationId),
                                           on: self.deviceModel).swiftThenInBackground { _ in
                                            completionBlock(true)
                                            return nil
        }.swiftCatch { _ in
          completionBlock(false)
          return nil
      }
    }
  }

  @objc func playStation(_ stationId: Int, duration: Int, completionBlock: @escaping BoolCompletionBlock) {
    DispatchQueue.global(qos: .background).async {
      _ = WeatherRadioCapability.playStation(withStation: Int32(stationId),
                                         withTime: Int32(duration),
                                         on: self.deviceModel).swiftThenInBackground {_ in
                                          completionBlock(true)
                                          return nil
        }.swiftCatch { _ in
          completionBlock(false)
          return nil
      }
    }
  }

  @objc func stopPlayingStation(_ completionBlock: @escaping BoolCompletionBlock) {
    DispatchQueue.global(qos: .background).async {
      _ = WeatherRadioCapability.stopPlayingStation(on: self.deviceModel).swiftThenInBackground {_ in
        completionBlock(true)
        return nil
        }.swiftCatch { _ in
          completionBlock(false)
          return nil
      }
    }
  }

  @objc func getIndexOfStationWithId(_ stationId: Int, stations: [WeatherRadioStation]) -> Int {
    if let index = stations.index(where: {$0.id == stationId}) {
      return index
    }
    return -1
  }
}
