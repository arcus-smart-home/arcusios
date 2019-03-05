//
//  ProductSearchResultsViewController.swift
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
import Cornea
import RxSwift

extension Constants {
  /// The UITableViewCell we are using, setup in the storyboard
  static let ProductSearchCellIdentifier = "ProductSearchCell"
}

class ProductSearchResultsViewController: UIViewController, ScrollViewKeyboardAnimatable,
DeviceModelVerificationPresenter {

  /// For DeviceModelVerificationPresenter
  var disposeBag = DisposeBag()
  
  var keyboardAnimatableShowObserver: Any?
  
  var keyboardAnimatableHideObserver: Any?

  /// The Tableview that has one dynamic cell with identifier `Constants.ProductSearchCellIdentifier`
  /// Configured to be used by BottomConstraintKeyboardAnimation
  @IBOutlet var tableView: UITableView!

  /// Configured to be used by BottomConstraintKeyboardAnimation
  @IBOutlet var bottomConstraint: NSLayoutConstraint!

  /// this reference is needed for the tap gesture outside of the tableview to dismiss the search controller
  weak var searchController: UISearchController?

  /// Presenter, set in the required factory function so explictly unwrapped
  fileprivate var presenter: ProductSearchPresenterProtocol!

  /// Getter for BottomConstraintKeyboardAnimation
  var keyboardAnimationView: UIScrollView! {
    return tableView
  }

  /// Strong Reference to the Tap Gesture Recognizer
  @IBOutlet var tapGesture: UITapGestureRecognizer!

  /// Required Factory Function to set up dependancies
  class func create(presenter: ProductSearchPresenterProtocol) -> ProductSearchResultsViewController? {
    let sb = UIStoryboard(name: "PairingCatalog", bundle: nil)
    let id =  String(describing: "ProductSearchResultsViewController")
    if let vc = sb.instantiateViewController(withIdentifier: id) as? ProductSearchResultsViewController {
      vc.presenter = presenter
      presenter.delegate = vc
      return vc
    }
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set our views to clear, the clear values from the storyboard are lost or reset in the transition
    view.backgroundColor = UIColor.clear
    tableView.backgroundColor = UIColor.clear

    // Configure Search Bar
    self.searchController?.searchBar.delegate = self
    self.searchController?.searchBar.placeholder = NSLocalizedString("Search", comment: "")
    self.searchController?.searchBar.barTintColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    self.searchController?.searchBar.barStyle = .default
    self.searchController?.searchBar.isTranslucent = false
    self.searchController?.searchBar.showsCancelButton = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    addKeyboardScrolling()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
 
    cleanUpKeyboardScrollingObservers()
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let identifier = PairingCatalogSegue(rawValue: identifier) else {
      return false
    }
    if identifier == .showPairingInstructions,
      let viewModel = sender as? CatalogDeviceViewModel,
      let presentingViewController = searchController?.delegate as? UIViewController {

      /// Here we override our behavior and delegate this segue to our presenting View Controller
      presentingViewController.dismiss(animated: true, completion: {
        presentingViewController.performSegue(withIdentifier: identifier.rawValue,
                                              sender: viewModel)
      })
      return false
    }
    return true
  }

  /// The default implementation did not dismiss when the user clicked outside of the tableView search area
  /// This function called from a gesture recognizer on `self.view` should dismiss the search controller
  /// when the user taps outside of the visible area that the tableview has, we do this by making a Rect
  /// that is at least as large as the tableview's content area and seeing if the point is contained within
  /// that rectangle
  @IBAction func tapOutsideSearchArea(_ tap: UITapGestureRecognizer) {
    searchController?.isActive = false
  }
}

// MARK: UITableViewDataSource

extension ProductSearchResultsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let viewModels = presenter.viewModels {
      if viewModels.count > 0 {
        return viewModels.count // Display a list of Cells
      } else {
        return 1 // Display No Results Cell
      }
    } else {
      return 0 // Display an empty list
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ProductSearchCellIdentifier,
                                             for: indexPath)

    if let viewModels = presenter.viewModels {
      if viewModels.count > 0 {
        // Display a list of Cells
        let vm = viewModels[indexPath.row]
        cell.textLabel?.text = "\(vm.brand) \(vm.name)"
      } else {
        // Display No Results Cell
        cell.textLabel?.text = NSLocalizedString("No Results", comment: "")
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
      }
      return cell
    }
    // Display an empty list, But if we got here then we should just fail gracefully
    DDLogWarn("This is a misconfigured state in ProductSearchResultsViewController")
    cell.textLabel?.text = ""
    return cell
  }
}

// MARK: UITableViewDelegate

extension ProductSearchResultsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let viewModels = presenter.viewModels,
      viewModels.count > indexPath.row,
      let viewModel = presenter.viewModels?[indexPath.row] else {
        return
    }
    verify(deviceViewModel: viewModel)
  }
}

// MARK: UISearchResultsUpdating

/// Humble Object Pattern style passing of any text changes to the presenter
extension ProductSearchResultsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    presenter.updateSearchResults(for: searchController.searchBar.text)
  }
}

// MARK: ProductSearchPresenterDelegate

extension ProductSearchResultsViewController: ProductSearchPresenterDelegate {
  func update() {
    self.tableView.reloadData()
  }
}

// MARK: UISearchBarDelegate

extension ProductSearchResultsViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    // Dismiss the Search Controller
    searchController?.isActive = false
  }
}

extension ProductSearchResultsViewController: PairingCatalogSeguePerformer {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    prepareShared(segue: segue, sender: sender)
  }
}
