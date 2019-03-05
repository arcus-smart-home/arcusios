
//
// RuleTemplateCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var ruleTemplateNamespace: String = "ruletmpl"
  public static var ruleTemplateName: String = "RuleTemplate"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let ruleTemplateKeywords: String = "ruletmpl:keywords"
  static let ruleTemplateAdded: String = "ruletmpl:added"
  static let ruleTemplateLastModified: String = "ruletmpl:lastModified"
  static let ruleTemplateTemplate: String = "ruletmpl:template"
  static let ruleTemplateSatisfiable: String = "ruletmpl:satisfiable"
  static let ruleTemplateName: String = "ruletmpl:name"
  static let ruleTemplateDescription: String = "ruletmpl:description"
  static let ruleTemplateCategories: String = "ruletmpl:categories"
  static let ruleTemplatePremium: String = "ruletmpl:premium"
  static let ruleTemplateExtra: String = "ruletmpl:extra"
  
}

public protocol ArcusRuleTemplateCapability: class, RxArcusService {
  /** Set of keywords for the template */
  func getRuleTemplateKeywords(_ model: RuleTemplateModel) -> [String]?
  /** Timestamp that the rule template was added to the catalog */
  func getRuleTemplateAdded(_ model: RuleTemplateModel) -> Date?
  /** Timestamp that the rule template was last modified */
  func getRuleTemplateLastModified(_ model: RuleTemplateModel) -> Date?
  /** The textual template */
  func getRuleTemplateTemplate(_ model: RuleTemplateModel) -> String?
  /** True if the rule template is satisfiable for the specific place for which they have been loaded. */
  func getRuleTemplateSatisfiable(_ model: RuleTemplateModel) -> Bool?
  /** The name of the rule template */
  func getRuleTemplateName(_ model: RuleTemplateModel) -> String?
  /** A description of the rule template */
  func getRuleTemplateDescription(_ model: RuleTemplateModel) -> String?
  /** The set of categories that this rule template is part of */
  func getRuleTemplateCategories(_ model: RuleTemplateModel) -> [String]?
  /** Indicates if the rule is available only for premium plans. */
  func getRuleTemplatePremium(_ model: RuleTemplateModel) -> Bool?
  /** Extra text associated with the rule. */
  func getRuleTemplateExtra(_ model: RuleTemplateModel) -> String?
  
  /** Creates a rule instance from a given rule template */
  func requestRuleTemplateCreateRule(_  model: RuleTemplateModel, placeId: String, name: String, description: String, context: Any)
   throws -> Observable<ArcusSessionEvent>/** Resolves the parameters for the template at a given place */
  func requestRuleTemplateResolve(_  model: RuleTemplateModel, placeId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusRuleTemplateCapability {
  public func getRuleTemplateKeywords(_ model: RuleTemplateModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateKeywords] as? [String]
  }
  
  public func getRuleTemplateAdded(_ model: RuleTemplateModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.ruleTemplateAdded] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRuleTemplateLastModified(_ model: RuleTemplateModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.ruleTemplateLastModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRuleTemplateTemplate(_ model: RuleTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateTemplate] as? String
  }
  
  public func getRuleTemplateSatisfiable(_ model: RuleTemplateModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateSatisfiable] as? Bool
  }
  
  public func getRuleTemplateName(_ model: RuleTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateName] as? String
  }
  
  public func getRuleTemplateDescription(_ model: RuleTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateDescription] as? String
  }
  
  public func getRuleTemplateCategories(_ model: RuleTemplateModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateCategories] as? [String]
  }
  
  public func getRuleTemplatePremium(_ model: RuleTemplateModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplatePremium] as? Bool
  }
  
  public func getRuleTemplateExtra(_ model: RuleTemplateModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplateExtra] as? String
  }
  
  
  public func requestRuleTemplateCreateRule(_  model: RuleTemplateModel, placeId: String, name: String, description: String, context: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: RuleTemplateCreateRuleRequest = RuleTemplateCreateRuleRequest()
    request.source = model.address
    
    
    
    request.setPlaceId(placeId)
    
    request.setName(name)
    
    request.setDescription(description)
    
    request.setContext(context)
    
    return try sendRequest(request)
  }
  
  public func requestRuleTemplateResolve(_  model: RuleTemplateModel, placeId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: RuleTemplateResolveRequest = RuleTemplateResolveRequest()
    request.source = model.address
    
    
    
    request.setPlaceId(placeId)
    
    return try sendRequest(request)
  }
  
}
