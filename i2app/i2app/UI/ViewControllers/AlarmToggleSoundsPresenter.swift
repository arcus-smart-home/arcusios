//
//  AlarmToggleSoundsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/9/17.
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
import Cornea
import PromiseKit

class AlarmSoundToggleViewModel {

  var alarmWillSound: Bool = true
  var type: AlarmSoundType

  init(_ type: AlarmSoundType, willSound: Bool) {
    self.type = type
    self.alarmWillSound = willSound
  }

}

enum AlarmSoundType: Int {
  case securityAndPanic
  case smokeAndCO
  case waterLeakAlarm

  var title: String {
    switch self {
    case .securityAndPanic:
      return NSLocalizedString("Security & Panic Alarm", comment: "")
    case .smokeAndCO:
      return NSLocalizedString("Smoke & CO Alarm", comment: "")
    case .waterLeakAlarm:
      return NSLocalizedString("Water Leak Alarm", comment: "")
    }
  }

}

protocol AlarmSoundTogglePresenterProtocol {
  weak var delegate: GenericPresenterDelegate? { get set }
  init(delegate: GenericPresenterDelegate)
  var data: [AlarmSoundToggleViewModel]? { get }
  func toggleObject(_ state: Bool, atIndex: Int)
  func fetch()
}

class AlarmSoundTogglePresenter: AlarmSoundTogglePresenterProtocol,
  AlarmSubsystemController,
AlarmModelController {
  weak var delegate: GenericPresenterDelegate?
  required init(delegate: GenericPresenterDelegate) {
    self.observeChangeEvents()
    self.delegate = delegate
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
  }

  func toggleObject(_ state: Bool, atIndex: Int) {
    guard let data = data else {
      return
    }
    data[atIndex].alarmWillSound = state
    postAlarmSoundTypeChange(data[atIndex].type, silent: !data[atIndex].alarmWillSound)
    delegate?.updateLayout()
  }

  func fetch() {
    setViewModelsFromModels()
  }

  func postAlarmSoundTypeChange(_ type: AlarmSoundType, silent: Bool) {
    DispatchQueue.global(qos: .background).async {
      switch type {
      case .securityAndPanic:
        if silent {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsSecurityOff)
        } else {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsSecurityOn)
        }
        if let securityModel = self.securityModel(self.subsystemModel),
          let panicModel = self.panicModel(self.subsystemModel) {
          _ = self.setSilent(silent, alarmModel: securityModel, parentSubsystem: self.subsystemModel)
            .swiftThenInBackground({ _ -> (PMKPromise?) in
              return self.setSilent(silent, alarmModel: panicModel, parentSubsystem: self.subsystemModel)
            })
            .swiftThenInBackground({ _ -> (PMKPromise?) in
              return self.subsystemModel.commit()
            })

        }
      case .smokeAndCO:
        if silent {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsSmokeCoOff)
        } else {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsSecurityOn)
        }
        if let smokeModel = self.smokeModel(self.subsystemModel),
          let coModel = self.coModel(self.subsystemModel) {
          _ = self.setSilent(silent, alarmModel: smokeModel, parentSubsystem: self.subsystemModel)
            .swiftThenInBackground({ _ -> (PMKPromise?) in
              self.setSilent(silent, alarmModel: coModel, parentSubsystem: self.subsystemModel)
            })
            .swiftThenInBackground({ _ -> (PMKPromise?) in
              return self.subsystemModel.commit()
            })
        }
      case .waterLeakAlarm:
        if silent {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsWaterOff)
        } else {
          ArcusAnalytics.tag(named: AnalyticsTags.AlarmsGlobalSoundsWaterOn)
        }
        if let waterModel = self.waterModel(self.subsystemModel) {
          _ = self.setSilent(silent, alarmModel: waterModel, parentSubsystem: self.subsystemModel)
            .swiftThenInBackground({ _ -> (PMKPromise?) in
              return self.subsystemModel.commit()
            })
        }
      }
    }

  }

  /// Quick dirty mock of the Data that the user can click
  var data: [AlarmSoundToggleViewModel]? = AlarmSoundTogglePresenter.stubData {
    didSet {
      delegate?.updateLayout()
    }
  }

  func setViewModelsFromModels() {
    var builtVMs = [AlarmSoundToggleViewModel]()

    // Used to combine 2 Models into One View Model
    func addToBuilt(_ type: AlarmSoundType, willSound: Bool) {
      if let found = builtVMs.filter({return $0.type == type}).first {
        found.alarmWillSound = found.alarmWillSound || willSound //prefer true if somehow they don't match
      } else {
        builtVMs.append(AlarmSoundToggleViewModel(type, willSound: willSound))
      }
    }

    alarmModels(subsystemModel).forEach { (model) in
      let state = alertState(model)
      switch state {
      case kEnumAlarmSubsystemAlarmStateINACTIVE: break // Ignore Inactive Subsystems
      default:
        guard devices(model).count != 0, // Ignore if No devices
          let name: String = model.getAttribute(kMultiInstanceTypeKey) as? String else {
            break
        }
        switch name {
        case kEnumAlarmIncidentAlertSECURITY, kEnumAlarmIncidentAlertPANIC:
          addToBuilt(AlarmSoundType.securityAndPanic, willSound: !getSilent(model))
        case kEnumAlarmIncidentAlertSMOKE, kEnumAlarmIncidentAlertCO:
          addToBuilt(AlarmSoundType.smokeAndCO, willSound: !getSilent(model))
        case kEnumAlarmIncidentAlertWATER:
          addToBuilt(AlarmSoundType.waterLeakAlarm, willSound: !getSilent(model))
        default: break
        }
      }
    }
    builtVMs.sort(by: {return $0.type.rawValue < $1.type.rawValue})
    data = builtVMs
  }

  // MARK: - AlarmSubsystemController

  var subsystemModel: SubsystemModel = SubsystemModel()

  func observeChangeEvents() {
    let changeSelector =  #selector(AlarmSoundTogglePresenter.alarmSubsystemNotification(_:))
    NotificationCenter.default.addObserver(self, selector: changeSelector,
                                           name: Notification.Name.subsystemCacheInitialized,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: changeSelector,
                                           name: Notification.Name.subsystemUpdated,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: changeSelector,
                                           name: Notification.Name.subsystemCacheCleared,
                                           object: nil)
  }

  @objc func alarmSubsystemNotification(_ note: Notification) {
    guard let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() else {
      data = nil
      return
    }
    self.subsystemModel = alarmSubsystem
    setViewModelsFromModels()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Stubs

  class fileprivate var stubData: [AlarmSoundToggleViewModel]? {
    return [
      AlarmSoundToggleViewModel(.securityAndPanic, willSound:false),
      AlarmSoundToggleViewModel(.smokeAndCO, willSound:false),
      AlarmSoundToggleViewModel(.waterLeakAlarm, willSound:false)
    ]
  }
}
