//
//  HaloSetupPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/15/16.
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

@objc protocol HaloSetupPresenterDelegate {
  func getSameStates(_ states: OrderedDictionary)
  func getSameCounties(_ countiesList: OrderedDictionary)
  func getSameCode(_ code: String)
  func setNoaaLocation(_ success: Bool)
}

class HaloSetupPresenter: NSObject {

  func getSameStatesList(_ delegate: HaloSetupPresenterDelegate) {
    _ = NwsSameCodeService.listSameStates().swiftThenInBackground { result in
      let states = (result as? NwsSameCodeServiceListSameStatesResponse)!.getSameStates()
      let statesDict: OrderedDictionary = OrderedDictionary()
      for dict: Dictionary in (states as? [[String: String]])! {
        statesDict.setValue(dict["stateCode"], forKey: dict["state"]!)
      }
      delegate.getSameStates(statesDict)
      return nil
    }
  }

  func getSameCountiesList(_ stateCode: String, delegate: HaloSetupPresenterDelegate) {
    _ = NwsSameCodeService.listSameCounties(withStateCode: stateCode).swiftThenInBackground { result in
      if let counties = (result as? NwsSameCodeServiceListSameCountiesResponse)!.getCounties() {
        let countiesDict = OrderedDictionary()
        for county in counties {
          countiesDict.setValue(county, forKey: (county as? String)!)
        }
        delegate.getSameCounties(countiesDict)
      }
      return nil
    }
  }

  func getSameCode(_ stateCode: String, countyCode: String, delegate: HaloSetupPresenterDelegate) {
    _ = NwsSameCodeService.getSameCode(withStateCode: stateCode,
                                       withCounty: countyCode).swiftThenInBackground { result in
                                        if let code = (result as? NwsSameCodeServiceGetSameCodeResponse)!.getCode() {
                                          delegate.getSameCode(code)
                                        }
                                        return nil
    }
  }

  func setNoaaLocation(_ code: String, deviceModel: DeviceModel, delegate: HaloSetupPresenterDelegate) {
    _ = WeatherRadioCapability.setLocation(code, on: deviceModel)
    deviceModel.commit().swiftThenInBackground { _ in
      delegate.setNoaaLocation(true)
      return nil
      }.swiftCatch { _ in
        delegate.setNoaaLocation(false)
        return nil
    }
  }

}
