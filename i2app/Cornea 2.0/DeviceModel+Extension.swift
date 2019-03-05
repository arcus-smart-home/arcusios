//
//  DeviceModel+Extension.swift
//  i2app
//
//  Created by Arcus Team on 9/29/17.
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
import PromiseKit
import Cornea

extension Constants {
  static let C2C_HONEYWELL: String = "HWLL"
  static let MOCK: String = "MOCK"
  static let kWifiSmartSwitchId: String = "162918"
}

fileprivate struct AssociatedKeys {
  static var kDeviceTypeKey: UInt8 = 0
  static var kOperationsControllerKey: UInt8 = 0
}

extension DeviceModel {
  // MARK: DeviceType

  var deviceType: DeviceType {
    guard let hint = DeviceCapability.getDevtypehintFrom(self),
      let caps = getCapabilities() else {
      return .none
    }
    return DeviceModel.deviceTypeFromHint(hint,
                                          andOther: caps,
                                          other: nil)
  }

  override public var name: String {
    if let name = DeviceCapability.getNameFrom(self) {
      return name
    }
    return "Device Name not available"
  }

  var productId: String? {
    return DeviceCapabilityLegacy.getProductId(self)
  }

  var vendor: String? {
    return DeviceCapability.getVendorFrom(self)
  }

  var deviceTypeName: String? {
    return DeviceCapability.getDevtypehintFrom(self)
  }
  
  var isSwannCamera: Bool {
    return caps?.contains(Constants.swannBatteryCameraNamespace) ?? false
  }

  var viewControllerClass: AnyClass? {
    if isDimmer() == true && isHaloOrHaloPlus() == false {
      return NSClassFromString("DimmerOperationViewController")
    }

    if let classString = DeviceModel.typeToClassDictionary[deviceType] as? String {
      return NSClassFromString(classString)
    }

    return nil
  }

  var operationController: DeviceOperationBaseController? {
    get {
      guard let controller =
        objc_getAssociatedObject(self,
                                 &AssociatedKeys.kOperationsControllerKey)
          as? DeviceOperationBaseController else { return nil }
      return controller
    }
    set {
      objc_setAssociatedObject(self,
                               &AssociatedKeys.kOperationsControllerKey,
                               newValue,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension DeviceModel {
  static let typeToClassDictionary: [AnyHashable: Any] =
    [DeviceType.accessory: "AccessoryOperationController",
     DeviceType.contactSensor: "ContactSensorOperationController",
     DeviceType.fanSwitch: "FanOperationViewController",
     DeviceType.switch: "SwitchOperationViewController",
     DeviceType.motionSensor: "MotionSensorOperationViewController",
     DeviceType.locks: "LocksOperationViewController",
     DeviceType.dimmer: "DimmerOperationViewController",
     DeviceType.thermostat: "i2app.GenericThermostatOperationViewController",
     DeviceType.thermostatHoneywellC2C: "i2app.HoneywellC2CThermostatOperationViewController",
     DeviceType.thermostatNest: "i2app.NestThermostatOperationViewController",
     DeviceType.keyFob: "KeyFobOperationViewController",
     DeviceType.hub: "HubOperationViewController",
     DeviceType.waterLeak: "LeakOperationViewController",
     DeviceType.smokeDetector: "SmokeDetectorOperationViewController",
     DeviceType.button: "SmartButtonOperationViewController",
     DeviceType.camera: "CameraOperationViewController",
     DeviceType.carePendant: "CarePendantOperationViewController",
     DeviceType.petDoor: "PetDoorOperationViewController",
     DeviceType.garageDoor: "GarageDoorViewController",
     DeviceType.garageDoorController: "GarageDoorControllerViewController",
     DeviceType.glassBreak: "GlassBreakViewController",
     DeviceType.keyPad: "KeypadDeviceViewController",
     DeviceType.lightBulb: "LightbulbDeviceViewController",
     DeviceType.siren: "SirenOperationViewController",
     DeviceType.vent: "VentOperationViewController",
     DeviceType.irrigation: "IrrigationOperationViewController",
     DeviceType.waterSoftener: "WaterSoftenerOperationController",
     DeviceType.tiltSensor: "TiltSensorOperationController",
     DeviceType.waterValve: "WaterValveOperationController",
     DeviceType.waterHeater: "WaterHeaterOperationController",
     DeviceType.somfyBlinds: "SomfyBlindViewController",
     DeviceType.somfyBlindsController: "SomfyBlindControllerViewController",
     DeviceType.spaceHeater: "DuraflameOperationViewController",
     DeviceType.halo: "HaloOperationViewController",
     DeviceType.shade: "SpringsBlindsViewController",
     DeviceType.hueBridge: "i2app.HueBridgeOperationViewController",
     DeviceType.hueFallback: "i2app.HueFallbackOperationViewController",
     DeviceType.lutronCasetaSmartBridge: "i2app.LutronCasetaSmartBridgeOperationViewController"]

  static func deviceTypeFromHint(_ hint: String,
                                 andOther capabilities: [String],
                                 other params: AnyObject?) -> DeviceType {
    switch hint.lowercased() {
    case "accessory":
      return .accessory
    case "alexa":
      return .alexa
    case "button":
      return .button
    case "camera":
      return .camera
    case "contact":
      return .contactSensor
    case "dimmer":
      return .dimmer
    case "fan control":
      return .fanSwitch
    case "garage door":
      return .garageDoor
    case "garage door controller":
      return .garageDoorController
    case "glass break":
      return .glassBreak
    case "genie aladdin controller":
      return .garageDoorController
    case "googleassistant":
      return .googleHomeAssistant
    case "hub":
      return .hub
    case "halo":
      return .halo
    case "hue bridge":
      return .hueBridge
    case "hue fallback":
      return .hueFallback
    case "irrigation":
      return .irrigation
    case "keyfob":
      return .keyFob
    case "keypad":
      return .keyPad
    case "lock":
      return .locks
    case "light":
      return .lightBulb
    case "lutron bridge":
      return .lutronCasetaSmartBridge
    case "motion":
      return .motionSensor
    case "nestthermostat":
      return .thermostatNest
    case "pendant":
      return .carePendant
    case "pet door", "petdoor":
      return .petDoor
    case "siren":
      return .siren
    case "shade":
      return .shade
    case "smoke/co":
      return .smokeDetector
    case "somfyv1blind":
      return .somfyBlinds
    case "somfyv1bridge":
      return .somfyBlindsController
    case "switch":
      if let productId = params as? String {
        if productId == Constants.kWifiSmartSwitchId {
          return .wifiSwitch
        }
        return .switch
      }
      return .switch
    case "spaceheater":
      return .spaceHeater
    case "thermostat":
      return .thermostat
    case "tccthermostat":
      return .thermostatHoneywellC2C
    case "tilt":
      return .tiltSensor
    case "vent":
      return .vent
    case "waterheater", "water heater":
      return .waterHeater
    case "waterleak", "water leak":
      return .waterLeak
    case "watersoftener":
      return .waterSoftener
    case "watervalve", "water valve":
      return .waterValve
    default:
      return .none
    }
  }

  // MARK: DeviceSubType

  func isC2CDevice() -> Bool {
    if self.deviceType == .thermostatHoneywellC2C ||
      self.deviceType == .thermostatNest ||
      self.deviceType == .lutronCasetaSmartBridge {
      return true
    }
    return false
  }

  func isAuthorizedC2CDevice() -> Bool {
    return HoneywellTCCCapability
      .getAuthorizationState(from: self) == kEnumHoneywellTCCAuthorizationStateAUTHORIZED
  }

  func isDisabledC2CDevice() -> Bool {
    if deviceType == .thermostatHoneywellC2C {
      return isAuthorizedC2CDevice() == false
        || HoneywellTCCCapability.getRequiresLogin(from: self)
        || isDeviceOffline()
    }
    return false
  }

  func isDisabledDevice() -> Bool {
    if isDeviceOffline() == true {
      return true
    }

    if isC2CDevice() == true {
      return isDisabledC2CDevice()
    }

    return false
  }

  func isDeviceOffline() -> Bool {
    guard let state = DeviceConnectionCapability.getStateFrom(self) else {
      return true // Verify?
    }
    return state == kEnumDeviceConnectionStateOFFLINE
  }

  func isUpdatingFirmware() -> Bool {
    guard let status: String = DeviceOtaCapabilityLegacy.getStatus(self) else {
      return false
    }
    return status == kEnumDeviceOtaStatusINPROGRESS
  }

  func smokeDetectorHasCOCapability() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(CarbonMonoxideCapability.namespace())
  }

  func isSwitch() -> Bool {
    guard let caps = getCapabilities() else { return false }

    let namespace: String = SwitchCapability.namespace()

    for attr in caps {
      if attr == namespace {
        return true
      }
    }
    return false
  }

  func isVent() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    let namespace: String = VentCapability.namespace()

    return caps.contains(namespace)
  }

  func isDimmer() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(DimmerCapability.namespace())
  }

  func isRGBLight() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(ColorCapability.namespace())
  }

  func isColorTemperatureLight() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(ColorTemperatureCapability.namespace())
  }

  func isColorModeLight() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(LightCapability.namespace())
  }

  func hasWiFiCapability() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(WiFiCapability.namespace())
  }

  func isSwitchedOn() -> Bool {
    if isSwitch() == false {
      return false
    }

    let switchState = SwitchCapability.getStateFrom(self)
    return switchState == kEnumSwitchStateON
  }

  func cameraSupportsIR() -> Bool {
    if let _ = CameraCapability.getIrLedSupportedModes(from: self) {
      return true
    }
    return false
  }

  func deviceSupportsPower() -> Bool {
    guard let caps = getCapabilities() else {
      return false
    }
    return caps.contains(PowerUseCapability.namespace())
  }

  func isHaloOrHaloPlus() -> Bool {
    return deviceType == .halo
  }

  func isHaloPlus() -> Bool {
    guard let caps = getCapabilities(),
      let namespace = WeatherRadioCapability.namespace() else {
      return false
    }

    return deviceType == .halo && caps.contains(namespace)
  }

  func getAssignedPerson() -> PersonModel? {
    // TODO: Verify Address of Id
    guard let personAddress = PresenceCapability.getPersonFrom(self) else { return nil }

    if personAddress == "UNSET" {
      return nil
    }
    return RxCornea.shared.modelCache?.fetchModel(personAddress) as? PersonModel
  }

  // MARK: Fob Button Types

  static func arcusButtonTypeName() -> [String] {
    return ["circle", "diamond", "hexagon", "square", "home", "away", "none", "a", "b"]
  }

  static func arcusButtonTypeToString(_ buttonType: ButtonType) -> String {
    let type = arcusButtonTypeName()
    return type[Int(buttonType.rawValue)]
  }

  static func arcusStringToButtonType(_ buttonName: String) -> ButtonType {
    let types = arcusButtonTypeName()
    guard let arrayIndex = types.index(of: buttonName) else {
      return ButtonType.init(0) // TEST
    }

    let index = UInt32(types.startIndex.distance(to: arrayIndex))
    return ButtonType.init(index)
  }

  // MARK: Device Event State

  func hasEvents() -> Bool {
    return DeviceEventStore.sharedInstance().hasEvents(self.modelId)
  }

  func hasEventForAttribute(_ attribute: String) -> Bool {
    return DeviceEventStore.sharedInstance().hasEvent(forAttribute: attribute, deviceId: self.modelId)
  }

  func getEventAttributes() -> [Any] {
    return DeviceEventStore.sharedInstance().getEventAttributes(self.modelId)
  }

  func getEventForAttribute(_ attribute: String) -> Date? {
    return DeviceEventStore.sharedInstance().getEventForAttribute(attribute, deviceId: self.modelId)
  }

  func addNewEventForAttribute(_ attribute: String) {
    DeviceEventStore.sharedInstance().addNewEvent(forAttribute: attribute, deviceId: self.modelId)
  }

  func removeEventForAttribute(_ attribute: String) {
    DeviceEventStore.sharedInstance().removeEvent(forAttribute: attribute, deviceId: self.modelId)
  }

  func clearStaleEventsWithDuration(_ seconds: TimeInterval) {
    DeviceEventStore.sharedInstance().clearStaleEvents(withDuration: seconds, deviceId: self.modelId)
  }

  func clearStaleEventsAndReturnLongestDuration(_ duration: TimeInterval) -> TimeInterval {
    clearStaleEventsWithDuration(duration)

    var secondsUntilEnd: TimeInterval = 0.0

    // Do we still have events?
    if hasEvents() == true {
      // Get events and figure out the longest time
      if let attributes = getEventAttributes() as? [String] {
        for attr in attributes {
          guard let attribute = attr as String?,
            let date = getEventForAttribute(attribute)?.timeIntervalSince1970 else {
              continue
          }

          let now = Date().timeIntervalSince1970

          // Date + Duration should be greater than now at this point so figure out how much difference
          let difference = date + duration - now

          if difference > secondsUntilEnd {
            secondsUntilEnd = difference
          }
        }
      }
    }
    return secondsUntilEnd
  }

  // MARK: Security Status

  func securityModeStatus() -> String {
    if let securitySubSystemController = SubsystemsController.sharedInstance().securityController {
      if securitySubSystemController.is(onModeDevice: self) == true {
        if securitySubSystemController.isPartialModeDevice(self) {
          return NSLocalizedString("On & Partial", comment: "")
        } else {
          return NSLocalizedString("On", comment: "")
        }
      } else if securitySubSystemController.isPartialModeDevice(self) {
        return NSLocalizedString("Partial", comment: "");
      }
      return NSLocalizedString("Not Participating", comment: "")
    }
    return ""
  }

  func securityDeviceStatus() -> String {
    if let securitySubSystemController = SubsystemsController.sharedInstance().securityController {
      if securitySubSystemController.isOfflineDeviceId(self.modelId) == true {
        return NSLocalizedString("Offline", comment: "")
      }

      switch self.deviceType {
      case .contactSensor:
        guard let state = ContactCapability.getContactFrom(self),
          let stateString = state.lowercased().stringUpperCaseFirstLetter(),
          let date = ContactCapability.getContactchangedFrom(self) as NSDate?,
          let dateString = date.lastChangedTime() else { break }
        return "\(stateString) \(dateString)"
      case .motionSensor:
        guard let date = MotionCapability.getMotionchangedFrom(self) as? NSDate,
          let dateString = date.lastChangedTime() else { break }
        let state = NSLocalizedString("Last Activity", comment: "")
        return "\(state) \(dateString)"
      case .locks:
        guard let state = DoorLockCapability.getLockstateFrom(self),
          let stateString = state.lowercased().stringUpperCaseFirstLetter(),
          let date = MotionCapability.getMotionchangedFrom(self) as? NSDate,
          let dateString = date.lastChangedTime() else { break }
        return "\(stateString) \(dateString)"
      default:
        break
      }
    }
    return NSLocalizedString("Active", comment: "")
  }

  // MARK: Vendor Images

  func devTypeHintToImageName() -> String {
    if let hint = objc_getAssociatedObject(self, &AssociatedKeys.kDeviceTypeKey) as? String, hint.count > 0 {
      return hint
    }

    if let hint: String = ImagePaths.devTypeHint(toImageName: DeviceCapabilityLegacy.getDevtypehint(self)),
      hint.count > 0 {
      objc_setAssociatedObject(self,
                               &AssociatedKeys.kDeviceTypeKey,
                               hint,
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return hint
    }
    return ""
  }

  func assignPerson(_ person: PersonModel,
                    completeBlock: @escaping () -> Void,
                    failedBlock: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
      PresenceCapability.setPerson(person.address, on: self)
      PresenceCapability.setUsehint(kEnumPresenceUsehintPERSON, on: self)
      self.commit()
        .swiftThen { _ in
          completeBlock()
          return nil
        }
        .swiftCatch { _ in
          failedBlock()
          return nil
        }
    }
  }

  func unassignPerson(_ completion: @escaping () -> (), failedBlock: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
      PresenceCapability.setPerson("", on: self)
      PresenceCapability.setUsehint(kEnumPresenceUsehintUNKNOWN, on: self)
      _ = self.commit()
        .swiftThen { _ in
          completion()
          return nil
        }
        .swiftCatch { _ in
          failedBlock()
          return nil
      }
    }
  }

  // MARK: Product

  func batteryLevel() -> NSNumber? {
    guard let battery = DevicePowerCapabilityLegacy.getBattery(self) else {
      return nil
    }

    return battery
  }

  func shortName() -> String? {
    guard let productId = DeviceCapabilityLegacy.getProductId(self) else {
      return nil
    }

    let productAddress = ProductModel.addressForId(productId)

    guard let product = RxCornea.shared.modelCache?.fetchModel(productAddress) as? ProductModel else {
      return nil
    }

    return ProductCapability.getShortName(from: product)
  }

  func productShortName() -> PMKPromise {
    guard let productId = DeviceCapabilityLegacy.getProductId(self) else {
      return PMKPromise.new { (_: PMKFulfiller?, rejector: PMKRejecter?) in
        rejector?(nil)
      }
    }
    return ProductCatalogController.getProductWithId(productId).swiftThen { product in
      return PMKPromise.new { (fulfiller: PMKFulfiller?, rejector: PMKRejecter?) in
        guard let product = product as? ProductModel else {
          // TODO: Return Error
          rejector?(nil)
          return
        }
        fulfiller?(ProductCapability.getShortName(from: product))
      }
    }
  }

  // MARK: Fob Rule Templates

  static func arcusGen2FourButtonFobRuleTemplateIds() -> [String] {
    return ["smartfob-arm-on", "smartfob-disarm", "smartfob-arm-partial", "smartfob-chime"]
  }

  static func arcusGen1TwoButtonFobRuleTemplateIds() -> [String] {
    return ["smartfobgen1-arm-on", "smartfobgen1-disarm", "smartfobgen1-arm-partial", "smartfobgen1-chime"]
  }

  static func arcusSmartButtonRuleTemplateIds() -> [String] {
    return ["button-panic", "button-chime"]
  }

  static func arcusGen3FourButtonFobRuleTemplateIds() -> [String] {
    return ["smartfobgen3-arm-on", "smartfobgen3-disarm", "smartfobgen3-arm-partial", "smartfobgen3-chime"];
  }

  static func arcusGen2FourButtonFobRuleTemplateNames() -> [String] {
    return [NSLocalizedString("Alarm On", comment: ""),
            NSLocalizedString("Alarm Off", comment: ""),
            NSLocalizedString("Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusGen1TwoButtonFobRuleTemplateNames() -> [String] {
    return [NSLocalizedString("Alarm On", comment: ""),
            NSLocalizedString("Alarm Off", comment: ""),
            NSLocalizedString("Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusSmartButtonRuleTemplateNames() -> [String] {
    return [NSLocalizedString("Trigger Panic Alarm", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusGen2FourButtonFobRuleTemplateLongNames() -> [String] {
    return [NSLocalizedString("Security Alarm On", comment: ""),
            NSLocalizedString("Security Alarm Off", comment: ""),
            NSLocalizedString("Security Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusGen1TwoButtonFobRuleTemplateLongNames() -> [String] {
    return [NSLocalizedString("Security Alarm On", comment: ""),
            NSLocalizedString("Security Alarm Off", comment: ""),
            NSLocalizedString("Security Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusGen3FourButtonFobRuleTemplateLongNames() -> [String] {
    return [NSLocalizedString("Security Alarm On", comment: ""),
            NSLocalizedString("Security Alarm Off", comment: ""),
            NSLocalizedString("Security Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  static func arcusGen3FourButtonFobRuleTemplateNames() -> [String] {
    return [NSLocalizedString("Alarm On", comment: ""),
            NSLocalizedString("Alarm Off", comment: ""),
            NSLocalizedString("Alarm Partial", comment: ""),
            NSLocalizedString("Play Chime", comment: ""),
            NSLocalizedString("Activate a Rule", comment: "")]
  }

  // MARK: LawnNGarden

  func isControllerStateOff() -> Bool {
    return IrrigationControllerCapability
      .getControllerState(from: self) == kEnumIrrigationControllerControllerStateOFF
  }
}
