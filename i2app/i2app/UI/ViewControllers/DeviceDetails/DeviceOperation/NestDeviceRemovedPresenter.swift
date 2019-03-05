//
//  NestDeviceRemovedPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/4/17.
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

import PromiseKit

protocol NestDeviceRemovedPresenterProtocol {
  /**
   Product object with next details. Empty if no product catalog exists
   */
  var product: DeviceProductCatalog? { get }
  
  /**
   Retrieves the product object for the nest thermostat
   */
  func fetchNestThermostatProduct()
}

protocol NestDeviceRemovedPresenterDelegate: class {
  
}

class NestDeviceRemovedPresenter: NestDeviceRemovedPresenterProtocol {
  
  // MARK: Properties
  
  weak var delegate: NestDeviceRemovedPresenterDelegate?
  private(set) var product: DeviceProductCatalog?
  
  // MARK: Functions
  
  init(delegate: NestDeviceRemovedPresenterDelegate) {
    self.delegate = delegate
  }
  
  func fetchNestThermostatProduct() {
    DispatchQueue.global(qos: .background).async {
      _ = ProductCatalogController.getProductsByBrand(withBrand: "Nest").swiftThenInBackground {
        (products) -> (PMKPromise?) in
        if let products = products as? NSArray {
          if products.count > 0 {
            if let product = products[0] as? DeviceProductCatalog {
              self.product = product
            }
          }
        }
        
        return nil
      }
    }
  }
}
