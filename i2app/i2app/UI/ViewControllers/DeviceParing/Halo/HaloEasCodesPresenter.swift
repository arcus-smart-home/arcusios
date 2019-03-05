//
//  HaloEasCodesPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/18/16.
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

class EasCode: NSObject {
  var easCode: String!
  var name: String!
  var group: String!

  init(easCode: String, name: String, group: String) {
    self.easCode = easCode
    self.name = name
    self.group = group
  }
}

protocol HaloEasCodesPresenterDelegate: class {
  func getEasCodes(_ states: [EasCode])
}

class HaloEasCodesPresenter: NSObject {

  class func getEasCodes(_ delegate: HaloEasCodesPresenterDelegate) {
    DispatchQueue.global(qos: .background).async {
      _ = EasCodeService.listEasCodes().swiftThenInBackground { result in
        if let easCodes: Array = (result as? EasCodeServiceListEasCodesResponse)!.getEasCodes() {
          let codesArray: NSMutableArray = NSMutableArray()
          for dict: Dictionary in (easCodes as? [[String: String]])! {
            let easCode = EasCode(easCode: dict["eas"]!, name: dict["name"]!, group: dict["group"]!)
            codesArray.add(easCode)
          }
          delegate.getEasCodes((codesArray.copy() as? [EasCode])!)
        }
        return nil
      }
    }
  }

  class func setSelectedEasCodes(_ selectedCodes: [String],
                                 deviceModel: DeviceModel,
                                 completionBlock: @escaping BoolCompletionBlock) {
    WeatherRadioCapability.setAlertsofinterest(selectedCodes,
                                               on: deviceModel)
    _ = deviceModel.commit().swiftThen { _ in
      completionBlock(true)
      return nil
      }.swiftCatch { _ in
        completionBlock(false)
        return nil
    }
  }
}
