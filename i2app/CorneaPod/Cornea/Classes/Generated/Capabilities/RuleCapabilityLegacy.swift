
//
// RuleCapabilityLegacy.swift
//
// Generated on 20/09/18
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

import Foundation
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class RuleCapabilityLegacy: NSObject, ArcusRuleCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: RuleCapabilityLegacy  = RuleCapabilityLegacy()
  
  static let RuleStateENABLED: String = RuleState.enabled.rawValue
  static let RuleStateDISABLED: String = RuleState.disabled.rawValue
  

  
  public static func getName(_ model: RuleModel) -> String? {
    return capability.getRuleName(model)
  }
  
  public static func setName(_ name: String, model: RuleModel) {
    
    
    capability.setRuleName(name, model: model)
  }
  
  public static func getDescription(_ model: RuleModel) -> String? {
    return capability.getRuleDescription(model)
  }
  
  public static func setDescription(_ description: String, model: RuleModel) {
    
    
    capability.setRuleDescription(description, model: model)
  }
  
  public static func getCreated(_ model: RuleModel) -> Date? {
    guard let created: Date = capability.getRuleCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: RuleModel) -> Date? {
    guard let modified: Date = capability.getRuleModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func getState(_ model: RuleModel) -> String? {
    return capability.getRuleState(model)?.rawValue
  }
  
  public static func getTemplate(_ model: RuleModel) -> String? {
    return capability.getRuleTemplate(model)
  }
  
  public static func getContext(_ model: RuleModel) -> Any? {
    return capability.getRuleContext(model)
  }
  
  public static func enable(_ model: RuleModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRuleEnable(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disable(_ model: RuleModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRuleDisable(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateContext(_  model: RuleModel, context: Any, template: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestRuleUpdateContext(model, context: context, template: template))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: RuleModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRuleDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHistoryEntries(_  model: RuleModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestRuleListHistoryEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
