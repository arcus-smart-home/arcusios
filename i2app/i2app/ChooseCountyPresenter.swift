//
//  ChooseCountyPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/13/18.
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

struct ChooseCountyViewModel {
  var states = [ChooseCountyStateViewModel]()
  var counties = [ChooseCountyCountyViewModel]()
  var selectedState = ""
  var selectedCounty = ""
  var isLoadingState = false
  var isLoadingCounty = false
  var isSettingLocation = false
}

struct ChooseCountyStateViewModel {
  var code = ""
  var name = ""
}

struct ChooseCountyCountyViewModel {
  var name = ""
}

protocol ChooseCountyPresenter: ArcusPlaceCapability,
ArcusNwsSameCodeService,
ArcusWeatherRadioCapability {
  
  /**
   The address of the current device being displayed.
   */
  var deviceAddress: String { get }
  
  /**
   View model representing the data for the view.
   */
  var chooseCountyData: ChooseCountyViewModel { get set }
  
  /**
   Called when a change has been made to the current view model.
   */
  func chooseCountyViewModelUpdated()
  
  /**
   Called when either retrieving the SAME location code or setting the NOAA location fails.
   */
  func chooseCountySetLocationFailed()
  
  /**
   Called when the NOAA location is successfully set on the device.
   */
  func chooseCountySetLocationSuceeded()
  
  // MARK: Extended
  
  /**
   Retrieves the SAME code and sets the NOAA location on the current device.
   */
  func chooseCountySetLocation()
  
  /**
   Retrieves the data needed for the view. The default selected state and county are based off the
   current place.
   */
  func chooseCountyFetchData()
  
  /**
   Selects a state prompting the list of county to refresh.
   - parameter stateName: The name of the state to be set.
   */
  func chooseCountySelectState(withName stateName: String)
  
}

extension ChooseCountyPresenter {
  
  func chooseCountySetLocation() {
    do {
      let observable = try requestNwsSameCodeServiceGetSameCode(chooseCountyData.selectedState,
                                                                county: chooseCountyData.selectedCounty)
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] (response) in
          if let response = response as? NwsSameCodeServiceGetSameCodeResponse,
            let sameCode = response.getCode() {
            self?.setNoaaLocation(withSameCode: sameCode)
            return
          }
          
          self?.chooseCountySetLocationFailed()
        })
        .disposed(by: disposeBag)
    } catch {
      chooseCountySetLocationFailed()
    }
  }
  
  func chooseCountySelectState(withName stateName: String) {
    for state in chooseCountyData.states where state.name == stateName {
      chooseCountyData.selectedState = state.code
      chooseCountyData.selectedCounty = ""
      chooseCountyData.isLoadingCounty = true
      retrieveCounties()
    }
    
    chooseCountyViewModelUpdated()
  }
  
  func chooseCountyFetchData() {
    guard let place = currentPlace() else {
      return
    }
    
    if let state = getPlaceState(place) {
       chooseCountyData.selectedState = state
    } else {
      chooseCountyData.selectedState = ""
    }
    
    if let county = getPlaceAddrCounty(place) {
      chooseCountyData.selectedCounty = county
    } else {
      chooseCountyData.selectedCounty = ""
    }
    
    retrieveStateCodes()
    retrieveCounties()
    
    chooseCountyViewModelUpdated()
  }
  
  private func setNoaaLocation(withSameCode code: String) {
    guard let device = deviceModel() else {
      chooseCountySetLocationFailed()
      return
    }
    
    chooseCountyData.isSettingLocation = true
    
    setWeatherRadioLocation(code, model: device)
    
    let observable = device.commitChanges()
    observable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] (_) in
        self?.chooseCountyData.isSettingLocation = false
        self?.chooseCountySetLocationSuceeded()
      })
      .disposed(by: disposeBag)
    
    chooseCountyViewModelUpdated()
  }
  
  private func retrieveStateCodes() {
    do {
      let observable = try requestNwsSameCodeServiceListSameStates()
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] (response) in
          if let response = response as? NwsSameCodeServiceListSameStatesResponse {
            self?.process(listStatesResponse: response)
            self?.chooseCountyViewModelUpdated()
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - ChooseCountyPresenter cannot retrieve states.")
    }
  }
  
  private func process(listStatesResponse response: NwsSameCodeServiceListSameStatesResponse) {
    guard let statesData = response.getSameStates() as? [[String: String]] else {
      return
    }
    
    var states = [ChooseCountyStateViewModel]()
    
    for stateData in statesData {
      var state = ChooseCountyStateViewModel()
      
      if let code = stateData["stateCode"] {
        state.code = code
      }
      if let name = stateData["state"] {
        state.name = name
      }
      
      states.append(state)
    }
    
    chooseCountyData.states = states
    chooseCountyViewModelUpdated()
  }

  private func retrieveCounties() {
    do {
      let observable = try requestNwsSameCodeServiceListSameCounties(chooseCountyData.selectedState)
      observable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] (response) in
          if let response = response as? NwsSameCodeServiceListSameCountiesResponse {
            self?.process(listCountiesResponse: response)
            self?.chooseCountyViewModelUpdated()
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - ChooseCountyPresenter cannot retrieve states.")
    }
  }
  
  private func process(listCountiesResponse response: NwsSameCodeServiceListSameCountiesResponse) {
    guard let countiesData = response.getCounties() else {
      return
    }
    
    var counties = [ChooseCountyCountyViewModel]()
    
    for countyData in countiesData {
      let county = ChooseCountyCountyViewModel(name: countyData)
      counties.append(county)
    }
    
    chooseCountyData.counties = counties
    
    chooseCountyData.isLoadingCounty = false
    chooseCountyViewModelUpdated()
  }

  private func currentPlace() -> PlaceModel? {
    return RxCornea.shared.settings?.currentPlace
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
