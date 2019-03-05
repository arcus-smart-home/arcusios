
//
// CellBackupSubsystemCapabilityLegacy.swift
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

public class CellBackupSubsystemCapabilityLegacy: NSObject, ArcusCellBackupSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: CellBackupSubsystemCapabilityLegacy  = CellBackupSubsystemCapabilityLegacy()
  
  static let CellBackupSubsystemStatusREADY: String = CellBackupSubsystemStatus.ready.rawValue
  static let CellBackupSubsystemStatusACTIVE: String = CellBackupSubsystemStatus.active.rawValue
  static let CellBackupSubsystemStatusNOTREADY: String = CellBackupSubsystemStatus.notready.rawValue
  static let CellBackupSubsystemStatusERRORED: String = CellBackupSubsystemStatus.errored.rawValue
  
  static let CellBackupSubsystemErrorStateNONE: String = CellBackupSubsystemErrorState.none.rawValue
  static let CellBackupSubsystemErrorStateNOSIM: String = CellBackupSubsystemErrorState.nosim.rawValue
  static let CellBackupSubsystemErrorStateNOTPROVISIONED: String = CellBackupSubsystemErrorState.notprovisioned.rawValue
  static let CellBackupSubsystemErrorStateDISABLED: String = CellBackupSubsystemErrorState.disabled.rawValue
  static let CellBackupSubsystemErrorStateBANNED: String = CellBackupSubsystemErrorState.banned.rawValue
  static let CellBackupSubsystemErrorStateOTHER: String = CellBackupSubsystemErrorState.other.rawValue
  
  static let CellBackupSubsystemNotReadyStateNEEDSSUB: String = CellBackupSubsystemNotReadyState.needssub.rawValue
  static let CellBackupSubsystemNotReadyStateNEEDSMODEM: String = CellBackupSubsystemNotReadyState.needsmodem.rawValue
  static let CellBackupSubsystemNotReadyStateBOTH: String = CellBackupSubsystemNotReadyState.both.rawValue
  

  
  public static func getStatus(_ model: SubsystemModel) -> String? {
    return capability.getCellBackupSubsystemStatus(model)?.rawValue
  }
  
  public static func getErrorState(_ model: SubsystemModel) -> String? {
    return capability.getCellBackupSubsystemErrorState(model)?.rawValue
  }
  
  public static func getNotReadyState(_ model: SubsystemModel) -> String? {
    return capability.getCellBackupSubsystemNotReadyState(model)?.rawValue
  }
  
  public static func ban(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCellBackupSubsystemBan(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func unban(_ model: SubsystemModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestCellBackupSubsystemUnban(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
