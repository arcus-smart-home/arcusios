
//
// ProductCatalogService.swift
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
  public static let productCatalogServiceNamespace: String = "prodcat"
  public static let productCatalogServiceName: String = "ProductCatalogService"
  public static let productCatalogServiceAddress: String = "SERV:prodcat:"
}

/** Service methods for retrieving the product catalog. */
public protocol ArcusProductCatalogService: RxArcusService {
  /** Returns information about the product catalog for the context population. */
  func requestProductCatalogServiceGetProductCatalog(_ place: String) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
  func requestProductCatalogServiceGetCategories(_ place: String) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
  func requestProductCatalogServiceGetBrands(_ place: String) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogServiceGetProductsByBrand(_ place: String, brand: String, hubrequired: Bool?) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogServiceGetProductsByCategory(_ place: String, category: String) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogServiceGetProducts(_ place: String, include: String, hubRequired: Bool?) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogServiceFindProducts(_ place: String, search: String) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogServiceGetProduct(_ place: String, id: String) throws -> Observable<ArcusSessionEvent>
}

extension ArcusProductCatalogService {
  public func requestProductCatalogServiceGetProductCatalog(_ place: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetProductCatalogRequest = ProductCatalogServiceGetProductCatalogRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetCategories(_ place: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetCategoriesRequest = ProductCatalogServiceGetCategoriesRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetBrands(_ place: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetBrandsRequest = ProductCatalogServiceGetBrandsRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetProductsByBrand(_ place: String, brand: String, hubrequired: Bool?) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetProductsByBrandRequest = ProductCatalogServiceGetProductsByBrandRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)
    request.setBrand(brand)
    
    if let requiredFlag = hubrequired {
      request.setHubrequired(requiredFlag)
    }

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetProductsByCategory(_ place: String, category: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetProductsByCategoryRequest = ProductCatalogServiceGetProductsByCategoryRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)
    request.setCategory(category)

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetProducts(_ place: String, include: String, hubRequired: Bool?) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetProductsRequest = ProductCatalogServiceGetProductsRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)
    request.setInclude(include)
    
    if let requiredFlag = hubRequired {
      request.setHubRequired(requiredFlag)
    }

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceFindProducts(_ place: String, search: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceFindProductsRequest = ProductCatalogServiceFindProductsRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)
    request.setSearch(search)

    return try sendRequest(request)
  }
  public func requestProductCatalogServiceGetProduct(_ place: String, id: String) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogServiceGetProductRequest = ProductCatalogServiceGetProductRequest()
    request.source = Constants.productCatalogServiceAddress
    request.isRequest = true
    
    request.setPlace(place)
    request.setId(id)

    return try sendRequest(request)
  }
  
}
