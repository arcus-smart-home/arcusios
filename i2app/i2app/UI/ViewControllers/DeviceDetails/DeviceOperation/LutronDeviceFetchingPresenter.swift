//
//  LutronDeviceRemovedPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/27/17.
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
import PromiseKit

protocol LutronDeviceFetchingPresenterProtocol {

  /**
   initalizer with a delegate
   - productCatalogController default is ProductCatalogController.self (yes that is a static class type)
   */
  init(delegate: LutronDeviceFetchingPresenterDelegate,
       productCatalogController: ProductCatalogControllerDeviceRemovedable.Type)
  /**
   Product object with next details. Empty if no product catalog exists
   */
  var product: DeviceProductCatalog? { get }

  /**
   Retrieves the product object for the Lutron Device
   */
  func fetch()
}

protocol LutronDeviceFetchingPresenterDelegate: class {
  func fetchDidComplete()
}

/// Protocol for a Legacy Dependency, ProductCatalogController
protocol ProductCatalogControllerDeviceRemovedable: class {
  /// - seealso: ProductCatalogController
  static func getProductsByBrand(withBrand brand: String!) -> PMKPromise!
}

/// ProductCatalogController conforms to ProductCatalogControllerDeviceRemovedable
extension ProductCatalogController: ProductCatalogControllerDeviceRemovedable {}

class LutronDeviceFetchingPresenter: LutronDeviceFetchingPresenterProtocol {

  // MARK: Properties

  weak var delegate: LutronDeviceFetchingPresenterDelegate?
  private(set) var product: DeviceProductCatalog?
  var productCatalogController: ProductCatalogControllerDeviceRemovedable.Type

  // MARK: Functions

  required init(delegate: LutronDeviceFetchingPresenterDelegate,
       productCatalogController: ProductCatalogControllerDeviceRemovedable.Type = ProductCatalogController.self) {
    self.delegate = delegate
    self.productCatalogController = productCatalogController
  }

  func fetch() {
    DispatchQueue.global(qos: .background).async {
      _ = self.productCatalogController.getProductsByBrand(withBrand: "Lutron")
        .swiftThenInBackground { (products) -> (PMKPromise?) in
          if let products = products as? NSArray,
            products.count > 0,
            let product = products[0] as? DeviceProductCatalog {
            self.product = product
          }
          self.delegate?.fetchDidComplete()
          return nil
      }
    }
  }
}
