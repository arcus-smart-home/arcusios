
//
// SupportAgentLogEntryCapabilityLegacy.swift
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

public class SupportAgentLogEntryCapabilityLegacy: NSObject, ArcusSupportAgentLogEntryCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: SupportAgentLogEntryCapabilityLegacy  = SupportAgentLogEntryCapabilityLegacy()
  

  
  public static func getCreated(_ model: SupportAgentLogEntryModel) -> Date? {
    guard let created: Date = capability.getSupportAgentLogEntryCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getAgentId(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryAgentId(model)
  }
  
  public static func getAccountId(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryAccountId(model)
  }
  
  public static func getAction(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryAction(model)
  }
  
  public static func getParameters(_ model: SupportAgentLogEntryModel) -> [String]? {
    return capability.getSupportAgentLogEntryParameters(model)
  }
  
  public static func getUserId(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryUserId(model)
  }
  
  public static func getPlaceId(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryPlaceId(model)
  }
  
  public static func getDeviceId(_ model: SupportAgentLogEntryModel) -> String? {
    return capability.getSupportAgentLogEntryDeviceId(model)
  }
  
  public static func createAgentLogEntry(_  model: SupportAgentLogEntryModel, agentId: String, accountId: String, action: String, parameters: [String], userId: String, deviceId: String, placeId: String) -> PMKPromise {
  
    
    
    
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentLogEntryCreateAgentLogEntry(model, agentId: agentId, accountId: accountId, action: action, parameters: parameters, userId: userId, deviceId: deviceId, placeId: placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listAgentLogEntries(_  model: SupportAgentLogEntryModel, agentId: String, startDate: String, endDate: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestSupportAgentLogEntryListAgentLogEntries(model, agentId: agentId, startDate: startDate, endDate: endDate))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
