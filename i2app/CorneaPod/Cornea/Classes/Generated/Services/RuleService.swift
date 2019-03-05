
//
// RuleService.swift
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
  public static let ruleServiceNamespace: String = "rule"
  public static let ruleServiceName: String = "RuleService"
  public static let ruleServiceAddress: String = "SERV:rule:"
}

/** Entry points for the rule service, which covers global operations such as listing rules or rule templates for places. */
public protocol ArcusRuleService: RxArcusService {
  /** Lists all rule templates available for a given place */
  func requestRuleServiceListRuleTemplates(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Lists all rules defined for a given place */
  func requestRuleServiceListRules(_ placeId: String) throws -> Observable<ArcusSessionEvent>/** Returns a map containing the names of the categories and counts of available rules */
  func requestRuleServiceGetCategories(_ placeId: String) throws -> Observable<ArcusSessionEvent>/**  */
  func requestRuleServiceGetRuleTemplatesByCategory(_ placeId: String, category: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusRuleService {
  public func requestRuleServiceListRuleTemplates(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: RuleServiceListRuleTemplatesRequest = RuleServiceListRuleTemplatesRequest()
    request.source = Constants.ruleServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestRuleServiceListRules(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: RuleServiceListRulesRequest = RuleServiceListRulesRequest()
    request.source = Constants.ruleServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestRuleServiceGetCategories(_ placeId: String) throws -> Observable<ArcusSessionEvent> {
    let request: RuleServiceGetCategoriesRequest = RuleServiceGetCategoriesRequest()
    request.source = Constants.ruleServiceAddress
    
    
    request.setPlaceId(placeId)

    return try sendRequest(request)
  }
  public func requestRuleServiceGetRuleTemplatesByCategory(_ placeId: String, category: String) throws -> Observable<ArcusSessionEvent> {
    let request: RuleServiceGetRuleTemplatesByCategoryRequest = RuleServiceGetRuleTemplatesByCategoryRequest()
    request.source = Constants.ruleServiceAddress
    
    
    request.setPlaceId(placeId)
    request.setCategory(category)

    return try sendRequest(request)
  }
  
}
