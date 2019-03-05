
//
// ProductCatalogCapEvents.swift
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
  static let productCatalogGetProductCatalog: String = "prodcat:GetProductCatalog"
  /** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
  static let productCatalogGetCategories: String = "prodcat:GetCategories"
  /** Returns a list of all the brands referenced in this catalog where each is a structure containing (name, image, description).  In addition the counts of products by brand name are returned. */
  static let productCatalogGetBrands: String = "prodcat:GetBrands"
  /**  */
  static let productCatalogGetProductsByBrand: String = "prodcat:GetProductsByBrand"
  /**  */
  static let productCatalogGetProductsByCategory: String = "prodcat:GetProductsByCategory"
  /**  */
  static let productCatalogGetProducts: String = "prodcat:GetProducts"
  /** Gets all products including those that are not browseable. */
  static let productCatalogGetAllProducts: String = "prodcat:GetAllProducts"
  /**  */
  static let productCatalogFindProducts: String = "prodcat:FindProducts"
  /**  */
  static let productCatalogGetProduct: String = "prodcat:GetProduct"
  
}

// MARK: Enumerations

// MARK: Requests

/** Returns information about the product catalog for the context population. */
public class ProductCatalogGetProductCatalogRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetProductCatalog
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
    return ProductCatalogGetProductCatalogResponse(message)
  }

  
}

public class ProductCatalogGetProductCatalogResponse: SessionEvent {
  
  
  /**  */
  public func getCatalog() -> Any? {
    return self.attributes["catalog"]
  }
}

/** Returns a list of all the categories as a structure (name, image) referenced in this catalog as well as counts by category.  Nested catagories will be returned as fully qualified forward-slash delimited paths */
public class ProductCatalogGetCategoriesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetCategories
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
    return ProductCatalogGetCategoriesResponse(message)
  }

  
}

public class ProductCatalogGetCategoriesResponse: SessionEvent {
  
  
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
public class ProductCatalogGetBrandsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetBrands
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
    return ProductCatalogGetBrandsResponse(message)
  }

  
}

public class ProductCatalogGetBrandsResponse: SessionEvent {
  
  
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
public class ProductCatalogGetProductsByBrandRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogGetProductsByBrandRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetProductsByBrand
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
    return ProductCatalogGetProductsByBrandResponse(message)
  }

  // MARK: GetProductsByBrandRequest Attributes
  struct Attributes {
    /**  */
    static let brand: String = "brand"
 }
  
  /**  */
  public func setBrand(_ brand: String) {
    attributes[Attributes.brand] = brand as AnyObject
  }

  
}

public class ProductCatalogGetProductsByBrandResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogGetProductsByCategoryRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogGetProductsByCategoryRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetProductsByCategory
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
    return ProductCatalogGetProductsByCategoryResponse(message)
  }

  // MARK: GetProductsByCategoryRequest Attributes
  struct Attributes {
    /**  */
    static let category: String = "category"
 }
  
  /**  */
  public func setCategory(_ category: String) {
    attributes[Attributes.category] = category as AnyObject
  }

  
}

public class ProductCatalogGetProductsByCategoryResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogGetProductsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetProducts
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
    return ProductCatalogGetProductsResponse(message)
  }

  
}

public class ProductCatalogGetProductsResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/** Gets all products including those that are not browseable. */
public class ProductCatalogGetAllProductsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetAllProducts
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
    return ProductCatalogGetAllProductsResponse(message)
  }

  
}

public class ProductCatalogGetAllProductsResponse: SessionEvent {
  
  
  /** All products in the catalog. */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogFindProductsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogFindProductsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogFindProducts
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
    return ProductCatalogFindProductsResponse(message)
  }

  // MARK: FindProductsRequest Attributes
  struct Attributes {
    /**  */
    static let search: String = "search"
 }
  
  /**  */
  public func setSearch(_ search: String) {
    attributes[Attributes.search] = search as AnyObject
  }

  
}

public class ProductCatalogFindProductsResponse: SessionEvent {
  
  
  /**  */
  public func getProducts() -> [Any]? {
    return self.attributes["products"] as? [Any]
  }
}

/**  */
public class ProductCatalogGetProductRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: ProductCatalogGetProductRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.productCatalogGetProduct
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
    return ProductCatalogGetProductResponse(message)
  }

  // MARK: GetProductRequest Attributes
  struct Attributes {
    /**  */
    static let id: String = "id"
 }
  
  /**  */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
}

public class ProductCatalogGetProductResponse: SessionEvent {
  
  
  /**  */
  public func getProduct() -> Any? {
    return self.attributes["product"]
  }
}

