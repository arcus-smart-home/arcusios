//
//  CatalogDeviceListViewController.swift
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

/**
 View Controller used to display a list with the available catalog devices within a brand.
 */
class CatalogDeviceListViewController: UIViewController, HeaderScrollable, DeviceModelVerificationPresenter {

  /**
   Required by AdvancedPairingBannerViewable
   */
  let disposeBag = DisposeBag()

  /**
   Required by HeaderScrollable
   */
  @IBOutlet weak var scrollableHeader: UIView!
  
  /**
   Required by HeaderScrollable
   */
  @IBOutlet weak var scrollableHeaderTopConstraint: NSLayoutConstraint!
  
  /**
   Required by HeaderScrollable
   */
  var scrollableHeaderPreviousOffsetY: CGFloat = 0
  
  /**
   This table displays the devices available within the brand.
   */
  @IBOutlet weak var tableView: UITableView!
  
  /**
   Segmented control for selecting filter options.
   */
  @IBOutlet weak var filterSegmentedControl: ScleraSegmentedControl!
  
  /**
   The label displaying the total of devices for the current brand.
   */
  @IBOutlet weak var totalDeviceCount: UILabel!
  
  /**
   The view displayed when there are no items for a given filter.
   */
  @IBOutlet var noItemsView: UIView!
  
  /**
   Search Controller used for handling Search
   */
  var searchController: UISearchController?
  
  /**
   This presenter fetches the data needed for the Catalog Device List.
   */
  var presenter: CatalogDeviceListPresenterProtocol?

  var selectedFilter: ProductCatalogFilterOptions = .allProducts {
    didSet {
      guard let _ = viewIfLoaded else { return }
      filterDidUpdate()
      self.tableView.reloadData()
    }
  }

  var selectedBrandList: [CatalogDeviceViewModel] {
    return presenter?.deviceList(forFilter: selectedFilter) ?? []
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fetch Data
    if let presenter = presenter {
      navigationItem.title = presenter.brandName
      filterSegmentedControl.setSelectedSegment(withIndex: selectedFilter.rawValue)
    }
    
    // Set up Search
    searchController?.delegate = self
    
    // Configure Views
    addScleraStyleToNavigationTitle()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    updateViews()
  }

  /**
   Called when a user selects a filter option.
   */
  @IBAction func filterOptionSelected(_ sender: Any) {
    selectedFilter = ProductCatalogFilterOptions(rawValue: filterSegmentedControl.selectedSegmentIndex)!
  }

  /**
   Action called when the search button is pressed, used to present the Search Controller
   */
  @IBAction func presentSearch(_ sender: Any) {
    if let searchController = searchController {
      self.present(searchController, animated: true, completion: nil)
    }
  }

  /**
   Action called when the mustard view button is tapped, used to present the Pairing/Config View
   */
  @IBAction func mustardViewTapped(_ sender: Any) {
    performSegue(withIdentifier: PairingCatalogSegue.showPairingCart.rawValue, sender: false)
  }

  func filterDidUpdate() {
    guard let _ = viewIfLoaded else { return }
    UIView.animate(withDuration: 0.1, animations: {
      self.scrollableHeaderTopConstraint.constant = 0
      self.tableView.alpha = 0
    }) { (_) in
      self.updateViews()
      UIView.animate(withDuration: 0.3, animations: {
        self.tableView.alpha = 1
      })
    }
  }

  private func updateViews() {
    guard let presenter = presenter else {
      return
    }

    if navigationItem.title != presenter.brandName {
      navigationItem.title = presenter.brandName
    }

    let deviceCount = selectedBrandList.count
    if deviceCount == 1 {
      totalDeviceCount.text = "1 Result"
    } else {
      totalDeviceCount.text = "\(deviceCount) Results"
    }

    noItemsView.isHidden = deviceCount != 0

    filterSegmentedControl.setSelectedSegment(withIndex: selectedFilter.rawValue)
    tableView.reloadData()
  }

}

// MARK: UITableViewDataSource

extension CatalogDeviceListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedBrandList.count
  }

  fileprivate func bind(_ cell: CatalogDeviceListCell,
                        _ deviceViewModel: CatalogDeviceViewModel,
                        _ indexPath: IndexPath) {
    cell.deviceName.text = deviceViewModel.name
    cell.deviceBrand.text = deviceViewModel.brand
    if let placeholder = UIImage(named: "CheckmarkEmptyIcon") {
      cell.deviceImage
        .sd_setImage(with: deviceViewModel.imageURL, placeholderImage: placeholder, options: [.retryFailed]) {
          [unowned self, unowned cell] (_, error, _, _) in
          if error != nil,
            self.tableView.cellForRow(at: indexPath) == cell {
            cell.deviceImage.sd_setImage(with: deviceViewModel.devTypeImageURL,
                                         placeholderImage: placeholder,
                                         options: [.retryFailed])
          }
      }
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard selectedBrandList.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as? CatalogDeviceListCell else {
      return UITableViewCell()
    }
    
    let deviceViewModel = selectedBrandList[indexPath.row]
    bind(cell, deviceViewModel, indexPath)
    return cell
  }
  
}

// MARK: UITableViewDelegate

extension CatalogDeviceListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Humbly delegate logic to the presenter
    guard selectedBrandList.count > indexPath.row else {
        return
    }
    verify(deviceViewModel: selectedBrandList[indexPath.row])
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollableHeaderScrollViewDidUpdate(scrollView)
  }
}

// MARK: UISearchControllerDelegate

extension CatalogDeviceListViewController: UISearchControllerDelegate {
  // Use the default implementation of `func presentSearchController(_ searchController: UISearchController)`
}

extension CatalogDeviceListViewController: PairingCatalogSeguePerformer {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    prepareShared(segue: segue, sender: sender)
  }
}
