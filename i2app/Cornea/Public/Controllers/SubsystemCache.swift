//
//  SubsystemCache.swift
//  i2app
//
//  Created by Arcus Team on 1/16/17.
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

import UIKit
import PromiseKit
import Cornea

extension Notification.Name {
  static let subsystemCacheInitialized = Notification.Name("SubsystemCacheInitialized")
  static let subsystemCacheUpdated = Notification.Name("SubsystemCacheUpdated")
  static let subsystemCacheCleared = Notification.Name("SubsystemCacheCleared")
}

let kSubsystemCacheUpdatedIdentifierKey: String = "subystemId"

fileprivate class SubystemInitializer: AlarmSubsystemController {
  var subsystemModel: SubsystemModel

  required init(subsystemModel: SubsystemModel) {
    self.subsystemModel = subsystemModel
  }
}

class SubsystemCache: NSObject, SubsystemController {
  static let sharedInstance = SubsystemCache()
  private var subsystems: [SubsystemModel]?

  // MARK: - Public Functions

  /**
   Convenience method used to retrieve SubsystemModel for the AlarmSubsystem.

   - Returns: SubsystemModel of the AlarmSubsystem if present.
   */
  func alarmSubsystem() -> SubsystemModel? {
    return subsystem(AlarmSubsystemCapability.name())
  }
  
  /// Gets the current pairing subsystem model
  /// - Returns: The current place's pairing subsystem, or nil, when not available
  func pairingSubsystem() -> SubsystemModel? {
    if let m = subsystem(Constants.pairingSubsystemName) {
      return m
    }
    DDLogWarn("Error Missing Pairing subsystem")
    return nil
  }

  // MARK: Subsystem Fetch & Update

  /**
   Static func used to create AlarmModel object based on supplied attributes & filters.

   - Parameters: The placeId of the place to fetch subsystems for.

   - Returns: Promise for processing completion of retrieval.
   */
  func retrieveSubsystemsForPlaceId(_ placeId: String) -> PMKPromise {
    return fetchSubsystems(placeId)
      .swiftThenInBackground({ response in
        if let fetchResponse: SubsystemServiceListSubsystemsResponse =
          response as? SubsystemServiceListSubsystemsResponse {
          self.process(fetchResponse)
        }
        return nil
      })
  }

  /**
   Method used by ModelCache to communicate updates to the SubystemModels to the 
   SubystemManager. Method will produce 'kSubsystemUpdatedNotification' if successful.

   - Parameters:
    - attributes: The attributes of the new or updated SubsystemModel.
    - source: String specifing the id of the event received from the platform.
   */
  func addOrUpdateSubsystemWithModel(_ model: SubsystemModel,
                                          andSource source: String) {
    // Example source format: SERV:subalarm:aafea477-7d52-4ebd-a215-a4ec83c01420
    let components: [String] = source.components(separatedBy: ":")
    guard components.count >= 3 else {
      return
    }
    
    let subsystemId: String = components[1] + ":" + components[2]
    if let subsystemIndex = subsystems?.index(where: { $0.modelId == subsystemId}) {
      
      subsystems?[subsystemIndex] = model
      NotificationCenter.default
        .post(name: Notification.Name.subsystemCacheUpdated,
              object: model,
              userInfo: [kSubsystemCacheUpdatedIdentifierKey: subsystemId])
      
    } else {
      // Subsystems must have an id and a name in order allow indexing of subsystems array.
      if model.modelId != "" && model.name != "" {
        _ = SubystemInitializer(subsystemModel: model)
        subsystems?.append(model)
      }
    }
  }

  /**
   Method used to clear the active subsystems.  This method is usually used when
   changing places or when re-establishing a connection to the platform.
   */
  func clearSubsystems() {
    subsystems = [SubsystemModel]()

    NotificationCenter.default
      .post(name: Notification.Name.subsystemCacheCleared,
                            object: nil)
  }

  /**
   Method used to process the completion of retrieveSubsystemsForPlaceId().  
   Will produce 'kSubsystemInitializedNotification' on completion. 
   (Method is temporarily public to allow for preserving legacy functionality of SubsystemsController.)

   - Parameters: 
    - listResponse: The instance of SubsystemServiceListSubsystemsResponse received from the request.
    - postNotification: Bool idicating if processing response signal completion with notification.
   */
  func process(_ listResponse: SubsystemServiceListSubsystemsResponse) {
    subsystems = [SubsystemModel]()

    if let responseSubsystems = listResponse.getSubsystems() {
      for subsystemDictionary in responseSubsystems {
        guard let attributes = subsystemDictionary as? [String : AnyObject] else { continue }
        let subsystemModel = SubsystemModel(attributes: attributes)
        let name = subsystemName(subsystemModel)

        if name == nil { continue }

        if name == AlarmSubsystemCapability.name() {
          // When a suspended alarms subsystem is found, an activation request should be sent.
          if getStateFromModel(subsystemModel) == kEnumSubsystemStateSUSPENDED {
            _ = activate(subsystemModel)
          }
          
          _ = SubystemInitializer(subsystemModel: subsystemModel)
          subsystems?.append(subsystemModel)
        }
      }
    }

    NotificationCenter.default
      .post(name: Notification.Name.subsystemCacheInitialized,
                            object: nil)
  }

  /**
   Method used to retrieve a SubsystemModel from subsystems array by name.
   Intended usuage is for the method to be called by a convienence method which will
   pass the name parameter from an existing SubsystemCapability.

   - Parameters: The name of the SubystemModel to return.
   
   - Returns: An optional instance of SubsystemModel for the name supplied.
   */
  func subsystem(_ subsystemName: String) -> SubsystemModel? {
    if let subsystemModel: SubsystemModel = subsystems?.filter({self.subsystemName($0) == subsystemName}).first {
      return subsystemModel
    }
    return nil
  }
}
