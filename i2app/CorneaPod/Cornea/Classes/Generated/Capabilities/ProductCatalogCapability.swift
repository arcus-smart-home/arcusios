
//
// ProductCatalogCap.swift
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
  public static var productCatalogNamespace: String = "prodcat"
  public static var productCatalogName: String = "ProductCatalog"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let productCatalogFilenameVersion: String = "prodcat:filenameVersion"
  static let productCatalogBrandCount: String = "prodcat:brandCount"
  static let productCatalogCategoryCount: String = "prodcat:categoryCount"
  static let productCatalogProductCount: String = "prodcat:productCount"
  static let productCatalogPublisher: String = "prodcat:publisher"
  static let productCatalogVersion: String = "prodcat:version"
  
}

public protocol ArcusProductCatalogCapability: class, RxArcusService {
  /** Product catalog filename version */
  func getProductCatalogFilenameVersion(_ model: ProductCatalogModel) -> Int?
  /** Number of brand names in catalog */
  func getProductCatalogBrandCount(_ model: ProductCatalogModel) -> Int?
  /** Number of categories in catalog */
  func getProductCatalogCategoryCount(_ model: ProductCatalogModel) -> Int?
  /** Number of products in this catalog */
  func getProductCatalogProductCount(_ model: ProductCatalogModel) -> Int?
  /** Deprecated - publisher is used or updated */
  func getProductCatalogPublisher(_ model: ProductCatalogModel) -> String?
  /** Deprecated - Version is now pulled from the filename */
  func getProductCatalogVersion(_ model: ProductCatalogModel) -> Date?
  
  /** Returns information about the product catalog for the context population. */
  func requestProductCatalogGetProductCatalog(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
  func requestProductCatalogGetCategories(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
  func requestProductCatalogGetBrands(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogGetProductsByBrand(_  model: ProductCatalogModel, brand: String)
   throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogGetProductsByCategory(_  model: ProductCatalogModel, category: String)
   throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogGetProducts(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent>/** Gets all products including those that are not browseable. */
  func requestProductCatalogGetAllProducts(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogFindProducts(_  model: ProductCatalogModel, search: String)
   throws -> Observable<ArcusSessionEvent>/**  */
  func requestProductCatalogGetProduct(_  model: ProductCatalogModel, id: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusProductCatalogCapability {
  public func getProductCatalogFilenameVersion(_ model: ProductCatalogModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCatalogFilenameVersion] as? Int
  }
  
  public func getProductCatalogBrandCount(_ model: ProductCatalogModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCatalogBrandCount] as? Int
  }
  
  public func getProductCatalogCategoryCount(_ model: ProductCatalogModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCatalogCategoryCount] as? Int
  }
  
  public func getProductCatalogProductCount(_ model: ProductCatalogModel) -> Int? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCatalogProductCount] as? Int
  }
  
  public func getProductCatalogPublisher(_ model: ProductCatalogModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.productCatalogPublisher] as? String
  }
  
  public func getProductCatalogVersion(_ model: ProductCatalogModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.productCatalogVersion] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestProductCatalogGetProductCatalog(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetProductCatalogRequest = ProductCatalogGetProductCatalogRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetCategories(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetCategoriesRequest = ProductCatalogGetCategoriesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetBrands(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetBrandsRequest = ProductCatalogGetBrandsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetProductsByBrand(_  model: ProductCatalogModel, brand: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetProductsByBrandRequest = ProductCatalogGetProductsByBrandRequest()
    request.source = model.address
    
    
    
    request.setBrand(brand)
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetProductsByCategory(_  model: ProductCatalogModel, category: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetProductsByCategoryRequest = ProductCatalogGetProductsByCategoryRequest()
    request.source = model.address
    
    
    
    request.setCategory(category)
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetProducts(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetProductsRequest = ProductCatalogGetProductsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetAllProducts(_ model: ProductCatalogModel) throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetAllProductsRequest = ProductCatalogGetAllProductsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogFindProducts(_  model: ProductCatalogModel, search: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogFindProductsRequest = ProductCatalogFindProductsRequest()
    request.source = model.address
    
    
    
    request.setSearch(search)
    
    return try sendRequest(request)
  }
  
  public func requestProductCatalogGetProduct(_  model: ProductCatalogModel, id: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: ProductCatalogGetProductRequest = ProductCatalogGetProductRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    return try sendRequest(request)
  }
  
}
