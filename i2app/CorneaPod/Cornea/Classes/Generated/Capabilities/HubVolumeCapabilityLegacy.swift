
//
// HubVolumeCapabilityLegacy.swift
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

public class HubVolumeCapabilityLegacy: NSObject, ArcusHubVolumeCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: HubVolumeCapabilityLegacy  = HubVolumeCapabilityLegacy()
  
  static let HubVolumeVolumeOFF: String = HubVolumeVolume.off.rawValue
  static let HubVolumeVolumeLOW: String = HubVolumeVolume.low.rawValue
  static let HubVolumeVolumeMID: String = HubVolumeVolume.mid.rawValue
  static let HubVolumeVolumeHIGH: String = HubVolumeVolume.high.rawValue
  

  
  public static func getVolume(_ model: HubModel) -> String? {
    return capability.getHubVolumeVolume(model)?.rawValue
  }
  
  public static func setVolume(_ volume: String, model: HubModel) {
    guard let volume: HubVolumeVolume = HubVolumeVolume(rawValue: volume) else { return }
    
    capability.setHubVolumeVolume(volume, model: model)
  }
  
}
