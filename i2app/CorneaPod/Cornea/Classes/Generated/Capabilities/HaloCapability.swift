
//
// HaloCap.swift
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
  public static var haloNamespace: String = "halo"
  public static var haloName: String = "Halo"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let haloDevicestate: String = "halo:devicestate"
  static let haloHushstatus: String = "halo:hushstatus"
  static let haloRoom: String = "halo:room"
  static let haloRoomNames: String = "halo:roomNames"
  static let haloRemotetestresult: String = "halo:remotetestresult"
  static let haloHaloalertstate: String = "halo:haloalertstate"
  
}

public protocol ArcusHaloCapability: class, RxArcusService {
  /** Current state of Halo device. */
  func getHaloDevicestate(_ model: DeviceModel) -> HaloDevicestate?
  /** Current status of Hush process. */
  func getHaloHushstatus(_ model: DeviceModel) -> HaloHushstatus?
  /** This is the room type description for the location of the Halo device, which can be read out in an alert. */
  func getHaloRoom(_ model: DeviceModel) -> HaloRoom?
  /** This is the room type description for the location of the Halo device, which can be read out in an alert. */
  func setHaloRoom(_ room: HaloRoom, model: DeviceModel)
/** Mapping of halo:room enum keys to human readable room names supported by this device */
  func getHaloRoomNames(_ model: DeviceModel) -> [String: String]?
  /** Response code from remote test of the halo test feature. */
  func getHaloRemotetestresult(_ model: DeviceModel) -> HaloRemotetestresult?
  /** State of the Arcus system, as transmited to Halo to be indicated to the user through lights and sound. */
  func getHaloHaloalertstate(_ model: DeviceModel) -> HaloHaloalertstate?
  /** State of the Arcus system, as transmited to Halo to be indicated to the user through lights and sound. */
  func setHaloHaloalertstate(_ haloalertstate: HaloHaloalertstate, model: DeviceModel)

  /** Start a new hush process (assumes device is in pre-alert state). */
  func requestHaloStartHush(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Send when user says Halo is flashing a particular color. */
  func requestHaloSendHush(_  model: DeviceModel, color: String)
   throws -> Observable<ArcusSessionEvent>/** Cancel out of current hush process. */
  func requestHaloCancelHush(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>/** Run test cycle on the Halo. Should be moved to some generic capability. */
  func requestHaloStartTest(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHaloCapability {
  public func getHaloDevicestate(_ model: DeviceModel) -> HaloDevicestate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.haloDevicestate] as? String,
      let enumAttr: HaloDevicestate = HaloDevicestate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHaloHushstatus(_ model: DeviceModel) -> HaloHushstatus? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.haloHushstatus] as? String,
      let enumAttr: HaloHushstatus = HaloHushstatus(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHaloRoom(_ model: DeviceModel) -> HaloRoom? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.haloRoom] as? String,
      let enumAttr: HaloRoom = HaloRoom(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setHaloRoom(_ room: HaloRoom, model: DeviceModel) {
    model.set([Attributes.haloRoom: room.rawValue as AnyObject])
  }
  public func getHaloRoomNames(_ model: DeviceModel) -> [String: String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.haloRoomNames] as? [String: String]
  }
  
  public func getHaloRemotetestresult(_ model: DeviceModel) -> HaloRemotetestresult? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.haloRemotetestresult] as? String,
      let enumAttr: HaloRemotetestresult = HaloRemotetestresult(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getHaloHaloalertstate(_ model: DeviceModel) -> HaloHaloalertstate? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.haloHaloalertstate] as? String,
      let enumAttr: HaloHaloalertstate = HaloHaloalertstate(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setHaloHaloalertstate(_ haloalertstate: HaloHaloalertstate, model: DeviceModel) {
    model.set([Attributes.haloHaloalertstate: haloalertstate.rawValue as AnyObject])
  }
  
  public func requestHaloStartHush(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: HaloStartHushRequest = HaloStartHushRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHaloSendHush(_  model: DeviceModel, color: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HaloSendHushRequest = HaloSendHushRequest()
    request.source = model.address
    
    
    
    request.setColor(color)
    
    return try sendRequest(request)
  }
  
  public func requestHaloCancelHush(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: HaloCancelHushRequest = HaloCancelHushRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestHaloStartTest(_ model: DeviceModel) throws -> Observable<ArcusSessionEvent> {
    let request: HaloStartTestRequest = HaloStartTestRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
