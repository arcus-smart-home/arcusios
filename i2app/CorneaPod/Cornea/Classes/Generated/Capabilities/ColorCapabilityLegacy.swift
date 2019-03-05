
//
// ColorCapabilityLegacy.swift
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

public class ColorCapabilityLegacy: NSObject, ArcusColorCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ColorCapabilityLegacy  = ColorCapabilityLegacy()
  

  
  public static func getHue(_ model: DeviceModel) -> NSNumber? {
    guard let hue: Int = capability.getColorHue(model) else {
      return nil
    }
    return NSNumber(value: hue)
  }
  
  public static func setHue(_ hue: Int, model: DeviceModel) {
    
    
    capability.setColorHue(hue, model: model)
  }
  
  public static func getSaturation(_ model: DeviceModel) -> NSNumber? {
    guard let saturation: Int = capability.getColorSaturation(model) else {
      return nil
    }
    return NSNumber(value: saturation)
  }
  
  public static func setSaturation(_ saturation: Int, model: DeviceModel) {
    
    
    capability.setColorSaturation(saturation, model: model)
  }
  
}
