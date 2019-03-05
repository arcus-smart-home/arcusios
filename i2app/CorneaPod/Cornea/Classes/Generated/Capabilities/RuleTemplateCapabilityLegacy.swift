
//
// RuleTemplateCapabilityLegacy.swift
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

public class RuleTemplateCapabilityLegacy: NSObject, ArcusRuleTemplateCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: RuleTemplateCapabilityLegacy  = RuleTemplateCapabilityLegacy()
  

  
  public static func getKeywords(_ model: RuleTemplateModel) -> [String]? {
    return capability.getRuleTemplateKeywords(model)
  }
  
  public static func getAdded(_ model: RuleTemplateModel) -> Date? {
    guard let added: Date = capability.getRuleTemplateAdded(model) else {
      return nil
    }
    return added
  }
  
  public static func getLastModified(_ model: RuleTemplateModel) -> Date? {
    guard let lastModified: Date = capability.getRuleTemplateLastModified(model) else {
      return nil
    }
    return lastModified
  }
  
  public static func getTemplate(_ model: RuleTemplateModel) -> String? {
    return capability.getRuleTemplateTemplate(model)
  }
  
  public static func getSatisfiable(_ model: RuleTemplateModel) -> NSNumber? {
    guard let satisfiable: Bool = capability.getRuleTemplateSatisfiable(model) else {
      return nil
    }
    return NSNumber(value: satisfiable)
  }
  
  public static func getName(_ model: RuleTemplateModel) -> String? {
    return capability.getRuleTemplateName(model)
  }
  
  public static func getDescription(_ model: RuleTemplateModel) -> String? {
    return capability.getRuleTemplateDescription(model)
  }
  
  public static func getCategories(_ model: RuleTemplateModel) -> [String]? {
    return capability.getRuleTemplateCategories(model)
  }
  
  public static func getPremium(_ model: RuleTemplateModel) -> NSNumber? {
    guard let premium: Bool = capability.getRuleTemplatePremium(model) else {
      return nil
    }
    return NSNumber(value: premium)
  }
  
  public static func getExtra(_ model: RuleTemplateModel) -> String? {
    return capability.getRuleTemplateExtra(model)
  }
  
  public static func createRule(_  model: RuleTemplateModel, placeId: String, name: String, description: String, context: Any) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestRuleTemplateCreateRule(model, placeId: placeId, name: name, description: description, context: context))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resolve(_  model: RuleTemplateModel, placeId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestRuleTemplateResolve(model, placeId: placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
