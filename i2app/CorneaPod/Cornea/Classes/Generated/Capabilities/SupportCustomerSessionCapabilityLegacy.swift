
//
// SupportCustomerSessionCapabilityLegacy.swift
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

public class SupportCustomerSessionCapabilityLegacy: NSObject, ArcusSupportCustomerSessionCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SupportCustomerSessionCapabilityLegacy  = SupportCustomerSessionCapabilityLegacy()
  

  
  public static func getCreated(_ model: SupportCustomerSessionModel) -> Date? {
    guard let created: Date = capability.getSupportCustomerSessionCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: SupportCustomerSessionModel) -> Date? {
    guard let modified: Date = capability.getSupportCustomerSessionModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func getEnd(_ model: SupportCustomerSessionModel) -> Date? {
    guard let end: Date = capability.getSupportCustomerSessionEnd(model) else {
      return nil
    }
    return end
  }
  
  public static func getAgent(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionAgent(model)
  }
  
  public static func getAccount(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionAccount(model)
  }
  
  public static func getCaller(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionCaller(model)
  }
  
  public static func getOrigin(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionOrigin(model)
  }
  
  public static func getUrl(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionUrl(model)
  }
  
  public static func setUrl(_ url: String, model: SupportCustomerSessionModel) {
    
    
    capability.setSupportCustomerSessionUrl(url, model: model)
  }
  
  public static func getPlace(_ model: SupportCustomerSessionModel) -> String? {
    return capability.getSupportCustomerSessionPlace(model)
  }
  
  public static func setPlace(_ place: String, model: SupportCustomerSessionModel) {
    
    
    capability.setSupportCustomerSessionPlace(place, model: model)
  }
  
  public static func getNotes(_ model: SupportCustomerSessionModel) -> [String]? {
    return capability.getSupportCustomerSessionNotes(model)
  }
  
  public static func setNotes(_ notes: [String], model: SupportCustomerSessionModel) {
    
    
    capability.setSupportCustomerSessionNotes(notes, model: model)
  }
  
  public static func startSession(_  model: SupportCustomerSessionModel, agent: String, account: String, caller: String, origin: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportCustomerSessionStartSession(model, agent: agent, account: account, caller: caller, origin: origin))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func findActiveSession(_  model: SupportCustomerSessionModel, agent: String, account: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportCustomerSessionFindActiveSession(model, agent: agent, account: account))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listSessions(_  model: SupportCustomerSessionModel, account: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportCustomerSessionListSessions(model, account: account))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func closeSession(_ model: SupportCustomerSessionModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestSupportCustomerSessionCloseSession(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
