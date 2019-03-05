//
//  SubsystemController.swift
//  i2app
//
//  Created by Arcus Team on 1/31/17.
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

import PromiseKit
import Cornea

protocol SubsystemController {
  func subsystemName(_ subsystem: SubsystemModel?) -> String?
  func fetchSubsystems(_ placeId: String) -> PMKPromise
  func getName(_ subsystem: SubsystemModel) -> String
  func getVersion(_ subsystem: SubsystemModel) -> String
  func getHash(_ subsystem: SubsystemModel) -> String
  func getAccount(_ subsystem: SubsystemModel) -> String
  func getPlace(_ subsystem: SubsystemModel) -> String
  func getAvailable(_ subsystem: SubsystemModel) -> Bool
  func getStateFromModel(_ subsystem: SubsystemModel) -> String
  func activate(_ subsystem: SubsystemModel) -> PMKPromise
  func suspend(_ subsystem: SubsystemModel) -> PMKPromise
  func delete(_ subsystem: SubsystemModel) -> PMKPromise
  func fetchSubsystemHistory(_ subsystem: SubsystemModel,
                             token: String,
                             limit: Int32) -> PMKPromise
  func subsystemMultipleCapabilityInstances(_ subsystemModel: SubsystemModel) -> [SubsystemModel]?
  func updateParentSubystem(_ alarmModel: AlarmModel, parentSubsystem: SubsystemModel)
}

extension SubsystemController {
  func subsystemName(_ subsystem: SubsystemModel?) -> String? {
    guard subsystem != nil else {
      return nil
    }
    return SubsystemCapabilityLegacy.getName(subsystem!)
  }

  func fetchSubsystems(_ placeId: String) -> PMKPromise {
    return SubsystemService.listSubsystems(withPlaceId: placeId)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
      .swiftCatch({ error in
        return PMKPromise.new {
          (_: PMKFulfiller?, rejecter: PMKRejecter?) in
          if let rejectError = error as? NSError {
            rejecter?(rejectError)
          }
        }
      })
  }

  func getName(_ subsystem: SubsystemModel) -> String {
    guard let name = SubsystemCapabilityLegacy.getName(subsystem) else { return "" }
    return name
  }

  func getVersion(_ subsystem: SubsystemModel) -> String {
    guard let version = SubsystemCapabilityLegacy.getVersion(subsystem) else { return "" }
    return version
  }

  func getHash(_ subsystem: SubsystemModel) -> String {
    guard let hash = SubsystemCapabilityLegacy.getHash(subsystem) else { return "" }
    return hash
  }

  func getAccount(_ subsystem: SubsystemModel) -> String {
    guard let account = SubsystemCapabilityLegacy.getAccount(subsystem) else { return "" }
    return account
  }

  func getPlace(_ subsystem: SubsystemModel) -> String {
    guard let place = SubsystemCapabilityLegacy.getPlace(subsystem) else { return "" }
    return place
  }

  func getAvailable(_ subsystem: SubsystemModel) -> Bool {
    guard let isAvailable = SubsystemCapabilityLegacy
      .getAvailable(subsystem)?.boolValue else { return false }
    return isAvailable
  }

  func getStateFromModel(_ subsystem: SubsystemModel) -> String {
    guard let state = SubsystemCapabilityLegacy.getState(subsystem) else { return "" }
    return state
  }

  func activate(_ subsystem: SubsystemModel) -> PMKPromise {
    return SubsystemCapabilityLegacy.activate(subsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func suspend(_ subsystem: SubsystemModel) -> PMKPromise {
    return SubsystemCapabilityLegacy.suspend(subsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func delete(_ subsystem: SubsystemModel) -> PMKPromise {
    return SubsystemCapabilityLegacy.delete(subsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func fetchSubsystemHistory(_ subsystem: SubsystemModel,
                             token: String,
                             limit: Int32) -> PMKPromise {
    // TODO: includeIncidents hard-coded value should be replaced with a parameter.
    return SubsystemCapabilityLegacy.listHistoryEntries(subsystem, limit: Int(limit), token: token, includeIncidents: true)
      .swiftThenInBackground({
        (response: Any?) -> (PMKPromise?) in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  // MARK: Multiple Capability Instance Support

  func subsystemMultipleCapabilityInstances(_ subsystemModel: SubsystemModel) -> [SubsystemModel]? {
    guard let instances: [String : AnyObject] = subsystemModel.get() as? [String : AnyObject],
      let attributes: [String : AnyObject] = subsystemModel.get() as? [String : AnyObject]
      else {
        return nil
    }
    return multipleCapabilityInstanceModels(attributes, instances: instances)
  }

  func updateParentSubystem(_ alarmModel: AlarmModel, parentSubsystem: SubsystemModel) {
    if let parentAttributes: [String : AnyObject] =
      MultiCapabilityInstancedModelFactory.parentAttributes(alarmModel) {
      parentSubsystem.set(parentAttributes)
    }
  }

  fileprivate func multipleCapabilityInstanceModels(_ attributes: [String: AnyObject],
                                                    instances: [String : AnyObject]) -> [SubsystemModel] {
    var subsystemModels: [SubsystemModel] = [SubsystemModel]()

    for (instanceType, capabilities) in instances {
      guard let capabilityFilters: [String] = capabilities as? [String] else {
        continue
      }
      if let model: SubsystemModel = filteredSubsystemModel(attributes,
                                                            instanceType: instanceType,
                                                            capabilityFilters: capabilityFilters) {
        subsystemModels.append(model)
      }
    }
    return subsystemModels
  }

  fileprivate func filteredSubsystemModel(_ attributes: [String: AnyObject],
                                          instanceType: String,
                                          capabilityFilters: [String]) -> SubsystemModel? {
    if let model: SubsystemModel = MultiCapabilityInstancedModelFactory
      .createFilteredSubsystemModel(attributes,
                                    instanceFilter: instanceType,
                                    attributesFilters: capabilityFilters) {
      return model
    }
    return nil
  }
}
