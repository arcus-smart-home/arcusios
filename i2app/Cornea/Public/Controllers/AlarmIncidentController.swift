//
//  AlarmIncidentController.swift
//  i2app
//
//  Created by Arcus Team on 2/15/17.
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

import PromiseKit
import Cornea

enum IncidentTrackerState: String {
  case prealert = "PREALERT"
  case alert = "ALERT"
  case cancelled = "CANCELLED"
  case dispatching = "DISPATCHING"
  case dispatched = "DISPATCHED"
  case dispatchFailed = "DISPATCH_FAILED"
  case dispatchRefused = "DISPATCH_REFUSED"
  case dispatchCancelled = "DISPATCH_CANCELLED"
}

enum IncidentAlertState: String {
  case prealert = "PREALERT"
  case alert = "ALERT"
  case cancelling = "CANCELLING"
  case complete = "COMPLETE"
}

enum IncidentMonitoringState: String {
  case none = "NONE"
  case pending = "PENDING"
  case dispatching = "DISPATCHING"
  case dispatched = "DISPATCHED"
  case refused = "REFUSED"
  case cancelled = "CANCELLED"
  case failed = "FAILED"
}

protocol AlarmIncidentController {
  // MARK: Extended Methods
  func getPlaceId(_ model: AlarmIncidentModel) -> String
  func getStartTime(_ model: AlarmIncidentModel) -> Date
  func getPrealertEndtime(_ model: AlarmIncidentModel) -> Date?
  func getEndTime(_ model: AlarmIncidentModel) -> Date
  func getAlertState(_ model: AlarmIncidentModel) -> String
  func getMonitoringState(_ model: AlarmIncidentModel) -> String
  func getAlert(_ model: AlarmIncidentModel) -> String
  func getAdditionalAlerts(_ model: AlarmIncidentModel)
  func getTracker(_ model: AlarmIncidentModel) -> [AnyObject]
  func getConfirmed(_ model: AlarmIncidentModel) -> Bool
  func getCancelled(_ model: AlarmIncidentModel) -> Bool
  func getCancelledBy(_ model: AlarmIncidentModel) -> String
  func getMonitored(_ model: AlarmIncidentModel) -> Bool
  func verifyOnModel(_ model: AlarmIncidentModel) -> PMKPromise
  func cancelOnModel(_ model: AlarmIncidentModel) -> PMKPromise
  func listHistoryEntries(_ limit: Int32,
                          token: String,
                          model: AlarmIncidentModel) -> PMKPromise
  func refreshIncident(_ address: String) -> PMKPromise
}

extension AlarmIncidentController {
  func getPlaceId(_ model: AlarmIncidentModel) -> String {
    return AlarmIncidentCapability.getPlaceId(from: model)
  }

  func getStartTime(_ model: AlarmIncidentModel) -> Date {
    return AlarmIncidentCapability.getStartTime(from: model)
  }

  func getPrealertEndtime(_ model: AlarmIncidentModel) -> Date? {
    return AlarmIncidentCapability.getPrealertEndtime(from: model)
  }

  func getEndTime(_ model: AlarmIncidentModel) -> Date {
    return AlarmIncidentCapability.getEndTime(from: model)
  }

  func getAlertState(_ model: AlarmIncidentModel) -> String {
    return AlarmIncidentCapability.getAlertState(from: model)
  }

  func getMonitoringState(_ model: AlarmIncidentModel) -> String {
    return AlarmIncidentCapability.getMonitoringState(from: model)
  }

  func getAlert(_ model: AlarmIncidentModel) -> String {
    return AlarmIncidentCapability.getAlertFrom(model)
  }

  func getAdditionalAlerts(_ model: AlarmIncidentModel) {
    AlarmIncidentCapability.getAdditionalAlerts(from: model)
  }

  func getConfirmed(_ model: AlarmIncidentModel) -> Bool {
    return AlarmIncidentCapability.getConfirmedFrom(model)
  }

  func getTracker(_ model: AlarmIncidentModel) -> [AnyObject] {
    return AlarmIncidentCapability.getTrackerFrom(model) as [AnyObject]
  }

  func getCancelled(_ model: AlarmIncidentModel) -> Bool {
    return AlarmIncidentCapability.getCancelledFrom(model)
  }

  func getCancelledBy(_ model: AlarmIncidentModel) -> String {
    return AlarmIncidentCapability.getCancelledBy(from: model)
  }

  func getMonitored(_ model: AlarmIncidentModel) -> Bool {
    return AlarmIncidentCapability.getMonitoredFrom(model)
  }

  func verifyOnModel(_ model: AlarmIncidentModel) -> PMKPromise {
    return AlarmIncidentCapability.verify(on: model)
      .swiftThen({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func cancelOnModel(_ model: AlarmIncidentModel) -> PMKPromise {
    return AlarmIncidentCapability.cancel(on: model)
      .swiftThen({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func listHistoryEntries(_ limit: Int32,
                          token: String,
                          model: AlarmIncidentModel) -> PMKPromise {
    return AlarmIncidentCapability.listHistoryEntries(withLimit: limit,
      withToken: token,
      on: model)
      .swiftThen({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller?, _: PMKRejecter?) in
          fulfiller?(response)
        }
      })
  }

  func refreshIncident(_ address: String) -> PMKPromise {
    return AlarmIncidentModel(attributes: [kAttrAddress: address as AnyObject])
      .refresh()
      .swiftThen({ (_) -> (PMKPromise?) in
        return PMKPromise.new { (fulfiller: PMKFulfiller!, rejecter: PMKRejecter!) in
          if let incident = RxCornea.shared.modelCache?.fetchModel(address) {
            fulfiller(incident)
          } else {
            rejecter(NSError(domain: "Arcus", code: 10666, userInfo: [kAttrId: address]))
          }
        }
      })
  }
}
