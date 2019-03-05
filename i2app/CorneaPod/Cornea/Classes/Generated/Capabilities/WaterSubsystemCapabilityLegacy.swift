
//
// WaterSubsystemCapabilityLegacy.swift
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

public class WaterSubsystemCapabilityLegacy: NSObject, ArcusWaterSubsystemCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: WaterSubsystemCapabilityLegacy  = WaterSubsystemCapabilityLegacy()
  

  
  public static func getPrimaryWaterHeater(_ model: SubsystemModel) -> String? {
    return capability.getWaterSubsystemPrimaryWaterHeater(model)
  }
  
  public static func setPrimaryWaterHeater(_ primaryWaterHeater: String, model: SubsystemModel) {
    
    
    capability.setWaterSubsystemPrimaryWaterHeater(primaryWaterHeater, model: model)
  }
  
  public static func getPrimaryWaterSoftener(_ model: SubsystemModel) -> String? {
    return capability.getWaterSubsystemPrimaryWaterSoftener(model)
  }
  
  public static func setPrimaryWaterSoftener(_ primaryWaterSoftener: String, model: SubsystemModel) {
    
    
    capability.setWaterSubsystemPrimaryWaterSoftener(primaryWaterSoftener, model: model)
  }
  
  public static func getClosedWaterValves(_ model: SubsystemModel) -> [String]? {
    return capability.getWaterSubsystemClosedWaterValves(model)
  }
  
  public static func getWaterDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getWaterSubsystemWaterDevices(model)
  }
  
  public static func getContinuousWaterUseDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getWaterSubsystemContinuousWaterUseDevices(model)
  }
  
  public static func getExcessiveWaterUseDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getWaterSubsystemExcessiveWaterUseDevices(model)
  }
  
  public static func getLowSaltDevices(_ model: SubsystemModel) -> [String]? {
    return capability.getWaterSubsystemLowSaltDevices(model)
  }
  
}
