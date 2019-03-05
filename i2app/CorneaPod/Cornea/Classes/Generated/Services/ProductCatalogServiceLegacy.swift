
//
// ProductCatalogServiceLegacy.swift
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

public class ProductCatalogServiceLegacy: NSObject, ArcusProductCatalogService, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let service: ProductCatalogServiceLegacy = ProductCatalogServiceLegacy()
  
  
  public static func getProductCatalog(_ place: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProductCatalog(place))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getCategories(_ place: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetCategories(place))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getBrands(_ place: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetBrands(place))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProductsByBrand(_ place: String, brand: String, hubrequired: Bool) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProductsByBrand(place, brand: brand, hubrequired: hubrequired))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProductsByBrand(_ place: String, brand: String) -> PMKPromise {
    
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProductsByBrand(place, brand: brand, hubrequired: nil))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProductsByCategory(_ place: String, category: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProductsByCategory(place, category: category))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProducts(_ place: String, include: String, hubRequired: Bool) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProducts(place, include: include, hubRequired: hubRequired))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProducts(_ place: String, include: String) -> PMKPromise {
    
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProducts(place, include: include, hubRequired: nil))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func findProducts(_ place: String, search: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceFindProducts(place, search: search))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getProduct(_ place: String, id: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestProductCatalogServiceGetProduct(place, id: id))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
