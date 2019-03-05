//
//  MultiCapabilityInstancedModelFactory.swift
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
import Foundation
import Cornea

var kMultiInstanceTypeKey = "multiInstanceType"

class MultiCapabilityInstancedModelFactory {
  /**
   Static func used to create SubsystemModel object based on supplied attributes & filters.

   - Parameters:
   - attributes: The attributes containing Multiple Capability Instances.
   - instanceFilter: A string specifying which Instance to filter into a Model.
   - attributesFilters: An array of capability attribute types that the Instance supports.

   - Returns: New SubsystemModel object based on the filtered attributes.
   */
  static func createFilteredSubsystemModel(_ attributes: [String : AnyObject],
                                           instanceFilter: String,
                                           attributesFilters: [String]) -> SubsystemModel? {
    if let model = MultiCapabilityInstancedModelFactory
      .createModel(attributes,
                   instanceFilter: instanceFilter,
                   attributesFilters: attributesFilters) {
      return SubsystemModel(attributes: model.get())
    }
    return nil
  }

  /**
   Static func used to create AlarmModel object based on supplied attributes & filters.

   - Parameters:
   - attributes: The attributes containing Multiple Capability Instances.
   - instanceFilter: A string specifying which Instance to filter into a Model.
   - attributesFilters: An array of capability attribute types that the Instance supports.

   - Returns: New AlarmModel object based on the filtered attributes.
   */
  static func createAlarmModel(_ attributes: [String : AnyObject],
                               instanceFilter: String,
                               attributesFilters: [String]) -> AlarmModel? {
    if let model = MultiCapabilityInstancedModelFactory
      .createModel(attributes,
                   instanceFilter: instanceFilter,
                   attributesFilters: attributesFilters) {
      return AlarmModel(attributes:  model.get())
    }
    return nil
  }

  static func createCameraModel(_ attributes: [String : AnyObject],
                                instanceFilter: String,
                                attributesFilters: [String]) -> CameraStatusModel? {
    if let model = MultiCapabilityInstancedModelFactory
      .createModel(attributes,
                   instanceFilter: instanceFilter,
                   attributesFilters: attributesFilters) {
      return CameraStatusModel(attributes: model.get())
    }
    return nil
  }

  // swiftlint:disable line_length
  /**
   Static func used to create generic Model object based on supplied attributes & filters.
   For more info: 
   https://eyeris.atlassian.net/wiki/display/I2D/Multiple+Capability+Instances#MultipleCapabilityInstances-Multi-Instance

   - Parameters:
    - attributes: The attributes containing Multiple Capability Instances.
    - instanceFilter: A string specifying which Instance to filter into a Model.
    - attributesFilters: An array of capability attribute types that the Instance supports.

   - Returns: New Model object based on the filtered attributes.
  */
  // swiftlint:enable line_length
  static func createModel(_ attributes: [String : AnyObject],
                          instanceFilter: String,
                          attributesFilters: [String]) -> Model? {
    var resultModel: Model? = nil

    // filter subsystem attributes down to alarm-based attributes and the selected instanceType
    let filteredAttributes = attributes.filter({
      if $0.0.contains(instanceFilter) {
        let attributeKey = $0.0
        if attributesFilters.contains(where: { attributeKey.contains($0) }) {
          return true
        }
      }
      return false
    })

    if filteredAttributes.count > 0 {
      // convert [String : AnyObject] to the required [NSObject : AnyObject]
      // & trim the instanceType from attributes
      var convertedAttributes = [String: AnyObject]()

      for (key, value) in filteredAttributes {
        let typelessKey = key.replacingOccurrences(of: ":" + instanceFilter,
                                                                   with: "",
                                                                   options: .literal,
                                                                   range: nil)
        convertedAttributes[typelessKey] = value
      }

      // Add Key/Value Pair to allow for the AlarmModel to be identified by type.
      convertedAttributes[kMultiInstanceTypeKey] = instanceFilter as AnyObject

      resultModel = Model(attributes: convertedAttributes)
    }

    return resultModel
  }

  // swiftlint:disable line_length
  /**
   Static func used to create attributes from a Multiple Capability Instance that
   can be passed back to the parent Model that the attributes were originally derived from.
   For more info: https://eyeris.atlassian.net/wiki/display/I2D/Multiple+Capability+Instances#MultipleCapabilityInstances-Multi-Instance

   - Parameters: A Model object representing Multiple Capability Instance.

   - Returns: An Attributes dictionary which can be passed back to the Parent Model.
   */
  // swiftlint:enable line_length
  static func parentAttributes(_ multiInstance: Model) -> [String : AnyObject]? {
    var result: [String : AnyObject]?

    let attributes = multiInstance.changes
    let instanceType = multiInstance.getAttribute(kMultiInstanceTypeKey) as? String

    if attributes.count > 0 && instanceType != nil {
      result = [String: AnyObject]()
      for (key, value) in attributes {
        if key == kMultiInstanceTypeKey {
          continue
        }

        result![key + ":" + instanceType!] = value
      }
    }

    return result
  }
}
