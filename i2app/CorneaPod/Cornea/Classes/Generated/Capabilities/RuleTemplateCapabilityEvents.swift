
//
// RuleTemplateCapEvents.swift
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
  /** Creates a rule instance from a given rule template */
  static let ruleTemplateCreateRule: String = "ruletmpl:CreateRule"
  /** Resolves the parameters for the template at a given place */
  static let ruleTemplateResolve: String = "ruletmpl:Resolve"
  
}

// MARK: Enumerations

// MARK: Requests

/** Creates a rule instance from a given rule template */
public class RuleTemplateCreateRuleRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleTemplateCreateRuleRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleTemplateCreateRule
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
    return RuleTemplateCreateRuleResponse(message)
  }

  // MARK: CreateRuleRequest Attributes
  struct Attributes {
    /** The platform-owned identifier for the place at which the rule is being created */
    static let placeId: String = "placeId"
/** The name assigned to the rule */
    static let name: String = "name"
/** The user provided description of the rule */
    static let description: String = "description"
/** The context (user selections) for the rule */
    static let context: String = "context"
 }
  
  /** The platform-owned identifier for the place at which the rule is being created */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
  /** The name assigned to the rule */
  public func setName(_ name: String) {
    attributes[Attributes.name] = name as AnyObject
  }

  
  /** The user provided description of the rule */
  public func setDescription(_ description: String) {
    attributes[Attributes.description] = description as AnyObject
  }

  
  /** The context (user selections) for the rule */
  public func setContext(_ context: Any) {
    attributes[Attributes.context] = context as AnyObject
  }

  
}

public class RuleTemplateCreateRuleResponse: SessionEvent {
  
  
  /** The address of the created rule */
  public func getAddress() -> String? {
    return self.attributes["address"] as? String
  }
}

/** Resolves the parameters for the template at a given place */
public class RuleTemplateResolveRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: RuleTemplateResolveRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.ruleTemplateResolve
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
    return RuleTemplateResolveResponse(message)
  }

  // MARK: ResolveRequest Attributes
  struct Attributes {
    /** The platform-owned identifier for the place at which to resovle the template parameters */
    static let placeId: String = "placeId"
 }
  
  /** The platform-owned identifier for the place at which to resovle the template parameters */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class RuleTemplateResolveResponse: SessionEvent {
  
  
  /** The resolved selectors for the rule template */
  public func getSelectors() -> [String: Any]? {
    return self.attributes["selectors"] as? [String: Any]
  }
}

