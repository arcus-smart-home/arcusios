
//
// ProductCatalogServiceEvents.swift
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
// MARK: Commands
fileprivate struct Commands {
  /** Returns information about the product catalog for the context population. */
  public static let productCatalogServiceGetProductCatalog: String = "prodcat:GetProductCatalog"
  /** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
  public static let productCatalogServiceGetCategories: String = "prodcat:GetCategories"
  /** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
  public static let productCatalogServiceGetBrands: String = "prodcat:GetBrands"
  /**  */
  public static let productCatalogServiceGetProductsByBrand: String = "prodcat:GetProductsByBrand"
  /**  */
  public static let productCatalogServiceGetProductsByCategory: String = "prodcat:GetProductsByCategory"
  /**  */
  public static let productCatalogServiceGetProducts: String = "prodcat:GetProducts"
  /**  */
  public static let productCatalogServiceFindProducts: String = "prodcat:FindProducts"
  /**  */
  public static let productCatalogServiceGetProduct: String = "prodcat:GetProduct"
  
}

// MARK: Requests

/** Returns information about the product catalog for the context population. */
public class ProductCatalogServiceGetProductCatalogRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetProductCatalogRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetProductCatalog
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetProductCatalogResponse(message)
  }
  // MARK: GetProductCatalogRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the product catalog */
    static let place: String = "place"
 }
  
  /** The place whose population should be used for getting the product catalog */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
}

public class ProductCatalogServiceGetProductCatalogResponse: SessionEvent {
  
  
  /** The product catalog */
  public func getCatalog() -> Any? {
    return self.attributes["catalog"]
  }
}

/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
public class ProductCatalogServiceGetCategoriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetCategoriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetCategories
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetCategoriesResponse(message)
  }
  // MARK: GetCategoriesRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the categories */
    static let place: String = "place"
 }
  
  /** The place whose population should be used for getting the categories */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
}

public class ProductCatalogServiceGetCategoriesResponse: SessionEvent {
  
  
  /**  */
  public func getCategories() -> [Any]? {
    return self.attributes["categories"] as? [Any]
  }
  /** The counts of products by category name */
  public func getCounts() -> [String: Int]? {
    return self.attributes["counts"] as? [String: Int]
  }
}

/** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
public class ProductCatalogServiceGetBrandsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetBrandsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetBrands
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetBrandsResponse(message)
  }
  // MARK: GetBrandsRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the brands */
    static let place: String = "place"
 }
  
  /** The place whose population should be used for getting the brands */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
}

public class ProductCatalogServiceGetBrandsResponse: SessionEvent {
  
  
  /**  */
  public func getBrands() -> [Any]? {
    return self.attributes["brands"] as? [Any]
  }
  /** The counts of products by brand name */
  public func getCounts() -> [String: Int]? {
    return self.attributes["counts"] as? [String: Int]
  }
}

/**  */
public class ProductCatalogServiceGetProductsByBrandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetProductsByBrandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetProductsByBrand
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetProductsByBrandResponse(message)
  }
  // MARK: GetProductsByBrandRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the products */
    static let place: String = "place"
/**  */
    static let brand: String = "brand"
/** Value of hubrequired to further filter list by */
    static let hubrequired: String = "hubrequired"
 }
  
  /** The place whose population should be used for getting the products */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /**  */
  public func setBrand(_ brand: String) {
    attributes[Attributes.brand] = brand as AnyObject
  }

  
  /** Value of hubrequired to further filter list by */
  public func setHubrequired(_ hubrequired: Bool) {
    attributes[Attributes.hubrequired] = hubrequired as AnyObject
  }

  
}

public class ProductCatalogServiceGetProductsByBrandResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogServiceGetProductsByCategoryRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetProductsByCategoryRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetProductsByCategory
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetProductsByCategoryResponse(message)
  }
  // MARK: GetProductsByCategoryRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the products */
    static let place: String = "place"
/**  */
    static let category: String = "category"
 }
  
  /** The place whose population should be used for getting the products */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /**  */
  public func setCategory(_ category: String) {
    attributes[Attributes.category] = category as AnyObject
  }

  
}

public class ProductCatalogServiceGetProductsByCategoryResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogServiceGetProductsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetProductsRequest Enumerations
  /** Type of product catalog entries to include, defaults to BROWSEABLE. */
  public enum ProductCatalogServiceInclude: String {
   case all = "ALL"
   case browseable = "BROWSEABLE"
   
  }
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetProducts
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetProductsResponse(message)
  }
  // MARK: GetProductsRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the products */
    static let place: String = "place"
/** Type of product catalog entries to include, defaults to BROWSEABLE. */
    static let include: String = "include"
/** Value of hubrequired to further filter list by */
    static let hubRequired: String = "hubRequired"
 }
  
  /** The place whose population should be used for getting the products */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** Type of product catalog entries to include, defaults to BROWSEABLE. */
  public func setInclude(_ include: String) {
    if let value = ProductCatalogServiceInclude(rawValue: include) {
      attributes[Attributes.include] = value.rawValue as AnyObject
    }
  }
  
  /** Value of hubrequired to further filter list by */
  public func setHubRequired(_ hubRequired: Bool) {
    attributes[Attributes.hubRequired] = hubRequired as AnyObject
  }

  
}

public class ProductCatalogServiceGetProductsResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogServiceFindProductsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceFindProductsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceFindProducts
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceFindProductsResponse(message)
  }
  // MARK: FindProductsRequest Attributes
  struct Attributes {
    /** The place whose population should be used for finding the products */
    static let place: String = "place"
/**  */
    static let search: String = "search"
 }
  
  /** The place whose population should be used for finding the products */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /**  */
  public func setSearch(_ search: String) {
    attributes[Attributes.search] = search as AnyObject
  }

  
}

public class ProductCatalogServiceFindProductsResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogServiceGetProductRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogServiceGetProductRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogServiceGetProduct
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return ProductCatalogServiceGetProductResponse(message)
  }
  // MARK: GetProductRequest Attributes
  struct Attributes {
    /** The place whose population should be used for getting the product */
    static let place: String = "place"
/**  */
    static let id: String = "id"
 }
  
  /** The place whose population should be used for getting the product */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /**  */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
}

public class ProductCatalogServiceGetProductResponse: SessionEvent {
  
  
  /**  */
  public func getProduct() -> Any? {
    return self.attributes["product"]
  }
}

