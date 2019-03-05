//
//  ArcusCapability.swift
//  i2app
//
//  Created by Arcus Team on 8/24/17.
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
//

import Foundation
import PromiseKit
import RxSwift

fileprivate struct Attributes {
  static let baseNamespace = "base"
  static let baseId = "base:id"
  static let baseType = "base:type"
  static let baseAddress = "base:address"
  static let baseTags = "base:tags"
  static let baseImages = "base:images"
  static let baseCaps = "base:caps"
  static let baseInstances = "base:instances"
}

fileprivate struct Commands {
  static let getAttributes = "base:GetAttributes"
  static let setAttributes = "base:SetAttributes"
  static let removeTags = "base:RemoveTags"
  static let addTags = "base:AddTags"
}

public struct Events {
  static let baseAdded = "base:Added"
  static let baseValueChanged = "base:ValueChange"
  static let baseDeleted = "base:Deleted"

  static let baseGetAttributesResponse = "base:GetAttributesResponse"
  static let baseSetAttributesError = "base:SetAttributesError"
}

public protocol ArcusCapability: class, RxArcusService {
  func getModelId() -> String?
  func getName() -> String
  func getType() -> String?
  func getCapabilityId() -> String?
  func getAddress() -> String?
  func getTags() -> [AnyObject]?
  func getImages() -> [String: AnyObject]?
  func getCapabilities() -> [String]?
  func getInstances() -> [String: AnyObject]?

  // MARK: PromiseKit
  func addTags(_ tags: [AnyObject]) -> PMKPromise
  func removeTags(_ tags: [String: AnyObject]) -> PMKPromise

  // MARK: RxSwift
  func rxAddTags(_ tags: [AnyObject]) throws -> Observable<BaseAddTagsResponse>
  func rxRemoveTags(_ tags: [String: AnyObject]) throws -> Observable<BaseRemoveTagsResponse>
}

extension RxArcusModel: ArcusCapability {
  public func getModelId() -> String? {
    return getAttribute(Attributes.baseId) as? String
  }

  /**
   TODO: This should be refactored to not utilize the legacy capabilities, nor should it be a part of
   ArcusCapability if it requires conformance to the required capabilities.
   */
  public func getName() -> String {
    var result = ""

    if getCapabilities()?.contains(Constants.deviceNamespace) ?? false {
      if let device = self as? DeviceModel,
        let name = DeviceCapabilityLegacy.getName(device) {
          result = name
        }
    } else if getCapabilities()?.contains(Constants.hubNamespace) ?? false {
      if let hub = self as? HubModel,
        let name = HubCapabilityLegacy.getName(hub) {
        result = name
      }
    } else if getCapabilities()?.contains(Constants.placeNamespace) ?? false {
      if let place = self as? PlaceModel,
        let name = PlaceCapabilityLegacy.getName(place) {
        result = name
      }
    } else if getCapabilities()?.contains(Constants.ruleNamespace) ?? false {
      if let rule = self as? RuleModel,
        let name = RuleCapabilityLegacy.getName(rule) {
        result = name
      }
    } else if getCapabilities()?.contains(Constants.subsystemNamespace) ?? false {
      if let subsystem = self as? SubsystemModel,
        let name = SubsystemCapabilityLegacy.getName(subsystem) {
        result = name
      }
    }

    return result
  }

  public func getType() -> String? {
    return getAttribute(Attributes.baseType) as? String
  }

  public func getCapabilityId() -> String? {
    return getAttribute(Attributes.baseId) as? String
  }

  public func getAddress() -> String? {
    return getAttribute(Attributes.baseAddress) as? String
  }

  public func getTags() -> [AnyObject]? {
    return getAttribute(Attributes.baseTags) as? [AnyObject]
  }

  public func getImages() -> [String: AnyObject]? {
    return getAttribute(Attributes.baseImages) as? [String: AnyObject]
  }

  public func getCapabilities() -> [String]? {
    return getAttribute(Attributes.baseCaps) as? [String]
  }

  public func getInstances() -> [String: AnyObject]? {
    return getAttribute(Attributes.baseInstances) as? [String: AnyObject]
  }

  public func addTags(_ tags: [AnyObject]) -> PMKPromise {
    do {
      return try promiseForObservable(rxAddTags(tags))
    } catch {
      return PMKPromise.new {
        (_: PMKFulfiller?, rejector: PMKRejecter?) in
        rejector?(error)
      }
    }
  }

  public func removeTags(_ tags: [String: AnyObject]) -> PMKPromise {
    do {
      return try promiseForObservable(rxRemoveTags(tags))
    } catch {
      return PMKPromise.new {
        (_: PMKFulfiller?, rejector: PMKRejecter?) in
        rejector?(error)
      }
    }
  }

  public func rxAddTags(_ tags: [AnyObject]) throws -> Observable<BaseAddTagsResponse> {
    let request = BaseAddTagsRequest()
    request.attributes = ["tags": tags as AnyObject]
    request.source = address

    return try sendRequest(request)
      .filter { (element) -> Bool in
        return element is BaseAddTagsResponse
      }
      .map {
        $0 as! BaseAddTagsResponse
      }
  }

  public func rxRemoveTags(_ tags: [String: AnyObject]) throws -> Observable<BaseRemoveTagsResponse> {
    let request = BaseRemoveTagsRequest()
    request.source = address
    request.attributes = tags

    return try sendRequest(request)
      .filter { (element) -> Bool in
        return element is BaseRemoveTagsResponse
      }
      .map {
        $0 as! BaseRemoveTagsResponse
    }
  }
}

/** Lists all devices associated with this account */
public class BaseAddTagsRequest: ClientMessage, ArcusClientRequest {
  override init() {
    super.init()
    self.command = Commands.addTags
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    return BaseAddTagsResponse(message)
  }
}

public class BaseAddTagsResponse: SessionEvent {}

public class BaseRemoveTagsRequest: ClientMessage, ArcusClientRequest {
  override init() {
    super.init()
    self.command = Commands.removeTags
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    return BaseRemoveTagsResponse(message)
  }
}

public class BaseRemoveTagsResponse: SessionEvent {}

public class BaseSetAttributesRequest: ClientMessage, ArcusClientRequest {
  override init() {
    super.init()
    self.command = Commands.setAttributes
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    return BaseSetAttributesResponse(message)
  }
}

public class BaseSetAttributesResponse: SessionEvent {}

public class BaseGetAttributesRequest: ClientMessage, ArcusClientRequest {
  override init() {
    super.init()
    self.command = Commands.getAttributes
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    return BaseGetAttributesResponse(message)
  }
}

public class BaseGetAttributesResponse: SessionEvent {}
