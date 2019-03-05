
//
// RuleCap.swift
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
  public static var ruleNamespace: String = "rule"
  public static var ruleName: String = "Rule"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let ruleName: String = "rule:name"
  static let ruleDescription: String = "rule:description"
  static let ruleCreated: String = "rule:created"
  static let ruleModified: String = "rule:modified"
  static let ruleState: String = "rule:state"
  static let ruleTemplate: String = "rule:template"
  static let ruleContext: String = "rule:context"
  
}

public protocol ArcusRuleCapability: class, RxArcusService {
  /** The name of the rule */
  func getRuleName(_ model: RuleModel) -> String?
  /** The name of the rule */
  func setRuleName(_ name: String, model: RuleModel)
/** User provided description of the rule */
  func getRuleDescription(_ model: RuleModel) -> String?
  /** User provided description of the rule */
  func setRuleDescription(_ description: String, model: RuleModel)
/** Timestamp that the rule was created */
  func getRuleCreated(_ model: RuleModel) -> Date?
  /** Timestamp that the rule was last modified */
  func getRuleModified(_ model: RuleModel) -> Date?
  /** The current state of the rule */
  func getRuleState(_ model: RuleModel) -> RuleState?
  /** The platform-owned identifier for the template this rule was created from (if a template based rule) */
  func getRuleTemplate(_ model: RuleModel) -> String?
  /** The context for rule evaluation, if no user defined context is required this is may be null or empty */
  func getRuleContext(_ model: RuleModel) -> Any?
  
  /** Enables the rule if it is disabled */
  func requestRuleEnable(_ model: RuleModel) throws -> Observable<ArcusSessionEvent>/** Disables the rule if it is enabled */
  func requestRuleDisable(_ model: RuleModel) throws -> Observable<ArcusSessionEvent>/** Updates the context for the rule */
  func requestRuleUpdateContext(_  model: RuleModel, context: Any, template: String)
   throws -> Observable<ArcusSessionEvent>/** Deletes the rule */
  func requestRuleDelete(_ model: RuleModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this rule */
  func requestRuleListHistoryEntries(_  model: RuleModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusRuleCapability {
  public func getRuleName(_ model: RuleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleName] as? String
  }
  
  public func setRuleName(_ name: String, model: RuleModel) {
    model.set([Attributes.ruleName: name as AnyObject])
  }
  public func getRuleDescription(_ model: RuleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleDescription] as? String
  }
  
  public func setRuleDescription(_ description: String, model: RuleModel) {
    model.set([Attributes.ruleDescription: description as AnyObject])
  }
  public func getRuleCreated(_ model: RuleModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.ruleCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRuleModified(_ model: RuleModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.ruleModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getRuleState(_ model: RuleModel) -> RuleState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.ruleState] as? String,
      let enumAttr: RuleState = RuleState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getRuleTemplate(_ model: RuleModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleTemplate] as? String
  }
  
  public func getRuleContext(_ model: RuleModel) -> Any? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.ruleContext] as? Any
  }
  
  
  public func requestRuleEnable(_ model: RuleModel) throws -> Observable<ArcusSessionEvent> {
    let request: RuleEnableRequest = RuleEnableRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRuleDisable(_ model: RuleModel) throws -> Observable<ArcusSessionEvent> {
    let request: RuleDisableRequest = RuleDisableRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRuleUpdateContext(_  model: RuleModel, context: Any, template: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: RuleUpdateContextRequest = RuleUpdateContextRequest()
    request.source = model.address
    
    
    
    request.setContext(context)
    
    request.setTemplate(template)
    
    return try sendRequest(request)
  }
  
  public func requestRuleDelete(_ model: RuleModel) throws -> Observable<ArcusSessionEvent> {
    let request: RuleDeleteRequest = RuleDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestRuleListHistoryEntries(_  model: RuleModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: RuleListHistoryEntriesRequest = RuleListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
}
