//
//  CatalogDeviceViewModel.swift
//  i2app
//
//  Created by Arcus Team on 1/31/18.
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

fileprivate struct ImageURLHelper: StaticResourceImageURLHelper { }
fileprivate let imageURLHelper = ImageURLHelper()

/**
 Object representing the data needed by a device in the Catalog Device List.
 */
struct CatalogDeviceViewModel {
  
  /**
   Unique id of the device.
   */
  var identifier = ""
  
  /**
   The address of the product 
   */
  var address = ""
  
  /**
   Name of the device.
   */
  var name = ""

  /**
   Short name of the device.
   */
  var shortName = ""

  /**
   Vendor of the device.
   */
  var brand = ""
  
  /**
   Product screen that correlates to the device image.
   */
  var screen = ""
  
  /**
   Flag indicating that the device required a hub in order to work.
   */
  var hubRequired = true

  /**
   Product catalog id of a parent device that must be paired before this can be paired
   nil is it does not exist
   */
  var deviceRequired: String?

  /**
   What version of the client is required to pair this device
   */
  var minAppVersion: String?
  
  /**
   Image of the device. Depending on the device it can be generic.
   */
  /// Location of the Brands image on the SRS
  var imageURL: URL {
    return imageURLHelper.getProductImage(productId: identifier, isLarge: false)
  }

  var devTypeImageURL: URL {
    return imageURLHelper.getProductImage(fromDevTypeHint: screen, isLarge: false)
  }

  /// Default initalizer
  init(){ }

  /// Convience Init
  ///
  /// - Parameter product: ProductModel
  init(product: ProductModel) {
    self.hubRequired = product.hubRequired()

    if let deviceName = product.productName() {
      self.name = deviceName
    }
    if let shortName = product.productShortName() {
      self.shortName = shortName
    }
    if let deviceBrand = product.vendorName() {
      self.brand = deviceBrand
    }
    if let deviceScreen = product.screenName() {
      self.screen = deviceScreen
    }
    if let deviceIdentifier = product.getModelId() {
      self.identifier = deviceIdentifier
    }
    if let productAddress = product.getAddress() {
      self.address = productAddress
    }
    if let deviceRequired = product.devRequired() {
      self.deviceRequired = deviceRequired
    }
    if let minAppVersion = product.minAppVersion() {
      self.minAppVersion = minAppVersion
    }
  }
  
}

extension CatalogDeviceViewModel: ArcusStringSortable {
  var sortableName: String {
    return name
  }
}
