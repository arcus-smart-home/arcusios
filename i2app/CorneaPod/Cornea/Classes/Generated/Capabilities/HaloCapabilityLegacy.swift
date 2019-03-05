
//
// HaloCapabilityLegacy.swift
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

public class HaloCapabilityLegacy: NSObject, ArcusHaloCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HaloCapabilityLegacy  = HaloCapabilityLegacy()
  
  static let HaloDevicestateSAFE: String = HaloDevicestate.safe.rawValue
  static let HaloDevicestateWEATHER: String = HaloDevicestate.weather.rawValue
  static let HaloDevicestateSMOKE: String = HaloDevicestate.smoke.rawValue
  static let HaloDevicestateCO: String = HaloDevicestate.co.rawValue
  static let HaloDevicestatePRE_SMOKE: String = HaloDevicestate.pre_smoke.rawValue
  static let HaloDevicestateEOL: String = HaloDevicestate.eol.rawValue
  static let HaloDevicestateLOW_BATTERY: String = HaloDevicestate.low_battery.rawValue
  static let HaloDevicestateVERY_LOW_BATTERY: String = HaloDevicestate.very_low_battery.rawValue
  static let HaloDevicestateFAILED_BATTERY: String = HaloDevicestate.failed_battery.rawValue
  
  static let HaloHushstatusSUCCESS: String = HaloHushstatus.success.rawValue
  static let HaloHushstatusTIMEOUT: String = HaloHushstatus.timeout.rawValue
  static let HaloHushstatusREADY: String = HaloHushstatus.ready.rawValue
  static let HaloHushstatusDISABLED: String = HaloHushstatus.disabled.rawValue
  
  static let HaloRoomNONE: String = HaloRoom.none.rawValue
  static let HaloRoomBASEMENT: String = HaloRoom.basement.rawValue
  static let HaloRoomBEDROOM: String = HaloRoom.bedroom.rawValue
  static let HaloRoomDEN: String = HaloRoom.den.rawValue
  static let HaloRoomDINING_ROOM: String = HaloRoom.dining_room.rawValue
  static let HaloRoomDOWNSTAIRS: String = HaloRoom.downstairs.rawValue
  static let HaloRoomENTRYWAY: String = HaloRoom.entryway.rawValue
  static let HaloRoomFAMILY_ROOM: String = HaloRoom.family_room.rawValue
  static let HaloRoomGAME_ROOM: String = HaloRoom.game_room.rawValue
  static let HaloRoomGUEST_BEDROOM: String = HaloRoom.guest_bedroom.rawValue
  static let HaloRoomHALLWAY: String = HaloRoom.hallway.rawValue
  static let HaloRoomKIDS_BEDROOM: String = HaloRoom.kids_bedroom.rawValue
  static let HaloRoomLIVING_ROOM: String = HaloRoom.living_room.rawValue
  static let HaloRoomMASTER_BEDROOM: String = HaloRoom.master_bedroom.rawValue
  static let HaloRoomOFFICE: String = HaloRoom.office.rawValue
  static let HaloRoomSTUDY: String = HaloRoom.study.rawValue
  static let HaloRoomUPSTAIRS: String = HaloRoom.upstairs.rawValue
  static let HaloRoomWORKOUT_ROOM: String = HaloRoom.workout_room.rawValue
  
  static let HaloRemotetestresultSUCCESS: String = HaloRemotetestresult.success.rawValue
  static let HaloRemotetestresultFAIL_ION_SENSOR: String = HaloRemotetestresult.fail_ion_sensor.rawValue
  static let HaloRemotetestresultFAIL_PHOTO_SENSOR: String = HaloRemotetestresult.fail_photo_sensor.rawValue
  static let HaloRemotetestresultFAIL_CO_SENSOR: String = HaloRemotetestresult.fail_co_sensor.rawValue
  static let HaloRemotetestresultFAIL_TEMP_SENSOR: String = HaloRemotetestresult.fail_temp_sensor.rawValue
  static let HaloRemotetestresultFAIL_WEATHER_RADIO: String = HaloRemotetestresult.fail_weather_radio.rawValue
  static let HaloRemotetestresultFAIL_OTHER: String = HaloRemotetestresult.fail_other.rawValue
  
  static let HaloHaloalertstateQUIET: String = HaloHaloalertstate.quiet.rawValue
  static let HaloHaloalertstateINTRUDER: String = HaloHaloalertstate.intruder.rawValue
  static let HaloHaloalertstatePANIC: String = HaloHaloalertstate.panic.rawValue
  static let HaloHaloalertstateWATER: String = HaloHaloalertstate.water.rawValue
  static let HaloHaloalertstateSMOKE: String = HaloHaloalertstate.smoke.rawValue
  static let HaloHaloalertstateCO: String = HaloHaloalertstate.co.rawValue
  static let HaloHaloalertstateCARE: String = HaloHaloalertstate.care.rawValue
  static let HaloHaloalertstateALERTING_GENERIC: String = HaloHaloalertstate.alerting_generic.rawValue
  

  
  public static func getDevicestate(_ model: DeviceModel) -> String? {
    return capability.getHaloDevicestate(model)?.rawValue
  }
  
  public static func getHushstatus(_ model: DeviceModel) -> String? {
    return capability.getHaloHushstatus(model)?.rawValue
  }
  
  public static func getRoom(_ model: DeviceModel) -> String? {
    return capability.getHaloRoom(model)?.rawValue
  }
  
  public static func setRoom(_ room: String, model: DeviceModel) {
    guard let room: HaloRoom = HaloRoom(rawValue: room) else { return }
    
    capability.setHaloRoom(room, model: model)
  }
  
  public static func getRoomNames(_ model: DeviceModel) -> [String: String]? {
    return capability.getHaloRoomNames(model)
  }
  
  public static func getRemotetestresult(_ model: DeviceModel) -> String? {
    return capability.getHaloRemotetestresult(model)?.rawValue
  }
  
  public static func getHaloalertstate(_ model: DeviceModel) -> String? {
    return capability.getHaloHaloalertstate(model)?.rawValue
  }
  
  public static func setHaloalertstate(_ haloalertstate: String, model: DeviceModel) {
    guard let haloalertstate: HaloHaloalertstate = HaloHaloalertstate(rawValue: haloalertstate) else { return }
    
    capability.setHaloHaloalertstate(haloalertstate, model: model)
  }
  
  public static func startHush(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHaloStartHush(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func sendHush(_  model: DeviceModel, color: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestHaloSendHush(model, color: color))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancelHush(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHaloCancelHush(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func startTest(_ model: DeviceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestHaloStartTest(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
