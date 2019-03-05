//
//  RxArcusModel.swift
//  i2app
//
//  Created by Arcus Team on 8/14/17.
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
import RxSwift
import PromiseKit
import CocoaLumberjack

fileprivate extension Array {
  func containsElement<T: Equatable>(_ element: T) -> Bool {
    return self.filter({$0 as? T == element}).count > 0
  }
}

public class Model: RxArcusModel {}

public class RxArcusModel: NSObject,
  ArcusModel,
  ArcusModelInternal,
  RxSwiftModel,
  ArcusPromiseConverter,
ArcusNotificationConverter {

  public var modelId: String {
    if let modelId = getModelId() {
      return modelId
    }
    return ""
  }
  public var address: String {
    if let address = getAddress() {
      return address
    }
    return ""
  }

  public var disposeBag: DisposeBag = DisposeBag()
  public var attributes: [String: AnyObject] = [:]
  public var changes: [String: AnyObject] = [:]
  public var eventObservable: PublishSubject<ArcusModelEvent> = PublishSubject<ArcusModelEvent>()

  override public init() {}

  public init(attributes: [String: AnyObject]) {
    self.attributes = attributes
  }

  deinit {
    eventObservable.onCompleted()
  }

  public func set(_ attributes: [String: AnyObject]) {
    // Merge attributes with changes
    changes.merge(attributes)

    // Publish Event
    let event: ModelSetAttributesEvent = ModelSetAttributesEvent(address, attributes: attributes)
    eventObservable.onNext(event)
  }

  public func get() -> [String: AnyObject] {
    return attributes
  }

  public func getAttribute(_ key: String) -> AnyObject? {
    if let modifiedAttribute = changes[key] {
      return modifiedAttribute
    }
    return attributes[key]
  }

  public func modelUpdated(_ updatedAttributes: [String: AnyObject]) {
    let currentAttributes = attributes

    // Merge updates with current attributes.
    attributes.merge(updatedAttributes)

    // Remove updates from changes.
    changes.outerLeftJoin(updatedAttributes)

    // Publish Event
    let event: ModelUpdateAttributesEvent = ModelUpdateAttributesEvent(address, changes: updatedAttributes)
    eventObservable.onNext(event)

    // Legacy Notification Handling
    publishLegacyNotifications(updatedAttributes,
                               currentAttributes: currentAttributes,
                               name: modelChangedNotification())
  }

  func publishLegacyNotifications(_ updatedAttributes: [String: AnyObject],
                                  currentAttributes: [String: AnyObject],
                                  name: String) {
    LegacyNotifier.publishModelChangedNotifications(updatedAttributes, name: name, model: self)

    if updatedAttributes.keys.contains("base:tags") {
      LegacyNotifier.processTagChangeNotifications(updatedAttributes, attributes: currentAttributes)
    } else {
      LegacyNotifier.publishAttributeChangeNotification(updatedAttributes, model: self)
    }
  }

  public func commit(_ changes: [String: AnyObject]) -> Observable<BaseSetAttributesResponse> {
    let request = BaseSetAttributesRequest()
    request.source = self.address
    request.attributes = changes
    request.isRequest = false

    do {
      return try sendRequest(request)
        .filter { (element) -> Bool in
          return element is BaseSetAttributesResponse
        }
        .map {
          $0 as! BaseSetAttributesResponse
      }
    } catch {
      let errorObservable = PublishSubject<BaseSetAttributesResponse>()
      errorObservable.onError(error)
      return errorObservable.asObservable()
    }
  }

  public func commitChanges() -> Observable<BaseSetAttributesResponse> {
    return commit(changes)
  }

  public func refresh(_ address: String) -> Observable<BaseGetAttributesResponse> {
    let request = BaseGetAttributesRequest()
    request.source = address
    request.attributes = self.attributes
    request.isRequest = false

    do {
      let observable = try sendRequest(request)
        .filter { (element) -> Bool in
          return element is BaseGetAttributesResponse
        }
        .map {
          $0 as! BaseGetAttributesResponse
      }

      let disposable = observable.subscribe(
        onNext: { [weak self] event in
          if self != nil {
            let refreshEvent = ModelRefreshEvent(event.source, model: self!, changes: event.attributes)
            self?.notifyForEvent(refreshEvent)
            self?.eventObservable.onNext(refreshEvent)
          }
      })
      disposable.disposed(by: disposeBag)

      return observable
    } catch {
      let errorObservable = PublishSubject<BaseGetAttributesResponse>()
      errorObservable.onError(error)
      return errorObservable.asObservable()
    }
  }

  public func refreshModel() -> Observable<BaseGetAttributesResponse> {
    return refresh(address)
  }
}

extension RxArcusModel: LegacyModel {
  @discardableResult open func commit() -> PMKPromise {
    guard changes.count > 0 else {
      // TODO: FIXME!
      // Reject promise instead.
      DDLogWarn("No changes to commit.")
      let observable = PublishSubject<Any>()
      return promiseForObservable(observable.asObservable())
    }
    return promiseForObservable(commit(changes))
  }

  @discardableResult public func refresh() -> PMKPromise {
    guard address.count > 0 else {
      // TODO: FIXME!
      // Reject promise instead.
      let observable = PublishSubject<Any>()
      return promiseForObservable(observable.asObservable())
    }
    return promiseForObservable(refresh(address))
  }

  public static func attributeChangedNotificationName(_ attr: String) -> Notification.Name {
    let generatedString = attributeChangedNotification(attr)
    return Notification.Name(generatedString)
  }

  public static func attributeChangedNotification(_ attribute: String) -> String {
    return "\(kAttributeChangedNotification)\(attribute)"
  }

  public static func tagChangedNotification(_ tag: String) -> String {
    return "\(kAttributeChangedNotification)Tag\(tag)"
  }

  public func hasAttributes() -> Bool {
    return get().count > 0
  }

  public func getAddressForNamespace(_ namespace: String) -> String {
    return RxArcusModel.addressForNamespace(namespace, modelId: modelId)
  }

  public static func addressForNamespace(_ namespace: String, modelId: String) -> String {
    if namespace == Constants.deviceNamespace {
      return "\(Constants.kDriv):\(namespace):\(modelId)"
    } else if namespace == Constants.hubNamespace {
      return "\(Constants.kService):\(modelId):\(Constants.hubNamespace)"
    }
    return "\(Constants.kService):\(namespace):\(modelId)"
  }

  public static func modelIdForAddress(_ address: String) -> String {
    guard address.count > 0 else { return "" }

    let components = address.components(separatedBy: ":")
    if components.count > 2 {
      if components.contains(Constants.hubNamespace) {
        return components[1]
      } else {
        return components[2]
      }
    }
    return ""
  }

  public func modelChangedNotification() -> String {
    return "\(kModelChangedNotification)\(modelId)"
  }
}
