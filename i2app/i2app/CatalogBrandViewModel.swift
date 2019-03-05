//
//  CatalogBrandViewModel.swift
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

fileprivate struct ImageURLHelper: StaticResourceImageURLHelper { }
fileprivate let imageURLHelper = ImageURLHelper()

/**
 Object representing the data needed for a catalog brand.
 */
struct CatalogBrandViewModel {

  /**
   Name of the brand.
   */
  var name = ""


  /// Location of the Brands image on the SRS
  var imageURL: URL {
    return imageURLHelper.getSmallBrandImage(name)
  }
  
  /**
   Count of devices available in the brand.
   */
  var deviceCountTotal: Int {
    return productList.count
  }

  var productList: [CatalogDeviceViewModel] = []
}

extension CatalogBrandViewModel: Hashable {
  public var hashValue: Int {
    return name.hashValue
  }

  public static func == (lhs: CatalogBrandViewModel, rhs: CatalogBrandViewModel) -> Bool {
    return lhs.name == rhs.name
  }
}

extension CatalogBrandViewModel: ArcusStringSortable {
  var sortableName: String {
    return name
  }
}
