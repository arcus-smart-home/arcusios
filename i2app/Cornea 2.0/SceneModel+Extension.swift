//
//  SceneModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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
import ObjectiveC
import Cornea

extension Constants {
  static let kContext: String = "context"
  static let kTemplate: String = "template"
}

fileprivate struct AssociatedKeys {
  static var kSceneIsEmpty: UInt8 = 0
}

// MARK: Dynamic Properties Extension

extension SceneModel {
  var isEmpty: Bool {
    get {
      guard let _ = ScheduleController.static().getSchedulerForModel(withAddress: self.address) else {
        return false
      }

      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.kSceneIsEmpty) as? Bool else {
        return false
      }
      return value
    }
    set {
      objc_setAssociatedObject(self,
                               &AssociatedKeys.kSceneIsEmpty,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

// MARK: SceneModel Extension

extension SceneModel {

  override public var name: String {
    guard let name = SceneCapabilityLegacy.getName(self) else { return "" }

    return name
  }

  func sceneDescription() -> String? {
    return SceneCapabilityLegacy.getName(self) // WUT?
  }

  func setSceneIsEmpty(_ isEmpty: Bool) {
      self.isEmpty = isEmpty
  }

  func getTemplateName() -> String? {
    return SceneCapabilityLegacy.getTemplate(self) // WUT?
  }

  func getTemplateType() -> SceneModelTemplateType {
    if let template = getTemplateName() {
      if template == "home" {
        return .home
      } else if template == "away" {
        return .away
      } else if template == "custom" {
        return .custom
      } else if template == "morning" {
        return .morning
      } else if template == "night" {
        return .night
      } else if template == "vacation" {
        return .vacation
      }
      return .custom
    }
    return .custom
  }

  // MARK: Devices for SceneAction

  func numberOfSelectorsForSceneAction(_ sceneAction: SceneAction) -> String? {
    var count = 0
    if let sceneActions = SceneCapabilityLegacy.getActions(self) as? [[AnyHashable: Any]] {
      for action: [AnyHashable: Any] in sceneActions {
        if let actionId = sceneAction.actionId as String?,
          let templateId = action[Constants.kTemplate] as? String {
          if actionId == templateId {
            if let context = action[Constants.kContext] as? [AnyHashable: Any] {
              count += context.count
            }
          }
        }
      }

      if count > 0 {
        return String(describing: count)
      }
    }
    return ""
  }

  func getSelectorContext(_ selectorId: String) -> Dictionary<AnyHashable, Any>? {
    if let sceneActions = SceneCapabilityLegacy.getActions(self) as? [[AnyHashable: Any]] {
      for action: [AnyHashable: Any] in sceneActions {
        if let actionId = SceneManager.sharedInstance().currentAction.actionId as String?,
          let templateId = action[Constants.kTemplate] as? String {
          if actionId == templateId {
            if let context = action[Constants.kContext] as? [AnyHashable: Any] {
              return context[selectorId] as? [AnyHashable: Any]
            }
          }
        }
      }
    }
    return nil
  }

  func getListOfSelectorsForSceneAction(_ sceneAction: SceneAction) -> [AnyObject]? {
    if let sceneActions = SceneCapabilityLegacy.getActions(self) as? [[AnyHashable: Any]] {
      var devices = [AnyObject]()
      for action in sceneActions {
        if let actionId = sceneAction.actionId as String?,
          let templateId = action[Constants.kTemplate] as? String {
          if actionId == templateId {
            devices.append(action as AnyObject)
          }
        }
      }
      return devices
    }
    return nil
  }

  // TODO: Refactor!
  func getSelectorValue(_ selector: SceneActionSelector, atIndex: Int) -> String? {
    // First, check the template if the selector can have a value
    // From the template, get the selectors parameters
    if let selectorTemplate = SceneManager.sharedInstance().currentAction
      .getSelectorForDeviceAddress(selector.selectorId) {
      if selectorTemplate.attributes.count > 0 {
        let selectorAttributes = selectorTemplate.attributes[0]
        if let selectorValues = selectorAttributes.value,
          let attributeValues = selectorValues.allAttributeValues {
          if attributeValues.count > atIndex {
            if let selectors = getSelectorContext(selector.selectorId) {
              let attribs = attributeValues[atIndex]
              let attributeName = selectorAttributes.name

              for context in selectors.keys {
                guard let context = context as? String else { continue }

                // get the configurable parameter
                if attributeName != context {
                  // attributeValues[0][1][0]["type"] == "TEMPERATURE"
                  if let avL2 = attributeValues[0][1] as? [Any],
                    let avL3 = avL2[0] as? [AnyHashable: Any],
                    let value = avL3["type"] as? String {
                    if value == "TEMPERATURE" {
                      if let temp = selectors[context] as? NSNumber {
                        return self.temperatureString(temp)
                      }
                    }
                  } else {
                    if let attributeValue: SceneActionSelectorAttribute = selectorTemplate.attributes[0] {
                      if attributeValue.name == "fan" {
                        if let speed = selectors[context] as? NSNumber {
                          return self.fanSpeedString(speed)
                        }
                      }
                    }
                  }
                  return "\(selectors[context]!)"
                }
              }
            }
          }
        } else {
          let selectors = getSelectorContext(selector.selectorId)
          if let attributeValue: SceneActionSelectorAttribute = selectorTemplate.attributes[0] {
            if attributeValue.type == SceneActionSelectorTypeDuration {
              return "\(selectors?["duration"] ?? 0)"
            }
          }
        }
      } 
    }
    return nil
  }

  func temperatureString(_ temperatureInC: NSNumber) -> String? {
    if let tempInF: Double = DeviceController.celsius(toFahrenheit: temperatureInC.doubleValue) {
      return "\(tempInF)°"
    }
    return nil
  }

  func fanSpeedString(_ speed: NSNumber) -> String {
    switch speed.intValue {
    case 1:
      return NSLocalizedString("Low", comment: "")
    case 2:
      return NSLocalizedString("Med", comment: "")
    case 3:
      return NSLocalizedString("High", comment: "")
    default:
      return NSLocalizedString("Unsupported", comment: "")
    }
  }

  func getCurrentSceneActionContext() -> [AnyHashable: Any] {
    if let actions = SceneCapabilityLegacy.getActions(self) as? [[AnyHashable: Any]],
      let actionId = SceneManager.sharedInstance().currentAction.actionId as String? {
      for action in actions {
        if let templateId = action[Constants.kTemplate] as? String,
          actionId == templateId {
          if let context = action[Constants.kContext] as? [AnyHashable: Any] {
            return context
          }
        }
      }
    }
    return [AnyHashable: Any]()
  }

  func removeCurrentActionContext() -> [[AnyHashable: Any]]? {
    if var sceneActions = SceneCapabilityLegacy.getActions(self) as? [[AnyHashable: Any]],
      let actionId = SceneManager.sharedInstance().currentAction.actionId as String? {
      var index = -1
      for action in sceneActions {
        if let templateId = action[Constants.kTemplate] as? String,
          actionId == templateId {
          if let actionIndex = sceneActions.index(where: {
            if let compareTemplateId = $0[Constants.kTemplate] as? String {
              return compareTemplateId == templateId
            }
            return false
          }) {
            index = actionIndex
          }
        }
      }
      if index >= 0 {
        sceneActions.remove(at: index)
      }
      
      SceneCapabilityLegacy.setActions(sceneActions, model: self)
      return sceneActions
    }
    return nil
  }

  // MARK: Saving SceneModel
  // TODO: Refactor Entire Method.
  func saveSelectorList(_ selectedSelectors: NSArray,
                        unselectedSelectors: NSArray,
                        withIndex: Int) -> PMKPromise {
    guard let currentAction = SceneManager.sharedInstance().currentAction else {
      return PMKPromise.new { (_: PMKFulfiller?, rejector: PMKRejecter?) in
        rejector?(nil)
      }
    }

    var context = getCurrentSceneActionContext()

    for selector in selectedSelectors {
      guard let selectorDefault = selector as? SceneActionSelectorDefault else { continue }

      // From the template, get the selectors parameters
      let selectorTemplate = currentAction.getSelectorForDeviceAddress(selectorDefault.address)
      if let attributes = selectorTemplate?.attributes,
        attributes.count > 0 {
        let sceneAttributes = attributes[0]
        if sceneAttributes.type == SceneActionSelectorTypeThermostat {
          // This is a thermostat

          var dict: [AnyHashable: Any]?
          if let selectorDefaultAttributes = selectorDefault.attributes {
            if selectorDefaultAttributes.count > 0 {
              dict = selectorDefaultAttributes
            } else {
              dict = [selectorDefault.initialParam: selectorDefault.initialValue]
            }
          } else {
            dict = [selectorDefault.initialParam: selectorDefault.initialValue]
          }

          // TODO:  This overrides if statement above, is conditional needed?
          dict = [sceneAttributes.name: dict as Any]
          context[selectorDefault.address] = dict
        } else {
          var title: Any? = nil
          if sceneAttributes.value != nil {
            // These are actions that have multiple states ("On"/"Off" or "Lock"/"Unlock", etc.)
            if let attribValues = sceneAttributes.value.allAttributeValues {
              if attribValues.count > withIndex {
                let attribs = attribValues[withIndex]
                title = attribs[kSceneAttributeTitle]
              }
            }
          } else {
            // These are actions that have a single state (Thermostat, camera, etc)
            if selectorDefault.initialValue != nil && selectorDefault.initialParam != nil {
              title = [selectorDefault.initialParam: selectorDefault.initialValue]
            } else if sceneAttributes.type == SceneActionSelectorTypeThermostat {
              title = [AnyHashable: Any]()
            }
          }

          var dict: [AnyHashable: Any]? = [:]
          var groupAttribName: String?

          if sceneAttributes.type == SceneActionSelectorTypeGroup {
            groupAttribName = sceneAttributes.name
          }

          if selectorDefault.initialValue == nil && selectorDefault.initialParam == nil,
            let address = selectorDefault.address, context[address] != nil,
            let key = groupAttribName,
            let value = title {
            dict = [key: value]
          } else {
            // if the selector is currently in the list and has the same value
            // skip adding the initial value/parameter pair
            let address: String = selectorDefault.address
            dict = context[address] as? [AnyHashable : Any]

            var result: Bool = false
            if let dict = dict,
              let attribute = groupAttribName,
              let groupName = dict[attribute] as? String,
              let compareTitle = title as? String {

              result = groupName != compareTitle
            }

            if dict == nil || result {
              // add the initial value/parameter.
              if selectorDefault.initialParam == nil {
                // We need to retrieve the initial parameter from the template
                // selector?.attributes[withIndex].attributeValues.first![1][0]["name"]  Really?
                if let selector = currentAction.getSelectorForDeviceAddress(selectorDefault.address),
                  let selectorAttributes = selector.attributes,
                  withIndex < selectorAttributes.count,
                  let attributeValues: [Any] = selectorAttributes[withIndex].attributeValues,
                  attributeValues.count > 0,
                  let avL1 = attributeValues[0] as? [Any], avL1.count > 1,
                  let avL2 = avL1[1] as? [Any], avL2.count > 0,
                  let avL3 = avL2[0] as? [AnyHashable: Any],
                  let value = avL3["name"] as? String {
                    selectorDefault.initialParam = value
                } else {
                  selectorDefault.initialParam = nil
                }

                if selectorDefault.initialParam == nil {
                  selectorDefault.initialParam = sceneAttributes.name
                }
              }

              if let initialParam = selectorDefault.initialParam,
                let initialValue = selectorDefault.initialValue {
                if let key: String = groupAttribName, let value = title {
                  if key != initialParam  {
                    dict = [key: value, initialParam: initialValue]
                  } else {
                    dict = [key: value]
                  }
                } else {
                  dict = [initialParam: initialValue]
                }
              } else if let key = groupAttribName, let value = title {
                dict = [key: value]
              }
            }
          }

          if let address = selectorDefault.address {
            context[address] = dict
          }
        }
      }
    }

    // Remove the current action
    
    for selector in unselectedSelectors {
      if let index = selector as? String {
        context[index] = nil
      }
    }
    
    if var sceneActions = removeCurrentActionContext() {
      if context.count > 0 {
        let jsonDict: [AnyHashable: Any] = ["template": currentAction.actionId,
                                            "name": currentAction.name,
                                            "context": context]
        sceneActions.append(jsonDict)
        SceneCapabilityLegacy.setActions(sceneActions, model: self)
      }
      return commit().swiftThen {
        response in
        return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          //Tag Edit Scene
          ArcusAnalytics.tag(AnalyticsTags.SceneEdit, attributes: [:])

          fulfiller?(response)
        }
      }
    }

    return PMKPromise.new { (_: PMKFulfiller?, rejector: PMKRejecter?) in
      rejector?(nil)
    }
  }

  func saveSelectorValue(_ selector: SceneActionSelector, newValue: Any, forIndex: Int) -> PMKPromise {
    guard let currentAction = SceneManager.sharedInstance().currentAction else {
      return PMKPromise.new { (_: PMKFulfiller?, rejector: PMKRejecter?) in
        rejector?(nil)
      }
    }

    var context: [AnyHashable: Any]? = getCurrentSceneActionContext()

    if currentAction.type != SceneActionTypeSecurity
      && currentAction.type != SceneActionTypeThermostat,
      var selectorAttributes = context?[selector.selectorId] as? [AnyHashable: Any] {

      var name: String = ""

      if selector.attributes[forIndex].attributeValues == nil {
        name = selector.attributes[forIndex].name
      } else {
        if let selectorAttribs = selector.attributes,
          let attributeValues: [Any] = selectorAttribs[forIndex].attributeValues,
          let avL1 = attributeValues[0] as? [Any],
          let avL2 = avL1[1] as? [Any],
          let avL3 = avL2[0] as? [AnyHashable: Any],
          let value = avL3["name"] as? String {
          name = value
        }
      }

      if selectorAttributes["name"] != nil {
        selectorAttributes["name"] = nil
      }

      selectorAttributes[name] = newValue
      context?[selector.selectorId] = selectorAttributes
    } else {
      if currentAction.type == SceneActionTypeSecurity {
        if var stringValue = newValue as? String,
          stringValue.count > 0 {
          // This is security action
          /*[{
                     "context": {
                           "SERV:subsecurity:b7a602bf-c387-4fec-922f-08ceab2b24e0": {
                                 "alarm-state": "ON"
                           }
                     },
                     "name": "Set the Security Alarm",
                     "template": "security"
               }] */
          let name = selector.attributes[0].name
          if stringValue == "Arm On" {
            stringValue = "ON"
          } else if stringValue == "Arm Partial" {
            stringValue = "PARTIAL"
          } else if stringValue == "Disarm" {
            stringValue = "OFF"
          }
          if let selectorId = selector.selectorId {
            let dict: [AnyHashable: Any] = [name!: stringValue.uppercased()]
            context?[selectorId] = dict
          }
        } else {
          context = nil
        }
      } else if currentAction.type == SceneActionTypeThermostat {
        /*{
         "context": {
         "DRIV:dev:b7a602bf-c387-4fec-922f-08ceab2b24e0": {
         "scheduleEnabled": false,
         "mode": "AUTO",
         "coolSetPoint": 25.6,
         "heatSetPoint": 21.1
         }
         },
         "template": "thermostat"
         }]*/
        if let _ = newValue as? [AnyHashable: Any],
          let selectorTemplate = currentAction.getSelectorForDeviceAddress(selector.selectorId) {
          if selectorTemplate.attributes.count > 0 {
            let sceneAttributes = selectorTemplate.attributes[0]
            context?[selector.selectorId] = [sceneAttributes.name: newValue]
          }
        }
      }
    }

    // Remove the current action
    if var sceneActions = removeCurrentActionContext() {
      if context != nil {
        let jsonDict: [AnyHashable: Any] = ["template": currentAction.actionId,
                        "name": currentAction.name,
                        "context": context as Any]
        sceneActions.append(jsonDict)
      }

      SceneCapabilityLegacy.setActions(sceneActions, model: self)
      return commit().swiftThen { response in
        return PMKPromise.new { (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          //Tag Edit Scene
          ArcusAnalytics.tag(AnalyticsTags.SceneEdit, attributes: [:])

          fulfiller?(response)
        }
      }
    }

    return PMKPromise.new { (_: PMKFulfiller?, rejector: PMKRejecter?) in
      rejector?(nil)
    }
  }
}
