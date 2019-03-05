//
//  CatalogDeviceListPresenter.swift
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
import RxSwift
import SDWebImage



/**
 Interface for presenters to be used for the Catalog Device List.
 */
protocol CatalogDeviceListPresenterProtocol {

  var brandName: String { get }

  init(brandName: String, cache: CatalogDeviceListCache)

  func deviceList(forFilter: ProductCatalogFilterOptions) -> [CatalogDeviceViewModel]?

}

///Presenter that provides the data needed for a Catalog Device List.
class CatalogDeviceListPresenter: CatalogDeviceListPresenterProtocol {

  weak var cache: CatalogDeviceListCache?

  /// Brand Name of the filtered product list
  fileprivate(set) var brandName: String


  /// Required by CatalogDeviceListPresenterProtocol
  required init(brandName: String,
                cache: CatalogDeviceListCache) {
    self.brandName = brandName
    self.cache = cache
  }

  func deviceList(forFilter: ProductCatalogFilterOptions) -> [CatalogDeviceViewModel]? {
    let brandList = cache?.viewModel.list(filter: forFilter)
    return brandList?.filter({return $0.name == brandName}).first?.productList
  }

}
