
//
// KeyPadCapabilityLegacy.swift
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

public class KeyPadCapabilityLegacy: NSObject, ArcusKeyPadCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: KeyPadCapabilityLegacy  = KeyPadCapabilityLegacy()
  
  static let KeyPadAlarmStateDISARMED: String = KeyPadAlarmState.disarmed.rawValue
  static let KeyPadAlarmStateARMED: String = KeyPadAlarmState.armed.rawValue
  static let KeyPadAlarmStateARMING: String = KeyPadAlarmState.arming.rawValue
  static let KeyPadAlarmStateALERTING: String = KeyPadAlarmState.alerting.rawValue
  static let KeyPadAlarmStateSOAKING: String = KeyPadAlarmState.soaking.rawValue
  
  static let KeyPadAlarmModeON: String = KeyPadAlarmMode.on.rawValue
  static let KeyPadAlarmModePARTIAL: String = KeyPadAlarmMode.partial.rawValue
  static let KeyPadAlarmModeOFF: String = KeyPadAlarmMode.off.rawValue
  
  static let KeyPadAlarmSounderON: String = KeyPadAlarmSounder.on.rawValue
  static let KeyPadAlarmSounderOFF: String = KeyPadAlarmSounder.off.rawValue
  

  
  public static func getAlarmState(_ model: DeviceModel) -> String? {
    return capability.getKeyPadAlarmState(model)?.rawValue
  }
  
  public static func setAlarmState(_ alarmState: String, model: DeviceModel) {
    guard let alarmState: KeyPadAlarmState = KeyPadAlarmState(rawValue: alarmState) else { return }
    
    capability.setKeyPadAlarmState(alarmState, model: model)
  }
  
  public static func getAlarmMode(_ model: DeviceModel) -> String? {
    return capability.getKeyPadAlarmMode(model)?.rawValue
  }
  
  public static func setAlarmMode(_ alarmMode: String, model: DeviceModel) {
    guard let alarmMode: KeyPadAlarmMode = KeyPadAlarmMode(rawValue: alarmMode) else { return }
    
    capability.setKeyPadAlarmMode(alarmMode, model: model)
  }
  
  public static func getAlarmSounder(_ model: DeviceModel) -> String? {
    return capability.getKeyPadAlarmSounder(model)?.rawValue
  }
  
  public static func setAlarmSounder(_ alarmSounder: String, model: DeviceModel) {
    guard let alarmSounder: KeyPadAlarmSounder = KeyPadAlarmSounder(rawValue: alarmSounder) else { return }
    
    capability.setKeyPadAlarmSounder(alarmSounder, model: model)
  }
  
  public static func getEnabledSounds(_ model: DeviceModel) -> [Any]? {
    return capability.getKeyPadEnabledSounds(model)
  }
  
  public static func setEnabledSounds(_ enabledSounds: [Any], model: DeviceModel) {
    
    
    capability.setKeyPadEnabledSounds(enabledSounds, model: model)
  }
  
  public static func beginArming(_  model: DeviceModel, delayInS: Int, alarmMode: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestKeyPadBeginArming(model, delayInS: delayInS, alarmMode: alarmMode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func armed(_  model: DeviceModel, alarmMode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestKeyPadArmed(model, alarmMode: alarmMode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func disarmed(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestKeyPadDisarmed(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func soaking(_  model: DeviceModel, durationInS: Int, alarmMode: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestKeyPadSoaking(model, durationInS: durationInS, alarmMode: alarmMode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func alerting(_  model: DeviceModel, alarmMode: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestKeyPadAlerting(model, alarmMode: alarmMode))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func chime(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestKeyPadChime(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func armingUnavailable(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestKeyPadArmingUnavailable(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
