//
//  EcoWaterController.swift
//  i2app
//
//  Created by Arcus Team on 6/20/17.
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
import PromiseKit
import Cornea

/*
 `EcoWaterController` defines the abstract implementation of the `EcowaterWaterSoftenerCapability` that can
 be conformed to enable use of the capability.
 **/
protocol EcoWaterController {
  // EXTENEDED:

  // MARK: Getters

  /**
   Get value of "ecowater:excessiveUse" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Bool value of "ecowater:excessiveUse"
   */
  func getExcessiveUse(_ model: DeviceModel) -> Bool

  /**
   Get value of "ecowater:continuousUse" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Bool value of "ecowater:continuousUse"
   */
  func getContinuousUse(_ model: DeviceModel) -> Bool

  /**
   Get value of "ecowater:continuousDuration" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Int32 value of "ecowater:continuousDuration"
   */
  func getContinuousDuration(_ model: DeviceModel) -> Int32

  /**
   Get value of "ecowater:continuousRate" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Double value of "ecowater:continuousRate"
   */
  func getContinuousRate(_ model: DeviceModel) -> Double

  /**
   Get value of "ecowater:alertOnContinuousUse" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Bool value of "ecowater:alertOnContinuousUse"
   */
  func getIsAlertingContinuousFlow(_ model: DeviceModel) -> Bool

  /**
   Get value of "ecowater:alertOnExcessiveUse" attribute.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.

   - Returns: Bool value of "ecowater:alertOnExcessiveUse"
   */
  func getIsAlertingExcessiveFlow(_ model: DeviceModel) -> Bool

  // MARK: Setters

  /**
   Set the "ecowater:continuousDuration" attribute, and commit the changes.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.
   - Parameter duration: Int32 representing the duration to set.

   - Returns: Promise returned by commt()
   */
  func setContinuous(_ model: DeviceModel, duration: Int32) -> PMKPromise

  /**
   Set the "ecowater:continuousRate" attribute, and commit the changes.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.
   - Parameter duration: Double representing the rate to set.

   - Returns: Promise returned by commt()
   */
  func setContinuous(_ model: DeviceModel, rate: Double) -> PMKPromise

  /**
   Set the "ecowater:alertOnContinuousUse" attribute, and commit the changes.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.
   - Parameter duration: Bool representing the whether alerts should be ON or OFF.

   - Returns: Promise returned by commt()
   */
  func setContinuousFlow(_ model: DeviceModel, alert: Bool) -> PMKPromise

  /**
   Set the "ecowater:alertOnExcessiveUse" attribute, and commit the changes.

   - Parameter model: The `DeviceModel` of the device that has `EcowaterWaterSoftenerCapability` available.
   - Parameter duration: Bool representing the whether alerts should be ON or OFF.

   - Returns: Promise returned by commt()
   */
  func setExcessiveFlow(_ model: DeviceModel, alert: Bool) -> PMKPromise
}

extension EcoWaterController {
  // MARK: Getters

  func getExcessiveUse(_ model: DeviceModel) -> Bool {
    return EcowaterWaterSoftenerCapability.getExcessiveUse(from: model)
  }

  func getContinuousUse(_ model: DeviceModel) -> Bool {
    return EcowaterWaterSoftenerCapability.getContinuousUse(from: model)
  }

  func getContinuousDuration(_ model: DeviceModel) -> Int32 {
    return EcowaterWaterSoftenerCapability.getContinuousDuration(from: model)
  }

  func getContinuousRate(_ model: DeviceModel) -> Double {
    return EcowaterWaterSoftenerCapability.getContinuousRate(from: model)
  }

  func getIsAlertingContinuousFlow(_ model: DeviceModel) -> Bool {
    return EcowaterWaterSoftenerCapability.getAlertOnContinuousUse(from: model)
  }

  func getIsAlertingExcessiveFlow(_ model: DeviceModel) -> Bool {
    return EcowaterWaterSoftenerCapability.getAlertOnExcessiveUse(from: model)
  }

  // MARK: Setters
  func setContinuous(_ model: DeviceModel, duration: Int32) -> PMKPromise {
    _ = EcowaterWaterSoftenerCapability.setContinuousDuration(duration, on: model)
    return model.commit()
  }

  func setContinuous(_ model: DeviceModel, rate: Double) -> PMKPromise {
    _ = EcowaterWaterSoftenerCapability.setContinuousRate(rate, on: model)
    return model.commit()
  }

  func setContinuousFlow(_ model: DeviceModel, alert: Bool) -> PMKPromise {
    _ = EcowaterWaterSoftenerCapability.setAlertOnContinuousUse(alert, on: model)
    return model.commit()
  }

  func setExcessiveFlow(_ model: DeviceModel, alert: Bool) -> PMKPromise {
    _ = EcowaterWaterSoftenerCapability.setAlertOnExcessiveUse(alert, on: model)
    return model.commit()
}
}
