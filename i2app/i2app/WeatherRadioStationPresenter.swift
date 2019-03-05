//
//  WeatherRadioStationPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/4/18.
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

struct WeatherRadioStationViewModel {
  var name = ""
  var frequency = ""
  var id = 0
  var rss: Float = 0
  var isPlaying = false
  var isSelected = false
}

protocol WeatherRadioStationPresenter: ArcusWeatherRadioCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  var weatherStations: [WeatherRadioStationViewModel] { get set }
  
  /**
   Call when changes to the weather radio station happen.
   */
  func weatherRadioStationDataUpdated()
  
  /**
   Call when a weak weather radio station signal is detected.
   */
  func weatherRadioStatonWeakSignalFound()
  
  // MARK: Extended
  
  /*
   Starts observing changes on the current device model.
   */
  func weatherRadioStationObserveChanges()
  
  /**
   Retrieves the weather radio station data related to the current device.
   */
  func weatherRadioStationFetchData()
  
  /**
   Sets the weather station of the given index as the default weather station
   - parameter index: The index of the station to be selected.
   */
  func weatherRadioStationSelectStation(atIndex index: Int)
  
  /**
   Retrieves the index of the currently selected weather radio station.
   - returns Index of the selected weather station.
   */
  func weatherRadioStationIndexOfSelectedStation() -> Int
  
  /**
   Signals the device to play the weather station at the given index.
   - parameter index: The index of the station to be played.
   */
  func playStation(atIndex index: Int)
  
  /**
   Stops playing a station if one is currently playing
   */
  func stopPlayingStation()
}

extension WeatherRadioStationPresenter {
  
  func weatherRadioStationObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    let disposable = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.updateStations()
      })
    
    disposable.addDisposableTo(disposeBag)
  }
  
  func weatherRadioStationFetchData() {
    guard let device = deviceModel() else {
      return
    }
    
    do {
      let observable = try requestWeatherRadioScanStations(device)
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? WeatherRadioScanStationsResponse {
            self?.process(scanResponse: response)
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - WeatherRadioStationPresenter cannot scan stations.")
    }
  }
  
  func weatherRadioStationSelectStation(atIndex index: Int) {
    guard weatherStations.count > index,
      let device = deviceModel() else {
      return
    }
    
    for currentIndex in weatherStations.indices {
      weatherStations[currentIndex].isSelected = currentIndex == index
    }
    
    do {
      _ = try requestWeatherRadioSelectStation(device, station: weatherStations[index].id)
    } catch {
      DDLogError("Error - WeatherRadioStationPresenter cannot save station.")
    }
    
    weatherRadioStationDataUpdated()
  }
  
  func weatherRadioStationIndexOfSelectedStation() -> Int {
    for (index, station) in weatherStations.enumerated() where station.isSelected {
      return index
    }
    
    return 0
  }
  
  func playStation(atIndex index: Int) {
    guard let device = deviceModel(), weatherStations.count > index else {
      return
    }
    
    for currentIndex in weatherStations.indices {
      weatherStations[currentIndex].isPlaying = currentIndex == index
    }
    
    do {
      _ = try requestWeatherRadioPlayStation(device,
                                             station: weatherStations[index].id,
                                             time: 10)
    } catch {
      DDLogError("Error - WeatherRadioStationPresenter cannot play station.")
    }
    
    weatherRadioStationDataUpdated()
  }
  
  func stopPlayingStation() {
    guard let device = deviceModel() else {
      return
    }
    
    do {
      _ = try requestWeatherRadioStopPlayingStation(device)
    } catch {
      DDLogError("Error - WeatherRadioStationPresenter cannot stop playing station.")
    }
  }
  
  private func preselectFirstStationIfNeeded() {
    if !hasSelectedStation() && weatherStations.count > 0 {
      weatherStations[0].isSelected = true
    }
  }
  
  private func hasSelectedStation() -> Bool {
    for station in weatherStations {
      if station.isSelected {
        return true
      }
    }
    
    return false
  }
  
  private func updateStations() {
    guard let device = deviceModel() else {
      return
    }
    
    let selectedStationId = getWeatherRadioStationselected(device) ?? 0
    
    for (index, station) in weatherStations.enumerated() {
      weatherStations[index].isSelected = station.id == selectedStationId
      
      if !isDevicePlayingStation() {
        weatherStations[index].isPlaying = false
      }
    }
    
    preselectFirstStationIfNeeded()
    weatherRadioStationDataUpdated()
  }
  
  private func isDevicePlayingStation() -> Bool {
    guard let device = deviceModel(),
    let playState = getWeatherRadioPlayingstate(device),
    playState == .playing else {
      return false
    }
  
    return true
  }
  
  private func process(scanResponse response: WeatherRadioScanStationsResponse) {
    guard let stations = response.getStations() as? [[String: AnyObject]],
      let device = deviceModel() else {
      return
    }
    
    var viewModels = [WeatherRadioStationViewModel]()
    
    for station in stations {
      var viewModel = WeatherRadioStationViewModel()
      
      if let id = station["id"] as? Int {
        viewModel.id = id
        viewModel.name = "Station \(id)"
      }
      if let frequency = station["freq"] as? String {
        viewModel.frequency = frequency
      }
      if let rssi = station["rssi"] as? Float {
        viewModel.rss = rssi
      }
      if let stationSelected = getWeatherRadioStationselected(device),
        stationSelected == viewModel.id {
        viewModel.isSelected = true
      }
      
      viewModel.isPlaying = false
      viewModels.append(viewModel)
    }
    
    weatherStations = viewModels
    
    if weatherStations.count == 0 {
      weatherRadioStatonWeakSignalFound()
    } else {
      preselectFirstStationIfNeeded()
      weatherRadioStationDataUpdated()
    }
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
