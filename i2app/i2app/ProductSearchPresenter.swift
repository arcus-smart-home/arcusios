//
//  ProductSearchPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/13/18.
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

/// Protocol used to handle the business logic of search, links the view to the networking layer
protocol ProductSearchPresenterProtocol: class {

  /// delegate this presenter sends it's update message to
  var delegate: ProductSearchPresenterDelegate? { get set }

  /// Use the same ViewModels as the Device List View to have an easy way to
  /// Nil means no query to search, an empty list means No Results
  var viewModels: [CatalogDeviceViewModel]? { get }

  /// call to update results from the platform given a search string
  /// optionals allow for empty search or no search text given to reset the view
  /// - Parameter text: search text
  func updateSearchResults(for text: String?)
}

protocol ProductSearchPresenterDelegate: class {
  /// Update the whole
  func update()
}

/// Injectable ArcusProductCatalogService used as the default provider of networking observables
struct ArcusProductCatalogServiceProvider: ArcusProductCatalogService {
  var disposeBag: DisposeBag = DisposeBag()
}

/// Concrete Implementation of ProductSearchPresenterProtocol
class ProductSearchPresenter: ProductSearchPresenterProtocol {

  /// delegate must be set before this class is used
  /// - seealso: ProductSearchResultsViewController.create
  weak var delegate: ProductSearchPresenterDelegate?

  /// Set to self if not provided to use the extended implementation of the protocol
  fileprivate let service: ArcusProductCatalogService

  /// the address of the current user's place they are searching on used to make request
  let place: String

  /// Use the same ViewModels as the Device List View to have an easy way to
  /// Nil means no query to search, an empty list means No Results
  fileprivate(set) var viewModels: [CatalogDeviceViewModel]? = nil {
    didSet {
      delegate?.update()
    }
  }

  fileprivate var disposeBag = DisposeBag()

  /// String Observer used to debounce input from our delegate
  fileprivate var searchText = PublishSubject<String?>()

  /// Will return nil if a place is not passed or if the currentPlace has not been set in RxCornea
  init?(place: String? =  RxCornea.shared.settings?.currentPlace?.address,
        service: ArcusProductCatalogService? = nil) {
    if let place = place {
      self.place = place
    } else {
      return nil
    }

    if let service = service {
      self.service = service
    } else {
      self.service = ArcusProductCatalogServiceProvider()
    }

    // Set up the searchText Logic
    searchText
      //debounce to 250ms, but who can type that fast?
      .debounce(0.25, scheduler:  MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] text in
        if let text = text, text.count > 0 {
          self?.search(withText: text)
        } else {
          self?.resetSearch()
        }
      })
     .addDisposableTo(disposeBag)
  }

  /// Our Search State has changed to an empty String Reset the UI to that state
  fileprivate func resetSearch() {
    viewModels = nil
  }

  /// call to update results from the platform given a search string
  /// optionals allow for empty search or no search text given to reset the view
  /// - Parameter text: search text
  func updateSearchResults(for text: String?) {
    // Place the string onto the stream of Search Results
    searchText.onNext(text)
  }

  func search(withText text: String) {

    let searchObserver = try? service.requestProductCatalogServiceFindProducts(place, search: text)

    searchObserver?.observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] response in
        guard let response = response as? ProductCatalogServiceFindProductsResponse else {
          DDLogWarn("Expecting a ProductCatalogServiceFindProductsRequest Event")
          return
        }
        self?.buildViewModelsFromResponse(response.getProducts())
      })
      .disposed(by: disposeBag)
  }

  fileprivate func buildViewModelsFromResponse(_ products: [Any]?) {
    guard (products?.count) ?? 0 > 0,
      let products = products as? [[String: AnyObject]] else {
      self.viewModels = []
      return
    }
    // Set the View Models
    viewModels = products
      .map { ProductModel(attributes: $0) }
      .map{ CatalogDeviceViewModel(product: $0) }

  }

}
