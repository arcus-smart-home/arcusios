
//
// ProductCapabilityLegacy.swift
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

public class ProductCapabilityLegacy: NSObject, ArcusProductCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ProductCapabilityLegacy  = ProductCapabilityLegacy()
  
  static let ProductCertCOMPATIBLE: String = ProductCert.compatible.rawValue
  static let ProductCertNONE: String = ProductCert.none.rawValue
  static let ProductCertWORKS: String = ProductCert.works.rawValue
  
  static let ProductBatteryPrimSize_9V: String = ProductBatteryPrimSize._9v.rawValue
  static let ProductBatteryPrimSizeAAAA: String = ProductBatteryPrimSize.aaaa.rawValue
  static let ProductBatteryPrimSizeAAA: String = ProductBatteryPrimSize.aaa.rawValue
  static let ProductBatteryPrimSizeAA: String = ProductBatteryPrimSize.aa.rawValue
  static let ProductBatteryPrimSizeC: String = ProductBatteryPrimSize.c.rawValue
  static let ProductBatteryPrimSizeD: String = ProductBatteryPrimSize.d.rawValue
  static let ProductBatteryPrimSizeCR123: String = ProductBatteryPrimSize.cr123.rawValue
  static let ProductBatteryPrimSizeCR2: String = ProductBatteryPrimSize.cr2.rawValue
  static let ProductBatteryPrimSizeCR2032: String = ProductBatteryPrimSize.cr2032.rawValue
  static let ProductBatteryPrimSizeCR2430: String = ProductBatteryPrimSize.cr2430.rawValue
  static let ProductBatteryPrimSizeCR2450: String = ProductBatteryPrimSize.cr2450.rawValue
  static let ProductBatteryPrimSizeCR14250: String = ProductBatteryPrimSize.cr14250.rawValue
  
  static let ProductBatteryBackSize_9V: String = ProductBatteryBackSize._9v.rawValue
  static let ProductBatteryBackSizeAAAA: String = ProductBatteryBackSize.aaaa.rawValue
  static let ProductBatteryBackSizeAAA: String = ProductBatteryBackSize.aaa.rawValue
  static let ProductBatteryBackSizeAA: String = ProductBatteryBackSize.aa.rawValue
  static let ProductBatteryBackSizeC: String = ProductBatteryBackSize.c.rawValue
  static let ProductBatteryBackSizeD: String = ProductBatteryBackSize.d.rawValue
  static let ProductBatteryBackSizeCR123: String = ProductBatteryBackSize.cr123.rawValue
  static let ProductBatteryBackSizeCR2: String = ProductBatteryBackSize.cr2.rawValue
  static let ProductBatteryBackSizeCR2032: String = ProductBatteryBackSize.cr2032.rawValue
  static let ProductBatteryBackSizeCR2430: String = ProductBatteryBackSize.cr2430.rawValue
  static let ProductBatteryBackSizeCR2450: String = ProductBatteryBackSize.cr2450.rawValue
  static let ProductBatteryBackSizeCR14250: String = ProductBatteryBackSize.cr14250.rawValue
  
  static let ProductPairingModeEXTERNAL_APP: String = ProductPairingMode.external_app.rawValue
  static let ProductPairingModeWIFI: String = ProductPairingMode.wifi.rawValue
  static let ProductPairingModeHUB: String = ProductPairingMode.hub.rawValue
  static let ProductPairingModeIPCD: String = ProductPairingMode.ipcd.rawValue
  static let ProductPairingModeOAUTH: String = ProductPairingMode.oauth.rawValue
  static let ProductPairingModeBRIDGED_DEVICE: String = ProductPairingMode.bridged_device.rawValue
  

  
  public static func getId(_ model: ProductModel) -> String? {
    return capability.getProductId(model)
  }
  
  public static func getName(_ model: ProductModel) -> String? {
    return capability.getProductName(model)
  }
  
  public static func getShortName(_ model: ProductModel) -> String? {
    return capability.getProductShortName(model)
  }
  
  public static func getDescription(_ model: ProductModel) -> String? {
    return capability.getProductDescription(model)
  }
  
  public static func getManufacturer(_ model: ProductModel) -> String? {
    return capability.getProductManufacturer(model)
  }
  
  public static func getVendor(_ model: ProductModel) -> String? {
    return capability.getProductVendor(model)
  }
  
  public static func getAddDevImg(_ model: ProductModel) -> String? {
    return capability.getProductAddDevImg(model)
  }
  
  public static func getCert(_ model: ProductModel) -> String? {
    return capability.getProductCert(model)?.rawValue
  }
  
  public static func getCanBrowse(_ model: ProductModel) -> NSNumber? {
    guard let canBrowse: Bool = capability.getProductCanBrowse(model) else {
      return nil
    }
    return NSNumber(value: canBrowse)
  }
  
  public static func getCanSearch(_ model: ProductModel) -> NSNumber? {
    guard let canSearch: Bool = capability.getProductCanSearch(model) else {
      return nil
    }
    return NSNumber(value: canSearch)
  }
  
  public static func getArcusProductId(_ model: ProductModel) -> String? {
    return capability.getProductArcusProductId(model)
  }
  
  public static func getArcusVendorId(_ model: ProductModel) -> String? {
    return capability.getProductArcusVendorId(model)
  }
  
  public static func getArcusModelId(_ model: ProductModel) -> String? {
    return capability.getProductArcusModelId(model)
  }
  
  public static func getArcusComUrl(_ model: ProductModel) -> String? {
    return capability.getProductArcusComUrl(model)
  }
  
  public static func getHelpUrl(_ model: ProductModel) -> String? {
    return capability.getProductHelpUrl(model)
  }
  
  public static func getPairVideoUrl(_ model: ProductModel) -> String? {
    return capability.getProductPairVideoUrl(model)
  }
  
  public static func getBatteryPrimSize(_ model: ProductModel) -> String? {
    return capability.getProductBatteryPrimSize(model)?.rawValue
  }
  
  public static func getBatteryPrimNum(_ model: ProductModel) -> NSNumber? {
    guard let batteryPrimNum: Int = capability.getProductBatteryPrimNum(model) else {
      return nil
    }
    return NSNumber(value: batteryPrimNum)
  }
  
  public static func getBatteryBackSize(_ model: ProductModel) -> String? {
    return capability.getProductBatteryBackSize(model)?.rawValue
  }
  
  public static func getBatteryBackNum(_ model: ProductModel) -> NSNumber? {
    guard let batteryBackNum: Int = capability.getProductBatteryBackNum(model) else {
      return nil
    }
    return NSNumber(value: batteryBackNum)
  }
  
  public static func getKeywords(_ model: ProductModel) -> String? {
    return capability.getProductKeywords(model)
  }
  
  public static func getOTA(_ model: ProductModel) -> NSNumber? {
    guard let OTA: Bool = capability.getProductOTA(model) else {
      return nil
    }
    return NSNumber(value: OTA)
  }
  
  public static func getProtoFamily(_ model: ProductModel) -> String? {
    return capability.getProductProtoFamily(model)
  }
  
  public static func getProtoSpec(_ model: ProductModel) -> String? {
    return capability.getProductProtoSpec(model)
  }
  
  public static func getDriver(_ model: ProductModel) -> String? {
    return capability.getProductDriver(model)
  }
  
  public static func getAdded(_ model: ProductModel) -> Date? {
    guard let added: Date = capability.getProductAdded(model) else {
      return nil
    }
    return added
  }
  
  public static func getLastChanged(_ model: ProductModel) -> Date? {
    guard let lastChanged: Date = capability.getProductLastChanged(model) else {
      return nil
    }
    return lastChanged
  }
  
  public static func getCategories(_ model: ProductModel) -> [String]? {
    return capability.getProductCategories(model)
  }
  
  public static func getPair(_ model: ProductModel) -> [Any]? {
    return capability.getProductPair(model)
  }
  
  public static func getRemoval(_ model: ProductModel) -> [Any]? {
    return capability.getProductRemoval(model)
  }
  
  public static func getReset(_ model: ProductModel) -> [Any]? {
    return capability.getProductReset(model)
  }
  
  public static func getPopulations(_ model: ProductModel) -> [String]? {
    return capability.getProductPopulations(model)
  }
  
  public static func getScreen(_ model: ProductModel) -> String? {
    return capability.getProductScreen(model)
  }
  
  public static func getBlacklisted(_ model: ProductModel) -> NSNumber? {
    guard let blacklisted: Bool = capability.getProductBlacklisted(model) else {
      return nil
    }
    return NSNumber(value: blacklisted)
  }
  
  public static func getHubRequired(_ model: ProductModel) -> NSNumber? {
    guard let hubRequired: Bool = capability.getProductHubRequired(model) else {
      return nil
    }
    return NSNumber(value: hubRequired)
  }
  
  public static func getMinAppVersion(_ model: ProductModel) -> String? {
    return capability.getProductMinAppVersion(model)
  }
  
  public static func getMinHubFirmware(_ model: ProductModel) -> String? {
    return capability.getProductMinHubFirmware(model)
  }
  
  public static func getDevRequired(_ model: ProductModel) -> String? {
    return capability.getProductDevRequired(model)
  }
  
  public static func getCanDiscover(_ model: ProductModel) -> NSNumber? {
    guard let canDiscover: Bool = capability.getProductCanDiscover(model) else {
      return nil
    }
    return NSNumber(value: canDiscover)
  }
  
  public static func getAppRequired(_ model: ProductModel) -> NSNumber? {
    guard let appRequired: Bool = capability.getProductAppRequired(model) else {
      return nil
    }
    return NSNumber(value: appRequired)
  }
  
  public static func getInstallManualUrl(_ model: ProductModel) -> String? {
    return capability.getProductInstallManualUrl(model)
  }
  
  public static func getPairingMode(_ model: ProductModel) -> String? {
    return capability.getProductPairingMode(model)?.rawValue
  }
  
  public static func getPairingIdleTimeoutMs(_ model: ProductModel) -> NSNumber? {
    guard let pairingIdleTimeoutMs: Int = capability.getProductPairingIdleTimeoutMs(model) else {
      return nil
    }
    return NSNumber(value: pairingIdleTimeoutMs)
  }
  
}
