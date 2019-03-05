//
//  ProMonitoringController.swift
//  i2app
//
//  Arcus Team on 2/14/17.
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
import RxSwift

protocol ProMonitoringSettingsController {
  var proMonitoringSettingsModel: ProMonitoringSettingsModel? {get set}

  func isProMonitored() -> Bool

  func certificateURL() -> String

  func permitNumber() -> String
  func permitNumber(_ permitNumber: String) -> PMKPromise

  func additionalDirections() -> String
  func additionalDirections(_ additionalDirections: String) -> PMKPromise

  func gateCode() -> String
  func gateCode(_ gateCode: String) -> PMKPromise

  func responderInstructions() -> String
  func responderInstructions(_ responderInstructions: String) -> PMKPromise

  func adultsCount() -> Int
  func adultsCount(_ adults: Int) -> PMKPromise

  func childrenCount() -> Int
  func childrenCount(_ children: Int) -> PMKPromise

  func petsCount() -> Int
  func petsCount(_ pets: Int) -> PMKPromise

}

extension ProMonitoringSettingsController {

  func certificateURL() -> String {
    guard proMonitoringSettingsModel != nil else {
      return ""
    }

    return ProMonitoringSettingsCapability.getCertUrl(
      from: proMonitoringSettingsModel)
  }

  func permitNumber() -> String {
    if let permit = ProMonitoringSettingsCapability.getPermitNumber(from: proMonitoringSettingsModel) {
      return permit
    }
    return ""
  }

  func permitNumber(_ permitNumber: String) -> PMKPromise {
    ProMonitoringSettingsCapability.setPermitNumber(permitNumber, on: proMonitoringSettingsModel)
    return proMonitoringSettingsModel!.commit()
  }

  func additionalDirections() -> String {
    if let directions = ProMonitoringSettingsCapability.getDirectionsFrom(proMonitoringSettingsModel) {
      return directions
    }
    return ""
  }

  func additionalDirections(_ additionalDirections: String) -> PMKPromise {
    ProMonitoringSettingsCapability.setDirections(additionalDirections, on: proMonitoringSettingsModel)
    return proMonitoringSettingsModel!.commit()
  }

  func gateCode() -> String {
    if let code = ProMonitoringSettingsCapability.getGateCode(from: proMonitoringSettingsModel) {
      return code
    }
    return ""
  }

  func gateCode(_ gateCode: String) -> PMKPromise {
    ProMonitoringSettingsCapability.setGateCode(gateCode, on: proMonitoringSettingsModel)
    return proMonitoringSettingsModel!.commit()
  }

  func responderInstructions() -> String {
    if let instructions = ProMonitoringSettingsCapability.getInstructionsFrom(proMonitoringSettingsModel) {
      return instructions
    }
    return ""
  }

  func responderInstructions(_ responderInstructions: String) -> PMKPromise {
    ProMonitoringSettingsCapability.setInstructions(responderInstructions, on: proMonitoringSettingsModel)
    return proMonitoringSettingsModel!.commit()
  }

  func adultsCount() -> Int {
    return Int(ProMonitoringSettingsCapability.getAdultsFrom(proMonitoringSettingsModel))
  }

  func adultsCount(_ adults: Int) -> PMKPromise {
    ProMonitoringSettingsCapability.setAdults(Int32(adults), on: proMonitoringSettingsModel)
    _ = proMonitoringSettingsModel!.commit()
    return proMonitoringSettingsModel!.refresh()
  }

  func childrenCount() -> Int {
    return Int(ProMonitoringSettingsCapability.getChildrenFrom(proMonitoringSettingsModel))
  }

  func childrenCount(_ children: Int) -> PMKPromise {
    ProMonitoringSettingsCapability.setChildren(Int32(children), on: proMonitoringSettingsModel)
    _ = proMonitoringSettingsModel!.commit()
    return proMonitoringSettingsModel!.refresh()
  }

  func petsCount() -> Int {
    return Int(ProMonitoringSettingsCapability.getPetsFrom(proMonitoringSettingsModel))
  }

  func petsCount(_ pets: Int) -> PMKPromise {
    ProMonitoringSettingsCapability.setPets(Int32(pets), on: proMonitoringSettingsModel)
    _ = proMonitoringSettingsModel!.commit()
    return proMonitoringSettingsModel!.refresh()
  }

  func isProMonitored() -> Bool {
    return ProMonitoringSettingsCapability.getActivatedOn(from: proMonitoringSettingsModel) != nil
  }
}

class ProMonitoringSettingsProvider: RxArcusService, ArcusPromiseConverter {
  var disposeBag: DisposeBag = DisposeBag()

  func modelForPlaceId(_ placeId: String) -> PMKPromise {
    // Check the ModelCache First.
    let address = ProMonitoringSettingsModel.addressForId(placeId)
    if let model = RxCornea.shared.modelCache?.fetchModel(address) as? ProMonitoringSettingsModel {
      return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
        fulfiller?(model)
      }
    }

    return ProMonitoringSettingsModel(attributes: [kAttrAddress: ProMonitoringSettingsModel.addressForId(placeId) as AnyObject])
    .refresh()
    .swiftThen({ (response: Any?) -> (PMKPromise?) in
      if let attrResponse = response as? BaseGetAttributesResponse {
        return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(ProMonitoringSettingsModel(attributes: attrResponse.attributes))
        }
      } else {
        return PMKPromise.new { (fulfiller: PMKFulfiller?, rejecter: PMKRejecter?) in
          rejecter?(nil)
        }
      }
    })
  }
}
