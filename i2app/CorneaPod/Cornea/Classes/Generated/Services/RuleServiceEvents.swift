
//
// RuleServiceEvents.swift
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
// MARK: Commands
fileprivate struct Commands {
  /** Lists all rule templates available for a given place */
  public static let ruleServiceListRuleTemplates: String = "rule:ListRuleTemplates"
  /** Lists all rules defined for a given place */
  public static let ruleServiceListRules: String = "rule:ListRules"
  /** Returns a map containing the names of the categories and counts of available rules */
  public static let ruleServiceGetCategories: String = "rule:GetCategories"
  /**  */
  public static let ruleServiceGetRuleTemplatesByCategory: String = "rule:GetRuleTemplatesByCategory"
  
}

// MARK: Requests

/** Lists all rule templates available for a given place */
public class RuleServiceListRuleTemplatesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleServiceListRuleTemplatesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleServiceListRuleTemplates
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return RuleServiceListRuleTemplatesResponse(message)
  }
  // MARK: ListRuleTemplatesRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class RuleServiceListRuleTemplatesResponse: SessionEvent {
  
  
  /** The rule templates */
  public func getRuleTemplates() -> [Any]? {
    return self.attributes["ruleTemplates"] as? [Any]
  }
}

/** Lists all rules defined for a given place */
public class RuleServiceListRulesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleServiceListRulesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleServiceListRules
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return RuleServiceListRulesResponse(message)
  }
  // MARK: ListRulesRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class RuleServiceListRulesResponse: SessionEvent {
  
  
  /** The rules */
  public func getRules() -> [Any]? {
    return self.attributes["rules"] as? [Any]
  }
}

/** Returns a map containing the names of the categories and counts of available rules */
public class RuleServiceGetCategoriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleServiceGetCategoriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleServiceGetCategories
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return RuleServiceGetCategoriesResponse(message)
  }
  // MARK: GetCategoriesRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class RuleServiceGetCategoriesResponse: SessionEvent {
  
  
  /**  */
  public func getCategories() -> [String: Int]? {
    return self.attributes["categories"] as? [String: Int]
  }
}

/**  */
public class RuleServiceGetRuleTemplatesByCategoryRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleServiceGetRuleTemplatesByCategoryRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleServiceGetRuleTemplatesByCategory
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return RuleServiceGetRuleTemplatesByCategoryResponse(message)
  }
  // MARK: GetRuleTemplatesByCategoryRequest Attributes
  struct Attributes {
    /** UUID of the place */
    static let placeId: String = "placeId"
/** The category name */
    static let category: String = "category"
 }
  
  /** UUID of the place */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** The category name */
  public func setCategory(_ category: String) {
    attributes[Attributes.category] = category as AnyObject
  }

  
}

public class RuleServiceGetRuleTemplatesByCategoryResponse: SessionEvent {
  
  
  /** The rule templates that are members of the given category */
  public func getRuleTemplates() -> [Any]? {
    return self.attributes["ruleTemplates"] as? [Any]
  }
}

