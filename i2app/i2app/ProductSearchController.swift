//
//  ProductSearchController.swift
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

import UIKit

/// Factory for UISearchController's that search for Products
class ProductSearchController {

  /// create method that handles the setup details of our UISearchController
  ///
  /// - Parameters:
  ///   - delegate: delegate for the search controller used to handled animations on and off screen
  ///   - presenter: used for business logic
  /// - Returns: UISearchController that is properly configured to be animated over a View Controller
  static func create(withDelegate delegate: UISearchControllerDelegate,
                     presenter: ProductSearchPresenterProtocol) -> UISearchController? {
    guard let results = ProductSearchResultsViewController.create(presenter: presenter) else {
      return nil
    }
    let controller = UISearchController(searchResultsController: results)
    results.searchController = controller
    controller.searchResultsUpdater = results
    controller.delegate = delegate
    controller.hidesNavigationBarDuringPresentation = false
    controller.dimsBackgroundDuringPresentation = true
    return controller
  }
}
