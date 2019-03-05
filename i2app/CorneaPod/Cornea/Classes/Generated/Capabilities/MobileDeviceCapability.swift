
//
// MobileDeviceCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var mobileDeviceNamespace: String = "mobiledevice"
  public static var mobileDeviceName: String = "MobileDevice"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let mobileDevicePersonId: String = "mobiledevice:personId"
  static let mobileDeviceDeviceIndex: String = "mobiledevice:deviceIndex"
  static let mobileDeviceAssociated: String = "mobiledevice:associated"
  static let mobileDeviceOsType: String = "mobiledevice:osType"
  static let mobileDeviceOsVersion: String = "mobiledevice:osVersion"
  static let mobileDeviceFormFactor: String = "mobiledevice:formFactor"
  static let mobileDevicePhoneNumber: String = "mobiledevice:phoneNumber"
  static let mobileDeviceDeviceIdentifier: String = "mobiledevice:deviceIdentifier"
  static let mobileDeviceDeviceModel: String = "mobiledevice:deviceModel"
  static let mobileDeviceDeviceVendor: String = "mobiledevice:deviceVendor"
  static let mobileDeviceResolution: String = "mobiledevice:resolution"
  static let mobileDeviceNotificationToken: String = "mobiledevice:notificationToken"
  static let mobileDeviceLastLatitude: String = "mobiledevice:lastLatitude"
  static let mobileDeviceLastLongitude: String = "mobiledevice:lastLongitude"
  static let mobileDeviceLastLocationTime: String = "mobiledevice:lastLocationTime"
  static let mobileDeviceName: String = "mobiledevice:name"
  static let mobileDeviceAppVersion: String = "mobiledevice:appVersion"
  
}

public protocol ArcusMobileDeviceCapability: class, RxArcusService {
  /** Platform-owned identifier of the person that owns this device. */
  func getMobileDevicePersonId(_ model: MobileDeviceModel) -> String?
  /** Platform-owned index for the device that uniquely identifies it within the context of the person */
  func getMobileDeviceDeviceIndex(_ model: MobileDeviceModel) -> Int?
  /** Platform-owned timestamp of when it associated this mobile device with the person. */
  func getMobileDeviceAssociated(_ model: MobileDeviceModel) -> Date?
  /** The type of operating system the mobile device is running (iOS, Android for example). */
  func getMobileDeviceOsType(_ model: MobileDeviceModel) -> String?
  /** The version of the operating system running on the mobile device. */
  func getMobileDeviceOsVersion(_ model: MobileDeviceModel) -> String?
  /** The version of the operating system running on the mobile device. */
  func setMobileDeviceOsVersion(_ osVersion: String, model: MobileDeviceModel)
/** The form factor of the device (phone, tablet for example). */
  func getMobileDeviceFormFactor(_ model: MobileDeviceModel) -> String?
  /** The form factor of the device (phone, tablet for example). */
  func setMobileDeviceFormFactor(_ formFactor: String, model: MobileDeviceModel)
/** The phone number of the device if present. */
  func getMobileDevicePhoneNumber(_ model: MobileDeviceModel) -> String?
  /** The phone number of the device if present. */
  func setMobileDevicePhoneNumber(_ phoneNumber: String, model: MobileDeviceModel)
/** The mobile device provided unique identifier */
  func getMobileDeviceDeviceIdentifier(_ model: MobileDeviceModel) -> String?
  /** The mobile device provided unique identifier */
  func setMobileDeviceDeviceIdentifier(_ deviceIdentifier: String, model: MobileDeviceModel)
/** The model of the device if known. */
  func getMobileDeviceDeviceModel(_ model: MobileDeviceModel) -> String?
  /** The model of the device if known. */
  func setMobileDeviceDeviceModel(_ deviceModel: String, model: MobileDeviceModel)
/** The vendor of the device if known. */
  func getMobileDeviceDeviceVendor(_ model: MobileDeviceModel) -> String?
  /** The vendor of the device if known. */
  func setMobileDeviceDeviceVendor(_ deviceVendor: String, model: MobileDeviceModel)
/** The screen resolution of the device (ex. xhdpi) */
  func getMobileDeviceResolution(_ model: MobileDeviceModel) -> String?
  /** The screen resolution of the device (ex. xhdpi) */
  func setMobileDeviceResolution(_ resolution: String, model: MobileDeviceModel)
/** The token for sending push notifications to this device if it is registered to do so. */
  func getMobileDeviceNotificationToken(_ model: MobileDeviceModel) -> String?
  /** The token for sending push notifications to this device if it is registered to do so. */
  func setMobileDeviceNotificationToken(_ notificationToken: String, model: MobileDeviceModel)
/** The last measured latitude if collected. */
  func getMobileDeviceLastLatitude(_ model: MobileDeviceModel) -> Double?
  /** The last measured latitude if collected. */
  func setMobileDeviceLastLatitude(_ lastLatitude: Double, model: MobileDeviceModel)
/** The last measured longitude if collected. */
  func getMobileDeviceLastLongitude(_ model: MobileDeviceModel) -> Double?
  /** The last measured longitude if collected. */
  func setMobileDeviceLastLongitude(_ lastLongitude: Double, model: MobileDeviceModel)
/** The timestamp that the latitude and longitude were last collected. */
  func getMobileDeviceLastLocationTime(_ model: MobileDeviceModel) -> Date?
  /** A friendly name for the device. */
  func getMobileDeviceName(_ model: MobileDeviceModel) -> String?
  /** A friendly name for the device. */
  func setMobileDeviceName(_ name: String, model: MobileDeviceModel)
/** The version of the Arcus app installed on this device. */
  func getMobileDeviceAppVersion(_ model: MobileDeviceModel) -> String?
  /** The version of the Arcus app installed on this device. */
  func setMobileDeviceAppVersion(_ appVersion: String, model: MobileDeviceModel)

  
}

extension ArcusMobileDeviceCapability {
  public func getMobileDevicePersonId(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDevicePersonId] as? String
  }
  
  public func getMobileDeviceDeviceIndex(_ model: MobileDeviceModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceDeviceIndex] as? Int
  }
  
  public func getMobileDeviceAssociated(_ model: MobileDeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.mobileDeviceAssociated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getMobileDeviceOsType(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceOsType] as? String
  }
  
  public func getMobileDeviceOsVersion(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceOsVersion] as? String
  }
  
  public func setMobileDeviceOsVersion(_ osVersion: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceOsVersion: osVersion as AnyObject])
  }
  public func getMobileDeviceFormFactor(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceFormFactor] as? String
  }
  
  public func setMobileDeviceFormFactor(_ formFactor: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceFormFactor: formFactor as AnyObject])
  }
  public func getMobileDevicePhoneNumber(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDevicePhoneNumber] as? String
  }
  
  public func setMobileDevicePhoneNumber(_ phoneNumber: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDevicePhoneNumber: phoneNumber as AnyObject])
  }
  public func getMobileDeviceDeviceIdentifier(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceDeviceIdentifier] as? String
  }
  
  public func setMobileDeviceDeviceIdentifier(_ deviceIdentifier: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceDeviceIdentifier: deviceIdentifier as AnyObject])
  }
  public func getMobileDeviceDeviceModel(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceDeviceModel] as? String
  }
  
  public func setMobileDeviceDeviceModel(_ deviceModel: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceDeviceModel: deviceModel as AnyObject])
  }
  public func getMobileDeviceDeviceVendor(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceDeviceVendor] as? String
  }
  
  public func setMobileDeviceDeviceVendor(_ deviceVendor: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceDeviceVendor: deviceVendor as AnyObject])
  }
  public func getMobileDeviceResolution(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceResolution] as? String
  }
  
  public func setMobileDeviceResolution(_ resolution: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceResolution: resolution as AnyObject])
  }
  public func getMobileDeviceNotificationToken(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceNotificationToken] as? String
  }
  
  public func setMobileDeviceNotificationToken(_ notificationToken: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceNotificationToken: notificationToken as AnyObject])
  }
  public func getMobileDeviceLastLatitude(_ model: MobileDeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceLastLatitude] as? Double
  }
  
  public func setMobileDeviceLastLatitude(_ lastLatitude: Double, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceLastLatitude: lastLatitude as AnyObject])
  }
  public func getMobileDeviceLastLongitude(_ model: MobileDeviceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceLastLongitude] as? Double
  }
  
  public func setMobileDeviceLastLongitude(_ lastLongitude: Double, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceLastLongitude: lastLongitude as AnyObject])
  }
  public func getMobileDeviceLastLocationTime(_ model: MobileDeviceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.mobileDeviceLastLocationTime] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getMobileDeviceName(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceName] as? String
  }
  
  public func setMobileDeviceName(_ name: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceName: name as AnyObject])
  }
  public func getMobileDeviceAppVersion(_ model: MobileDeviceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.mobileDeviceAppVersion] as? String
  }
  
  public func setMobileDeviceAppVersion(_ appVersion: String, model: MobileDeviceModel) {
    model.set([Attributes.mobileDeviceAppVersion: appVersion as AnyObject])
  }
  
}
