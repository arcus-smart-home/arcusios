
//
// CustomerInteractionCapabilityLegacy.swift
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

public class CustomerInteractionCapabilityLegacy: NSObject, ArcusCustomerInteractionCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CustomerInteractionCapabilityLegacy  = CustomerInteractionCapabilityLegacy()
  

  
  public static func getCreated(_ model: CustomerInteractionModel) -> Date? {
    guard let created: Date = capability.getCustomerInteractionCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getId(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionId(model)
  }
  
  public static func getAccount(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionAccount(model)
  }
  
  public static func getPlace(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionPlace(model)
  }
  
  public static func getCustomer(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionCustomer(model)
  }
  
  public static func getAgent(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionAgent(model)
  }
  
  public static func getAction(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionAction(model)
  }
  
  public static func setAction(_ action: String, model: CustomerInteractionModel) {
    
    
    capability.setCustomerInteractionAction(action, model: model)
  }
  
  public static func getComment(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionComment(model)
  }
  
  public static func setComment(_ comment: String, model: CustomerInteractionModel) {
    
    
    capability.setCustomerInteractionComment(comment, model: model)
  }
  
  public static func getConcessions(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionConcessions(model)
  }
  
  public static func setConcessions(_ concessions: String, model: CustomerInteractionModel) {
    
    
    capability.setCustomerInteractionConcessions(concessions, model: model)
  }
  
  public static func getIncidentNumber(_ model: CustomerInteractionModel) -> String? {
    return capability.getCustomerInteractionIncidentNumber(model)
  }
  
  public static func setIncidentNumber(_ incidentNumber: String, model: CustomerInteractionModel) {
    
    
    capability.setCustomerInteractionIncidentNumber(incidentNumber, model: model)
  }
  
  public static func getModified(_ model: CustomerInteractionModel) -> Date? {
    guard let modified: Date = capability.getCustomerInteractionModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func createInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, problemDevices: [Any]) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCustomerInteractionCreateInteraction(model, id: id, account: account, place: place, customer: customer, agent: agent, action: action, comment: comment, concessions: concessions, incidentNumber: incidentNumber, problemDevices: problemDevices))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateInteraction(_  model: CustomerInteractionModel, id: String, account: String, place: String, customer: String, agent: String, action: String, comment: String, concessions: String, incidentNumber: String, created: Double) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    
    let created: Date = Date(milliseconds: created)
    
    do {
      return try capability.promiseForObservable(capability
        .requestCustomerInteractionUpdateInteraction(model, id: id, account: account, place: place, customer: customer, agent: agent, action: action, comment: comment, concessions: concessions, incidentNumber: incidentNumber, created: created))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listInteractions(_  model: CustomerInteractionModel, account: String, place: String, startDate: String, endDate: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCustomerInteractionListInteractions(model, account: account, place: place, startDate: startDate, endDate: endDate))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listInteractionsForTimeframe(_  model: CustomerInteractionModel, filter: [String], startDate: String, endDate: String, token: String, limit: Int) -> PMKPromise {
  
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestCustomerInteractionListInteractionsForTimeframe(model, filter: filter, startDate: startDate, endDate: endDate, token: token, limit: limit))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
