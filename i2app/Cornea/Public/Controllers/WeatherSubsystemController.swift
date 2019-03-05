//
//  WeatherSubsystemController.swift
//  i2app
//
//  Created by Arcus Team on 10/31/16.
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

import UIKit
import PromiseKit
import Cornea

class WeatherSubsystemController: NSObject, SubsystemProtocol {
    var subsystemModel: SubsystemModel
    var numberOfDevices: Int32 = 0
    unowned(unsafe) var allDeviceIds: NSArray = NSArray()

    init(attributes: [String: AnyObject]) {
        self.subsystemModel = SubsystemModel(attributes: attributes)
    }

    func snoozeAllWeatherAlerts() -> PMKPromise {
        return WeatherSubsystemCapability.snoozeAllAlerts(on: subsystemModel)
            .swiftThen({ (response: Any?) -> (PMKPromise?) in
                guard let response = response as? WeatherSubsystemSnoozeAllAlertsResponse else { return nil }
                //return PMKPromise.promiseWithValue(response.getAttributes())
                return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
                    fulfiller?(response.attributes)
                }
            })
    }
}
