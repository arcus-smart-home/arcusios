
//
// MobileDeviceCapabilityLegacy.swift
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

public class MobileDeviceCapabilityLegacy: NSObject, ArcusMobileDeviceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: MobileDeviceCapabilityLegacy  = MobileDeviceCapabilityLegacy()
  

  
  public static func getPersonId(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDevicePersonId(model)
  }
  
  public static func getDeviceIndex(_ model: MobileDeviceModel) -> NSNumber? {
    guard let deviceIndex: Int = capability.getMobileDeviceDeviceIndex(model) else {
      return nil
    }
    return NSNumber(value: deviceIndex)
  }
  
  public static func getAssociated(_ model: MobileDeviceModel) -> Date? {
    guard let associated: Date = capability.getMobileDeviceAssociated(model) else {
      return nil
    }
    return associated
  }
  
  public static func getOsType(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceOsType(model)
  }
  
  public static func getOsVersion(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceOsVersion(model)
  }
  
  public static func setOsVersion(_ osVersion: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceOsVersion(osVersion, model: model)
  }
  
  public static func getFormFactor(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceFormFactor(model)
  }
  
  public static func setFormFactor(_ formFactor: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceFormFactor(formFactor, model: model)
  }
  
  public static func getPhoneNumber(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDevicePhoneNumber(model)
  }
  
  public static func setPhoneNumber(_ phoneNumber: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDevicePhoneNumber(phoneNumber, model: model)
  }
  
  public static func getDeviceIdentifier(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceDeviceIdentifier(model)
  }
  
  public static func setDeviceIdentifier(_ deviceIdentifier: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceDeviceIdentifier(deviceIdentifier, model: model)
  }
  
  public static func getDeviceModel(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceDeviceModel(model)
  }
  
  public static func setDeviceModel(_ deviceModel: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceDeviceModel(deviceModel, model: model)
  }
  
  public static func getDeviceVendor(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceDeviceVendor(model)
  }
  
  public static func setDeviceVendor(_ deviceVendor: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceDeviceVendor(deviceVendor, model: model)
  }
  
  public static func getResolution(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceResolution(model)
  }
  
  public static func setResolution(_ resolution: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceResolution(resolution, model: model)
  }
  
  public static func getNotificationToken(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceNotificationToken(model)
  }
  
  public static func setNotificationToken(_ notificationToken: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceNotificationToken(notificationToken, model: model)
  }
  
  public static func getLastLatitude(_ model: MobileDeviceModel) -> NSNumber? {
    guard let lastLatitude: Double = capability.getMobileDeviceLastLatitude(model) else {
      return nil
    }
    return NSNumber(value: lastLatitude)
  }
  
  public static func setLastLatitude(_ lastLatitude: Double, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceLastLatitude(lastLatitude, model: model)
  }
  
  public static func getLastLongitude(_ model: MobileDeviceModel) -> NSNumber? {
    guard let lastLongitude: Double = capability.getMobileDeviceLastLongitude(model) else {
      return nil
    }
    return NSNumber(value: lastLongitude)
  }
  
  public static func setLastLongitude(_ lastLongitude: Double, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceLastLongitude(lastLongitude, model: model)
  }
  
  public static func getLastLocationTime(_ model: MobileDeviceModel) -> Date? {
    guard let lastLocationTime: Date = capability.getMobileDeviceLastLocationTime(model) else {
      return nil
    }
    return lastLocationTime
  }
  
  public static func getName(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceName(model)
  }
  
  public static func setName(_ name: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceName(name, model: model)
  }
  
  public static func getAppVersion(_ model: MobileDeviceModel) -> String? {
    return capability.getMobileDeviceAppVersion(model)
  }
  
  public static func setAppVersion(_ appVersion: String, model: MobileDeviceModel) {
    
    
    capability.setMobileDeviceAppVersion(appVersion, model: model)
  }
  
}
