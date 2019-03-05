//
//  RxArcusModelCache.swift
//  i2app
//
//  Created by Arcus Team on 7/14/17.
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

public class RxArcusModelCache: ArcusModelCache,
  RxSwiftModelCache,
  ArcusModelFactory,
  ArcusNotificationConverter,
  LegacyModelCache {
  
  public var models: [String: ArcusModel] = [:]
  public var modelAccessQueue: DispatchQueue = DispatchQueue(label: "",
                                                      qos: .utility)
  public var disposeBag: DisposeBag = DisposeBag()

  // MARK: LegacyModelCache Vars
  public var oldModelsDictionary: [String: AnyObject] = [String: AnyObject]()

  public var eventObservable: PublishSubject<ArcusModelCacheEvent> =
    PublishSubject<ArcusModelCacheEvent>()

  public func processModelChangeEvent(_ event: ArcusSessionEvent) {
    if event.type == Events.baseAdded {
      // Do not add base Model objects to the cache; this is a heuristic to address incoming 'pairdev:'
      // messages which will get built as plain-ole 'Model' objects.
      // TODO: Replace this code with new capabilities and logic to deal with pairdev
      let model = build(event.attributes)
      if type(of: model) != Model.self {
        addModel(model)
      }
      
    } else if event.type == Events.baseValueChanged ||
      event.type == Events.baseGetAttributesResponse {
      updateModel(event.source, changes: event.attributes)
    } else if event.type == Events.baseDeleted {
      deleteModel(event.source)
    }
  }

  public func addModel(_ model: ArcusModel) {
    guard models[model.address] == nil else {
      updateModel(model.address, changes: model.get())
      return
    }
    modelAccessQueue.async {
      self.models.updateValue(model, forKey: model.address)
    }

    let addEvent = ModelAddedEvent(model.address, model: model)
    notifyForEvent(addEvent)
    legacyNotifictionForEvent(addEvent) // Handles legacy ModelStore notifications
    eventObservable.onNext(addEvent)
  }

  public func addModels(_ models: [ArcusModel]) {
    for model in models {
      addModel(model)
      updateSubystem(model) // If model is SubsystemModel, then notify legacy SubystemsController
    }
  }

  public func addModels(_ models: ArcusModel...) {
    addModels(models)
  }

  public func deleteModel(_ address: String) {
    var deleteEvent = ModelDeletedEvent(address, success: false)

    modelAccessQueue.async {
      if let deletedModel = self.models.removeValue(forKey: address) {
        deleteEvent = ModelDeletedEvent(address, model: deletedModel, success: true)
        DispatchQueue.main.async {
          // Only send legacy notification for successful deletion.
          self.notifyForEvent(deleteEvent)
        }
      }
    }
    eventObservable.onNext(deleteEvent)
  }

  public func fetchModel(_ address: String) -> ArcusModel? {
    var result: ArcusModel?

    modelAccessQueue.sync {
      if let model = self.models[address] {
        result = model
      }
    }

    return result
  }

  public func fetchModels(_ namespace: String) -> [ArcusModel]? {
    var result: [ArcusModel]?
    var filteredModels: [ArcusModel] = [ArcusModel]()

      let filteredKeys = models.keys.filter {
        let components = $0.components(separatedBy: ":")
        guard components.count >= 2 else {
          return false
        }

        // Hubs are addressed weirdly: "SERV:hubid:hub"; other models are "SERV:namespace:id"
        let thisNamespace = namespace == Constants.hubNamespace ? components[2] : components[1]
        return namespace == thisNamespace
      }

      for key in filteredKeys {
        if let model = fetchModel(key) {
          filteredModels.append(model)
        }
      }

    if filteredModels.count > 0 {
      result = filteredModels
    }

    return result
  }

  fileprivate func updateSubystem(_ model: ArcusModel) {
    guard let subsystem = model as? SubsystemModel,
      subsystem.address.contains("sub") || subsystem.address.contains("cellbackup") else {
        return
    }
    RxCornea.shared.legacyLogic?.addOrUpdateSubsystem(with: subsystem, andSource: subsystem.address)
  }

  public func updateModel(_ address: String, changes: [String: AnyObject]) {
    guard let model = fetchModel(address) else {
      addModel(build(changes))
      return
    }

    model.modelUpdated(changes)
    updateSubystem(model) // If model is SubsystemModel, then notify legacy SubystemsController

    let updateEvent = ModelUpdatedEvent(address, model: model, changes: changes)
    notifyForEvent(updateEvent)
    legacyNotifictionForEvent(updateEvent) // Handles legacy ModelStore notifications
    eventObservable.onNext(updateEvent)
  }

  public func flush() {
    oldModelsDictionary = models
    modelAccessQueue.async {
      self.models.removeAll()
    }
    
    let flushEvent = ModelCacheFlushedEvent()
    eventObservable.onNext(flushEvent)
  }

  fileprivate func legacyNotifictionForEvent(_ event: ArcusNotifiableEvent) {
    if let modelNotifier = event.notificationObject as? LegacyModelNotifier,
      let model = event.notificationObject as? ArcusModel {

      let name: String = modelNotifier.addModelNotificationName()
      let notificationName: Notification.Name = Notification.Name(rawValue: name)
      NotificationCenter.default.post(name: notificationName, object: model)
    }
  }
}
