
//
// ProductCatalogCapabilityLegacy.swift
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
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class ProductCatalogCapabilityLegacy: NSObject, ArcusProductCatalogCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: ProductCatalogCapabilityLegacy  = ProductCatalogCapabilityLegacy()
  

  
  public static func getFilenameVersion(_ model: ProductCatalogModel) -> NSNumber? {
    guard let filenameVersion: Int = capability.getProductCatalogFilenameVersion(model) else {
      return nil
    }
    return NSNumber(value: filenameVersion)
  }
  
  public static func getBrandCount(_ model: ProductCatalogModel) -> NSNumber? {
    guard let brandCount: Int = capability.getProductCatalogBrandCount(model) else {
      return nil
    }
    return NSNumber(value: brandCount)
  }
  
  public static func getCategoryCount(_ model: ProductCatalogModel) -> NSNumber? {
    guard let categoryCount: Int = capability.getProductCatalogCategoryCount(model) else {
      return nil
    }
    return NSNumber(value: categoryCount)
  }
  
  public static func getProductCount(_ model: ProductCatalogModel) -> NSNumber? {
    guard let productCount: Int = capability.getProductCatalogProductCount(model) else {
      return nil
    }
    return NSNumber(value: productCount)
  }
  
  public static func getPublisher(_ model: ProductCatalogModel) -> String? {
    return capability.getProductCatalogPublisher(model)
  }
  
  public static func getVersion(_ model: ProductCatalogModel) -> Date? {
    guard let version: Date = capability.getProductCatalogVersion(model) else {
      return nil
    }
    return version
  }
  
  public static func getProductCatalog(_ model: ProductCatalogModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProductCatalogGetProductCatalog(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getCategories(_ model: ProductCatalogModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProductCatalogGetCategories(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getBrands(_ model: ProductCatalogModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProductCatalogGetBrands(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProductsByBrand(_  model: ProductCatalogModel, brand: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProductCatalogGetProductsByBrand(model, brand: brand))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProductsByCategory(_  model: ProductCatalogModel, category: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProductCatalogGetProductsByCategory(model, category: category))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProducts(_ model: ProductCatalogModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProductCatalogGetProducts(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getAllProducts(_ model: ProductCatalogModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestProductCatalogGetAllProducts(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func findProducts(_  model: ProductCatalogModel, search: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProductCatalogFindProducts(model, search: search))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProduct(_  model: ProductCatalogModel, id: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestProductCatalogGetProduct(model, id: id))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
