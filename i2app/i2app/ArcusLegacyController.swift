//
//  ArcusLegacyController.swift
//  i2app
//
//  Created by Arcus Team on 3/19/18.
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
import RxSwift
import RxSwiftExt

/**
 
 Previously Cornea knew about the controllers and the Controllers knew about Cornea that circular dependency
 is broken with the interface ArcusLegacyLogic provided to us by Cornea
 
 Due to a number of reasons Cornea could not handle all of the special cases needed for some of our
 Legacy Controllers. This Object handles that communication between Cornea and i2App without creating a
 circular dependency between Cornea and the controllers.
 
 */
public class ArcusLegacyObject: NSObject, ArcusLegacyLogic, DeviceTokenController {
  public var disposeBag = DisposeBag()
  
  public func clearCurrentUserStates() {
    SubsystemsController.sharedInstance().clearCurrentUserStates()
  }
  
  public func retrieveSubsystems(forPlaceId: String) {
    SubsystemsController.sharedInstance().retrieveSubsystems(forPlaceId: forPlaceId)
  }
  
  public func addOrUpdateSubsystem(with: SubsystemModel, andSource: String) {
    SubsystemsController.sharedInstance().addOrUpdateSubsystem(with: with, andSource: andSource)
  }
  
  public func suspendCacheLoadRouting() {
    CorneaController.suspendCacheLoadRouting(true)
  }
  
  public func sendDeviceInfo(_ person: PersonModel, deviceToken: String? = nil) {
    getDeviceUDID()
      .asObservable()
      .subscribe(
        onNext: { [weak self] keychain in
          let uniqueIdentifier = keychain.value
          self?.requestSendDeviceInfo(person,
                                    uniqueDeviceIdentifier: uniqueIdentifier,
                                    deviceToken: deviceToken)
        },
        onError: { [weak self] value in
          guard let uniqueIdentifier = self?.uniqueDeviceIdentifier() else {
            return
          }
          
          self?.saveDeviceUDID(uniqueIdentifier)
          self?.requestSendDeviceInfo(person,
                                      uniqueDeviceIdentifier: uniqueIdentifier,
                                      deviceToken: deviceToken)
        }
      )
      .disposed(by: disposeBag)
  }
  
  private func uniqueDeviceIdentifier() -> String? {
    guard let uniqueIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
      ArcusAnalytics.tag(AnalyticsTags.ErrorUniqueDeviceIdentifier, attributes: [:])
      return nil
    }
  
    return uniqueIdentifier
  }
  
  private func requestSendDeviceInfo(_ person: PersonModel,
                                     uniqueDeviceIdentifier: String,
                                     deviceToken: String? = nil) {
    let bounds = UIScreen.main.bounds
    let name = UIDevice().modelName
    let resolution = "\(bounds.width) by \(bounds.height)"
    let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let identifier = uniqueDeviceIdentifier
    let phone = "Not Legal"
    let os = "ios"
    let vendor = "Apple"
    var formFactor = "phone"
    var appVersion = ""
    var notificationToken = ""
    
    if let info = BuildConfigure.clientVersionInfo() {
      appVersion = info
    }
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      formFactor = "tablet"
    }
    
    if let value = deviceToken {
      notificationToken = value
    }
    
    _ = PersonCapabilityLegacy.addMobileDevice(person,
                                               name: name,
                                               appVersion: appVersion,
                                               osType: os,
                                               osVersion: osVersion,
                                               formFactor: formFactor,
                                               phoneNumber: phone,
                                               deviceIdentifier: identifier,
                                               deviceModel: name,
                                               deviceVendor: vendor,
                                               resolution: resolution,
                                               notificationToken: notificationToken,
                                               lastLatitude: 0.0,
                                               lastLongitude: 0.0)
  }
}


