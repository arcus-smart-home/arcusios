//
//  BrandSectionViewModel.swift
//  i2app
//
//  Created by Arcus Team on 9/6/18.
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
import SDWebImage

struct BrandSectionViewModel {

  var allBrands: [CatalogBrandViewModel]
  var hubRequiredBrands: [CatalogBrandViewModel]
  var noHubRequiredBrands: [CatalogBrandViewModel]

  func list(filter: ProductCatalogFilterOptions) -> [CatalogBrandViewModel] {
    switch filter {
    case .allProducts:
      return allBrands
    case .hubRequired:
      return hubRequiredBrands
    case .noHubRequired:
      return noHubRequiredBrands
    }
  }

  /// this initializer also sorts the Brands and their product list
  init(allBrands: [CatalogBrandViewModel],
       hubRequiredBrands: [CatalogBrandViewModel],
       noHubRequiredBrands: [CatalogBrandViewModel]){

    self.allBrands = allBrands
      .sorted(by: ArcusBrandSort)
      .reduce(into: [CatalogBrandViewModel]()) { (acc, vm) in
        var sorted = vm
        sorted.productList = vm.productList.sorted(by: ArcusProductSort)
        acc.append(sorted)
    }

    self.hubRequiredBrands = hubRequiredBrands
      .sorted(by: ArcusBrandSort)
      .reduce(into: [CatalogBrandViewModel]()) { (acc, vm) in
        var sorted = vm
        sorted.productList = vm.productList.sorted(by: ArcusProductSort)
        acc.append(sorted)
      }
      .filter({ return $0.productList.count > 0 })

    self.noHubRequiredBrands = noHubRequiredBrands
      .sorted(by: ArcusBrandSort)
      .reduce(into: [CatalogBrandViewModel]()) { (acc, vm) in
        var sorted = vm
        sorted.productList = vm.productList.sorted(by: ArcusProductSort)
        acc.append(sorted)
      }
      .filter({ return $0.productList.count > 0 })

    let allBrandURLs = self.allBrands.map { return $0.imageURL }
    SDWebImagePrefetcher.shared().prefetchURLs(allBrandURLs)
    self.allBrands.forEach { brand in
      let productURLs = brand.productList.map { return $0.imageURL }
      SDWebImagePrefetcher.shared().prefetchURLs(productURLs)
    }
  }
}
