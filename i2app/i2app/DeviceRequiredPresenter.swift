//
//  DeviceRequiredPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/21/18.
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

/// A Simple Tuple View Model
typealias DeviceRequiredTexts = (title: String?, subtitle: String?)

/// Presenter to fetch the product required Text
protocol DeviceRequiredPresenter {

  /// Get the Device Required Title and Subtitle
  /// - Extended
  ///
  /// - Parameters:
  ///   - forProductID: String
  ///   - withModelCache: has a default value of `RxCornea.shared.modelCache`
  /// - Returns: DeviceRequiredTexts a title, subtitle tuple
  func title(forProductID: String, withModelCache: ArcusModelCache?) -> DeviceRequiredTexts

}

extension DeviceRequiredPresenter {

  func title(forProductID: String,
             withModelCache modelCache: ArcusModelCache? = RxCornea.shared.modelCache)
    -> DeviceRequiredTexts {

      guard let modelCache = modelCache else {
        return (nil, nil)
      }
      if let products = modelCache.fetchModels(Constants.productNamespace) {
        for model in products {
          if let product = model as? ProductModel,
            product.productId() == forProductID,
            let vendorName = product.vendorName(),
            let productName = product.productName() {
            return ("\(vendorName) \(productName) Required",
              "A \(vendorName) \(productName) must be paired before pairing this device.")
          }
        }
      }
      return (nil, nil)
  }
}
