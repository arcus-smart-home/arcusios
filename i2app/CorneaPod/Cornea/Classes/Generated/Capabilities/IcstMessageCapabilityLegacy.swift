
//
// IcstMessageCapabilityLegacy.swift
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

public class IcstMessageCapabilityLegacy: NSObject, ArcusIcstMessageCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IcstMessageCapabilityLegacy  = IcstMessageCapabilityLegacy()
  

  
  public static func getCreated(_ model: IcstMessageModel) -> Date? {
    guard let created: Date = capability.getIcstMessageCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getId(_ model: IcstMessageModel) -> String? {
    return capability.getIcstMessageId(model)
  }
  
  public static func getMessageType(_ model: IcstMessageModel) -> String? {
    return capability.getIcstMessageMessageType(model)
  }
  
  public static func setMessageType(_ messageType: String, model: IcstMessageModel) {
    
    
    capability.setIcstMessageMessageType(messageType, model: model)
  }
  
  public static func getAgent(_ model: IcstMessageModel) -> String? {
    return capability.getIcstMessageAgent(model)
  }
  
  public static func getMessage(_ model: IcstMessageModel) -> String? {
    return capability.getIcstMessageMessage(model)
  }
  
  public static func setMessage(_ message: String, model: IcstMessageModel) {
    
    
    capability.setIcstMessageMessage(message, model: model)
  }
  
  public static func getRecipients(_ model: IcstMessageModel) -> [String]? {
    return capability.getIcstMessageRecipients(model)
  }
  
  public static func setRecipients(_ recipients: [String], model: IcstMessageModel) {
    
    
    capability.setIcstMessageRecipients(recipients, model: model)
  }
  
  public static func getExpiration(_ model: IcstMessageModel) -> Date? {
    guard let expiration: Date = capability.getIcstMessageExpiration(model) else {
      return nil
    }
    return expiration
  }
  
  public static func setExpiration(_ expiration: Double, model: IcstMessageModel) {
    
    let expiration: Date = Date(milliseconds: expiration)
    capability.setIcstMessageExpiration(expiration, model: model)
  }
  
  public static func getModified(_ model: IcstMessageModel) -> Date? {
    guard let modified: Date = capability.getIcstMessageModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func createMessage(_  model: IcstMessageModel, id: String, messageType: String, agent: String, message: String, recipients: [String], expiration: Double) -> PMKPromise {
  
    
    
    
    
    
    let expiration: Date = Date(milliseconds: expiration)
    
    do {
      return try capability.promiseForObservable(capability
        .requestIcstMessageCreateMessage(model, id: id, messageType: messageType, agent: agent, message: message, recipients: recipients, expiration: expiration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listMessagesForTimeframe(_  model: IcstMessageModel, messageType: String, agent: String, startDate: String, endDate: String, token: String, limit: Int) -> PMKPromise {
  
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIcstMessageListMessagesForTimeframe(model, messageType: messageType, agent: agent, startDate: startDate, endDate: endDate, token: token, limit: limit))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
