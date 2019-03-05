
//
// CellBackupSubsystemCap.swift
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
  public static var cellBackupSubsystemNamespace: String = "cellbackup"
  public static var cellBackupSubsystemName: String = "CellBackupSubsystem"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let cellBackupSubsystemStatus: String = "cellbackup:status"
  static let cellBackupSubsystemErrorState: String = "cellbackup:errorState"
  static let cellBackupSubsystemNotReadyState: String = "cellbackup:notReadyState"
  
}

public protocol ArcusCellBackupSubsystemCapability: class, RxArcusService {
  /**  READY:  Will work: Modem is plugged in, healthy, connected, and add on subscription exists for place ACTIVE:  Is working: Hub is actively connected to hub bridge via cellular NOTREADY:  Will not work (user recoverable) : check notReadyState to see if they need a modem or a subscription ERRORED:  Will not work (requires contact center) : check erroredState for more information  */
  func getCellBackupSubsystemStatus(_ model: SubsystemModel) -> CellBackupSubsystemStatus?
  /**  NONE:  No error NOSIM:  Modem is plugged in but does not have a SIM NOTPROVISIONED:  Modem is plugged in but SIM is/was not properly provisioned DISABLED: BANNED: OTHER:  Modem is pluggin in and has a provisioned SIM but for some reason it cannot connect (hub4g:connectionStatus will have a vendor specific code as to why)  */
  func getCellBackupSubsystemErrorState(_ model: SubsystemModel) -> CellBackupSubsystemErrorState?
  /**  NEEDSSUB:  Modem is plugged in, healthy, and connected, but no add on subscription for place exists NEEDSMODEM:  Add on subscription for place exists, but no modem plugged in BOTH:  Needs both modem and subscription  */
  func getCellBackupSubsystemNotReadyState(_ model: SubsystemModel) -> CellBackupSubsystemNotReadyState?
  
  /** Sets status = ERRORED, errorState = BANNED so that the hub bridge will not auth this hub if it connects via cellular. */
  func requestCellBackupSubsystemBan(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>/** Resets status to best-choice [READY, ACTIVE, NOTREADY] and sets errorState to NONE */
  func requestCellBackupSubsystemUnban(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusCellBackupSubsystemCapability {
  public func getCellBackupSubsystemStatus(_ model: SubsystemModel) -> CellBackupSubsystemStatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cellBackupSubsystemStatus] as? String,
      let enumAttr: CellBackupSubsystemStatus = CellBackupSubsystemStatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCellBackupSubsystemErrorState(_ model: SubsystemModel) -> CellBackupSubsystemErrorState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cellBackupSubsystemErrorState] as? String,
      let enumAttr: CellBackupSubsystemErrorState = CellBackupSubsystemErrorState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getCellBackupSubsystemNotReadyState(_ model: SubsystemModel) -> CellBackupSubsystemNotReadyState? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.cellBackupSubsystemNotReadyState] as? String,
      let enumAttr: CellBackupSubsystemNotReadyState = CellBackupSubsystemNotReadyState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  
  public func requestCellBackupSubsystemBan(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CellBackupSubsystemBanRequest = CellBackupSubsystemBanRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestCellBackupSubsystemUnban(_ model: SubsystemModel) throws -> Observable<ArcusSessionEvent> {
    let request: CellBackupSubsystemUnbanRequest = CellBackupSubsystemUnbanRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
