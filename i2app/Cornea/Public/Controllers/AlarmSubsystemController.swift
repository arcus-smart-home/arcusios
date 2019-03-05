//
//  AlarmSubsystemController.swift
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

protocol AlarmSubsystemController {

  // Extended Methods

  func description(_ alarmSubsystem: SubsystemModel?) -> String?
  func alarmState(_ alarmSubsystem: SubsystemModel?) -> String?
  func securityMode(_ alarmSubsystem: SubsystemModel?) -> String?
  func securityArmTime(_ alarmSubsystem: SubsystemModel?) -> Date?
  func activeAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any]
  func availableAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any]
  func monitoredAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any]
  func currentIncident(_ alarmSubsystem: SubsystemModel?) -> String?
  func recordingSupported(_ alarmSubsystem: SubsystemModel?) -> Bool
  func getRecordOnSecurity(_ alarmSubsystem: SubsystemModel?) -> Bool
  func setRecordOnSecurity(_ alarmSubsystem: SubsystemModel?, recordOnSecurity: Bool) -> PMKPromise
  func fanShutoffSupported(_ alarmSubsystem: SubsystemModel?) -> Bool
  func fanShutoffOnSmoke(_ alarmSubsystem: SubsystemModel?) -> Bool
  func setFanShutoffOnSmoke(_ alarmSubsystem: SubsystemModel?, fanShutoffOnSmoke: Bool) -> PMKPromise
  func fanShutoffOnCO(_ alarmSubsystem: SubsystemModel?) -> Bool
  func setFanShutoffOnCO(_ alarmSubsystem: SubsystemModel?, fanShutoffOnCO: Bool) -> PMKPromise
  func callTree(_ alarmSubsystem: SubsystemModel?) -> [Any]
  func configureCallTree(_ alarmSubsystem: SubsystemModel?, tree: [AnyObject]) -> PMKPromise

  func listIncidents(_ alarmSubsystem: SubsystemModel?) -> PMKPromise
  func arm(_ alarmSubsystem: SubsystemModel?, mode: String) -> PMKPromise
  func armBypassed(_ alarmSubsystem: SubsystemModel?, mode: String) -> PMKPromise
  func disarm(_ alarmSubsystem: SubsystemModel?) -> PMKPromise
  func panic(_ alarmSubsystem: SubsystemModel?) -> PMKPromise

  func alarmModels(_ alarmSubsystem: SubsystemModel?) -> [AlarmModel]

  func securityModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel?
  func panicModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel?
  func smokeModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel?
  func coModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel?
  func waterModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel?
}

extension AlarmSubsystemController {
  func provider(_ alarmSubsystem: SubsystemModel?) -> String? {
    return AlarmSubsystemCapability.getAlarmProvider(from: alarmSubsystem)
  }
  
  func description(_ alarmSubsystem: SubsystemModel?) -> String? {
    return alarmSubsystem?.description
  }

  func alarmState(_ alarmSubsystem: SubsystemModel?) -> String? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return AlarmSubsystemCapability.getAlarmState(from: alarmSubsystem)
  }

  func securityMode(_ alarmSubsystem: SubsystemModel?) -> String? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return AlarmSubsystemCapability.getSecurityMode(from: alarmSubsystem)
  }

  func securityArmTime(_ alarmSubsystem: SubsystemModel?) -> Date? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return AlarmSubsystemCapability.getSecurityArmTime(from: alarmSubsystem)
  }

  func activeAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any] {
    guard subsystemAvailable(alarmSubsystem) == true else { return [Any]() }
    return AlarmSubsystemCapability.getActiveAlerts(from: alarmSubsystem)
  }

  func availableAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any] {
    guard subsystemAvailable(alarmSubsystem) == true else { return [AnyObject]() }
    return AlarmSubsystemCapability.getAvailableAlerts(from: alarmSubsystem)
  }

  func monitoredAlerts(_ alarmSubsystem: SubsystemModel?) -> [Any] {
    guard subsystemAvailable(alarmSubsystem) == true else { return [AnyObject]() }
    return AlarmSubsystemCapability.getMonitoredAlerts(from: alarmSubsystem)
  }

  func currentIncident(_ alarmSubsystem: SubsystemModel?) -> String? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return AlarmSubsystemCapability.getCurrentIncident(from: alarmSubsystem)
  }

  func callTree(_ alarmSubsystem: SubsystemModel?) -> [Any] {
    guard subsystemAvailable(alarmSubsystem) == true else { return [Any]() }
    return AlarmSubsystemCapability.getCallTree(from: alarmSubsystem)
  }

  func configureCallTree(_ alarmSubsystem: SubsystemModel?, tree: [AnyObject]) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }
    AlarmSubsystemCapability.setCallTree(tree, on: alarmSubsystem)
    return alarmSubsystem!.commit()
  }

  func fanShutoffSupported(_ alarmSubsystem: SubsystemModel?) -> Bool {
    guard subsystemAvailable(alarmSubsystem) == true else { return false }
    return AlarmSubsystemCapability.getFanShutoffSupported(from: alarmSubsystem)
  }

  func fanShutoffOnSmoke(_ alarmSubsystem: SubsystemModel?) -> Bool {
    guard subsystemAvailable(alarmSubsystem) == true else { return false }
    return AlarmSubsystemCapability.getFanShutoffOnSmoke(from: alarmSubsystem)
  }

  func setFanShutoffOnSmoke(_ alarmSubsystem: SubsystemModel?, fanShutoffOnSmoke: Bool) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }
    AlarmSubsystemCapability.setFanShutoffOnSmoke(fanShutoffOnSmoke, on: alarmSubsystem)
    return alarmSubsystem!.commit()
  }

  func fanShutoffOnCO(_ alarmSubsystem: SubsystemModel?) -> Bool {
    guard subsystemAvailable(alarmSubsystem) == true else { return false }
    return AlarmSubsystemCapability.getFanShutoffOnCO(from: alarmSubsystem)
  }

  func setFanShutoffOnCO(_ alarmSubsystem: SubsystemModel?, fanShutoffOnCO: Bool) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }
    AlarmSubsystemCapability.setFanShutoffOnCO(fanShutoffOnCO, on: alarmSubsystem)
    return alarmSubsystem!.commit()
  }

  func recordingSupported(_ alarmSubsystem: SubsystemModel?) -> Bool {
    guard subsystemAvailable(alarmSubsystem) == true else { return false }
    return AlarmSubsystemCapability.getRecordingSupported(from: alarmSubsystem)
  }

  func getRecordOnSecurity(_ alarmSubsystem: SubsystemModel?) -> Bool {
    guard subsystemAvailable(alarmSubsystem) == true else { return false }
    return AlarmSubsystemCapability.getRecordOnSecurity(from: alarmSubsystem)
  }

  func setRecordOnSecurity(_ alarmSubsystem: SubsystemModel?, recordOnSecurity: Bool) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }
    AlarmSubsystemCapability.setRecordOnSecurity(recordOnSecurity, on: alarmSubsystem)
    return alarmSubsystem!.commit()
  }

  func listIncidents(_ alarmSubsystem: SubsystemModel?) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }

    return AlarmSubsystemCapability.listIncidents(on: alarmSubsystem)
      .swiftThen({ response in
        var incidentModels = [AlarmIncidentModel]()

        if let incidentResponse = response as? AlarmSubsystemListIncidentsResponse {
          if let incidents = incidentResponse.getIncidents() as? [[String: AnyObject]] {
            for incident in incidents {
              incidentModels.append(AlarmIncidentModel(attributes: incident))
            }
          }
        }

        if incidentModels.count > 0 {
          RxCornea.shared.modelCache?.addModels(incidentModels)
        }

        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(incidentModels)
        }
      })
  }

  func arm(_ alarmSubsystem: SubsystemModel?, mode: String) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }

    return AlarmSubsystemCapability.arm(withMode: mode, on: alarmSubsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in

          if let armResponse = response as? AlarmSubsystemArmResponse {
            if let delaySeconds = armResponse.getDelaySec() {
              let delay: NSNumber = NSNumber(value: delaySeconds)
              fulfiller(delay)
            } else {
              fulfiller(nil)
            }
          } else {
            fulfiller(nil)
          }
        }
      }).swiftCatch({
        error in

        guard let error = error as? NSError else {
          return nil
        }

        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(error.userInfo)
        }
      })
  }

  func armBypassed(_ alarmSubsystem: SubsystemModel?, mode: String) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }

    return AlarmSubsystemCapability.armBypassed(withMode: mode, on: alarmSubsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in

          if let armResponse = response as? AlarmSubsystemArmBypassedResponse {
            if let delaySeconds = armResponse.getDelaySec() {
              let delay: NSNumber = NSNumber(value: delaySeconds)
              fulfiller(delay)
            } else {
              fulfiller(nil)
            }
          } else {
            fulfiller(nil)
          }
        }
      }).swiftCatch({
        error in

        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(error)
        }
      })
  }

  func disarm(_ alarmSubsystem: SubsystemModel?) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }

    return AlarmSubsystemCapability.disarm(on: alarmSubsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(response)
        }
      })
  }

  func panic(_ alarmSubsystem: SubsystemModel?) -> PMKPromise {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return subsystemUnavailablePromise()
    }

    return AlarmSubsystemCapability.panic(on: alarmSubsystem)
      .swiftThenInBackground({
        response in
        return PMKPromise.new {
          (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(response)
        }
      })
  }

  func alarmModels(_ alarmSubsystem: SubsystemModel?) -> [AlarmModel] {
    guard subsystemAvailable(alarmSubsystem) == true else {
      return [AlarmModel]()
    }

    if let instances = alarmSubsystem?.instances,
      let attributes = alarmSubsystem?.get() {
      return alarmModels(attributes, instances: instances)
    } else {
      return [AlarmModel]()
    }
  }

  fileprivate func alarmModels(_ attributes: [String: AnyObject],
                               instances: [String : AnyObject]) -> [AlarmModel] {
    var alarmModels: [AlarmModel] = [AlarmModel]()

    for (instanceType, capabilities) in instances {
      guard let capabilityFilters: [String] = capabilities as? [String] else {
        continue
      }
      if let model: AlarmModel = MultiCapabilityInstancedModelFactory
        .createAlarmModel(attributes,
                          instanceFilter: instanceType,
                          attributesFilters: capabilityFilters) {
        alarmModels.append(model)
      }
    }
    return alarmModels
  }

  func securityModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return alarmModelFilterByType(alarmSubsystem, type: kEnumAlarmIncidentAlertSECURITY)
  }

  func panicModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return alarmModelFilterByType(alarmSubsystem, type: kEnumAlarmIncidentAlertPANIC)
  }

  func smokeModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return alarmModelFilterByType(alarmSubsystem, type: kEnumAlarmIncidentAlertSMOKE)
  }

  func coModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return alarmModelFilterByType(alarmSubsystem, type: kEnumAlarmIncidentAlertCO)
  }

  func waterModel(_ alarmSubsystem: SubsystemModel?) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return alarmModelFilterByType(alarmSubsystem, type: kEnumAlarmIncidentAlertWATER)
  }

  fileprivate func alarmModelFilterByType(_ alarmSubsystem: SubsystemModel?, type: String) -> AlarmModel? {
    guard subsystemAvailable(alarmSubsystem) == true else { return nil }
    return self.alarmModels(alarmSubsystem).filter({ m in
      guard let name: String = m.getAttribute(kMultiInstanceTypeKey) as? String else { return false }
      return name == type
    }).first
  }

  fileprivate func subsystemAvailable(_ alarmSubsystem: SubsystemModel?) -> Bool {
    if alarmSubsystem != nil {
      return alarmSubsystem!.hasAttributes()
    }
    return false
  }

  fileprivate func subsystemUnavailablePromise() -> PMKPromise {
    return PMKPromise.new {
      (_: PMKFulfiller!, rejecter: PMKRejecter!) in
      rejecter(NSError(domain: "Arcus",
                       code: 10000,
                       userInfo: [NSLocalizedDescriptionKey: "AlarmSubsystem is nil"]))
    }
  }
}
