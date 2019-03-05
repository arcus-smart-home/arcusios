
//
// ProductCap.swift
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
  public static var productNamespace: String = "product"
  public static var productName: String = "Product"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let productId: String = "product:id"
  static let productName: String = "product:name"
  static let productShortName: String = "product:shortName"
  static let productDescription: String = "product:description"
  static let productManufacturer: String = "product:manufacturer"
  static let productVendor: String = "product:vendor"
  static let productAddDevImg: String = "product:addDevImg"
  static let productCert: String = "product:cert"
  static let productCanBrowse: String = "product:canBrowse"
  static let productCanSearch: String = "product:canSearch"
  static let productArcusProductId: String = "product:arcusProductId"
  static let productArcusVendorId: String = "product:arcusVendorId"
  static let productArcusModelId: String = "product:arcusModelId"
  static let productArcusComUrl: String = "product:arcusComUrl"
  static let productHelpUrl: String = "product:helpUrl"
  static let productPairVideoUrl: String = "product:pairVideoUrl"
  static let productBatteryPrimSize: String = "product:batteryPrimSize"
  static let productBatteryPrimNum: String = "product:batteryPrimNum"
  static let productBatteryBackSize: String = "product:batteryBackSize"
  static let productBatteryBackNum: String = "product:batteryBackNum"
  static let productKeywords: String = "product:keywords"
  static let productOTA: String = "product:OTA"
  static let productProtoFamily: String = "product:protoFamily"
  static let productProtoSpec: String = "product:protoSpec"
  static let productDriver: String = "product:driver"
  static let productAdded: String = "product:added"
  static let productLastChanged: String = "product:lastChanged"
  static let productCategories: String = "product:categories"
  static let productPair: String = "product:pair"
  static let productRemoval: String = "product:removal"
  static let productReset: String = "product:reset"
  static let productPopulations: String = "product:populations"
  static let productScreen: String = "product:screen"
  static let productBlacklisted: String = "product:blacklisted"
  static let productHubRequired: String = "product:hubRequired"
  static let productMinAppVersion: String = "product:minAppVersion"
  static let productMinHubFirmware: String = "product:minHubFirmware"
  static let productDevRequired: String = "product:devRequired"
  static let productCanDiscover: String = "product:canDiscover"
  static let productAppRequired: String = "product:appRequired"
  static let productInstallManualUrl: String = "product:installManualUrl"
  static let productPairingMode: String = "product:pairingMode"
  static let productPairingIdleTimeoutMs: String = "product:pairingIdleTimeoutMs"
  
}

public protocol ArcusProductCapability: class, RxArcusService {
  /** Product Id */
  func getProductId(_ model: ProductModel) -> String?
  /** Product Name */
  func getProductName(_ model: ProductModel) -> String?
  /** Product short name */
  func getProductShortName(_ model: ProductModel) -> String?
  /** Product Description */
  func getProductDescription(_ model: ProductModel) -> String?
  /** Product Manufacturer */
  func getProductManufacturer(_ model: ProductModel) -> String?
  /** Product Vendor */
  func getProductVendor(_ model: ProductModel) -> String?
  /** Product Device Image */
  func getProductAddDevImg(_ model: ProductModel) -> String?
  /** Product Arcus Certification */
  func getProductCert(_ model: ProductModel) -> ProductCert?
  /** Product appears in browse */
  func getProductCanBrowse(_ model: ProductModel) -> Bool?
  /** Product appears in search */
  func getProductCanSearch(_ model: ProductModel) -> Bool?
  /** Lowe&#x27;s Product Id */
  func getProductArcusProductId(_ model: ProductModel) -> String?
  /**  */
  func getProductArcusVendorId(_ model: ProductModel) -> String?
  /** Lowe&#x27;s Model Id */
  func getProductArcusModelId(_ model: ProductModel) -> String?
  /** */
  func getProductArcusComUrl(_ model: ProductModel) -> String?
  /** Help url */
  func getProductHelpUrl(_ model: ProductModel) -> String?
  /** Video url */
  func getProductPairVideoUrl(_ model: ProductModel) -> String?
  /** Primary battery size */
  func getProductBatteryPrimSize(_ model: ProductModel) -> ProductBatteryPrimSize?
  /** Primary battery number */
  func getProductBatteryPrimNum(_ model: ProductModel) -> Int?
  /** Backup battery size */
  func getProductBatteryBackSize(_ model: ProductModel) -> ProductBatteryBackSize?
  /** Backup battery number */
  func getProductBatteryBackNum(_ model: ProductModel) -> Int?
  /** Product Keywords */
  func getProductKeywords(_ model: ProductModel) -> String?
  /**  */
  func getProductOTA(_ model: ProductModel) -> Bool?
  /** Protocol Family */
  func getProductProtoFamily(_ model: ProductModel) -> String?
  /** Protocol Specification */
  func getProductProtoSpec(_ model: ProductModel) -> String?
  /** Driver Name */
  func getProductDriver(_ model: ProductModel) -> String?
  /** Product added timestamp */
  func getProductAdded(_ model: ProductModel) -> Date?
  /** Product last changed timestamp */
  func getProductLastChanged(_ model: ProductModel) -> Date?
  /** Product categories */
  func getProductCategories(_ model: ProductModel) -> [String]?
  /** Pairing Steps */
  func getProductPair(_ model: ProductModel) -> [Any]?
  /** Remove Steps */
  func getProductRemoval(_ model: ProductModel) -> [Any]?
  /** Reset Steps */
  func getProductReset(_ model: ProductModel) -> [Any]?
  /** Populations specified for this product */
  func getProductPopulations(_ model: ProductModel) -> [String]?
  /** Detailed screen name for this product */
  func getProductScreen(_ model: ProductModel) -> String?
  /** Product is blacklisted */
  func getProductBlacklisted(_ model: ProductModel) -> Bool?
  /** Product requires a hub.  If not specified, defaults to true */
  func getProductHubRequired(_ model: ProductModel) -> Bool?
  /** Tag to indicate minimum app version supported by a given product */
  func getProductMinAppVersion(_ model: ProductModel) -> String?
  /** The minimum hub firmware version required to use this product */
  func getProductMinHubFirmware(_ model: ProductModel) -> String?
  /** Product catalog id of a parent device that must be paired before this can be paired */
  func getProductDevRequired(_ model: ProductModel) -> String?
  /** If product can be discovered in non-Arcus user experiences that are fed by the Arcus API, such as Alexa or Google Home.  Default is true. */
  func getProductCanDiscover(_ model: ProductModel) -> Bool?
  /** If product can only be pairable via the mobile application.  Default is false. */
  func getProductAppRequired(_ model: ProductModel) -> Bool?
  /** URL to manufacturer installation instructions. */
  func getProductInstallManualUrl(_ model: ProductModel) -> String?
  /** The pairing mode for the device.  If not specified it will be defaulted to HUB. EXTERNAL_APP:  Requires a different mobile application, for example for voice assistants. WIFI:  Requires the mobile app and typically custom soft AP pairing logic. HUB:  Requires the hub to be present for pairing. IPCD:  Requires manual entry of information to align an IP connected device with a place, typically the serial number. OAUTH:  Requires interaction with a third-party for cloud to cloud integration. BRIDGED_DEVICE:  Requires some bridge device to be paired first where the bridge device is specified in the devRequired attribute.  */
  func getProductPairingMode(_ model: ProductModel) -> ProductPairingMode?
  /** The custom value of pairing idle timeout in milliseconds. */
  func getProductPairingIdleTimeoutMs(_ model: ProductModel) -> Int?
  
  
}

extension ArcusProductCapability {
  public func getProductId(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productId] as? String
  }
  
  public func getProductName(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productName] as? String
  }
  
  public func getProductShortName(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productShortName] as? String
  }
  
  public func getProductDescription(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productDescription] as? String
  }
  
  public func getProductManufacturer(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productManufacturer] as? String
  }
  
  public func getProductVendor(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productVendor] as? String
  }
  
  public func getProductAddDevImg(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productAddDevImg] as? String
  }
  
  public func getProductCert(_ model: ProductModel) -> ProductCert? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.productCert] as? String,
      let enumAttr: ProductCert = ProductCert(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProductCanBrowse(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCanBrowse] as? Bool
  }
  
  public func getProductCanSearch(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCanSearch] as? Bool
  }
  
  public func getProductArcusProductId(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productArcusProductId] as? String
  }
  
  public func getProductArcusVendorId(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productArcusVendorId] as? String
  }
  
  public func getProductArcusModelId(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productArcusModelId] as? String
  }
  
  public func getProductArcusComUrl(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productArcusComUrl] as? String
  }
  
  public func getProductHelpUrl(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productHelpUrl] as? String
  }
  
  public func getProductPairVideoUrl(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productPairVideoUrl] as? String
  }
  
  public func getProductBatteryPrimSize(_ model: ProductModel) -> ProductBatteryPrimSize? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.productBatteryPrimSize] as? String,
      let enumAttr: ProductBatteryPrimSize = ProductBatteryPrimSize(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProductBatteryPrimNum(_ model: ProductModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productBatteryPrimNum] as? Int
  }
  
  public func getProductBatteryBackSize(_ model: ProductModel) -> ProductBatteryBackSize? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.productBatteryBackSize] as? String,
      let enumAttr: ProductBatteryBackSize = ProductBatteryBackSize(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProductBatteryBackNum(_ model: ProductModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productBatteryBackNum] as? Int
  }
  
  public func getProductKeywords(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productKeywords] as? String
  }
  
  public func getProductOTA(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productOTA] as? Bool
  }
  
  public func getProductProtoFamily(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productProtoFamily] as? String
  }
  
  public func getProductProtoSpec(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productProtoSpec] as? String
  }
  
  public func getProductDriver(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productDriver] as? String
  }
  
  public func getProductAdded(_ model: ProductModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.productAdded] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getProductLastChanged(_ model: ProductModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.productLastChanged] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getProductCategories(_ model: ProductModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCategories] as? [String]
  }
  
  public func getProductPair(_ model: ProductModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productPair] as? [Any]
  }
  
  public func getProductRemoval(_ model: ProductModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productRemoval] as? [Any]
  }
  
  public func getProductReset(_ model: ProductModel) -> [Any]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productReset] as? [Any]
  }
  
  public func getProductPopulations(_ model: ProductModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productPopulations] as? [String]
  }
  
  public func getProductScreen(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productScreen] as? String
  }
  
  public func getProductBlacklisted(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productBlacklisted] as? Bool
  }
  
  public func getProductHubRequired(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productHubRequired] as? Bool
  }
  
  public func getProductMinAppVersion(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productMinAppVersion] as? String
  }
  
  public func getProductMinHubFirmware(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productMinHubFirmware] as? String
  }
  
  public func getProductDevRequired(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productDevRequired] as? String
  }
  
  public func getProductCanDiscover(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCanDiscover] as? Bool
  }
  
  public func getProductAppRequired(_ model: ProductModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productAppRequired] as? Bool
  }
  
  public func getProductInstallManualUrl(_ model: ProductModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productInstallManualUrl] as? String
  }
  
  public func getProductPairingMode(_ model: ProductModel) -> ProductPairingMode? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.productPairingMode] as? String,
      let enumAttr: ProductPairingMode = ProductPairingMode(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getProductPairingIdleTimeoutMs(_ model: ProductModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productPairingIdleTimeoutMs] as? Int
  }
  
  
}
