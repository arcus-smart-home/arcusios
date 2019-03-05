//
//  CatalogBrandListViewController.swift
//  i2app
//
//  Created by Arcus Team on 1/29/18.
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
 This view controller displays available brands for pairing.
 */
class CatalogBrandListViewController: UIViewController,
  HeaderScrollable,
  DismissPairingDevicesPresenter,
  BackButtonDelegate,
  StaticResourceImageURLHelper {

  // Required by  DismissPairingDevicesPresenter
  let disposeBag = DisposeBag()

  // Required by HeaderScrollable
  @IBOutlet weak var scrollableHeader: UIView!
  @IBOutlet weak var scrollableHeaderTopConstraint: NSLayoutConstraint!
  var scrollableHeaderPreviousOffsetY: CGFloat = 0
  
  @IBOutlet weak var filterSegmentedControl: ScleraSegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var totalDeviceCount: UILabel!
  @IBOutlet var advancedUserButton: UIButton!

  var searchController: UISearchController?

  /**
   Navigation Controller Delegate set in viewDidLoad to handle unique transitions
   Strong reference because we may need to change this delegate dynamically
   */
  @IBOutlet var navigationControllerDelegate: UINavigationControllerDelegate?
  
  var presenter: CatalogBrandListPresenterProtocol!

  var selectedFilter: ProductCatalogFilterOptions = .allProducts {
    didSet {
      guard let _ = viewIfLoaded else { return }
      self.tableView.reloadData()
      filterDidUpdate()
    }
  }

  var selectedBrandList: [CatalogBrandViewModel] {
    return presenter.viewModel.list(filter: self.selectedFilter)
  }

  static func create() -> CatalogBrandListViewController? {
    let storyboard = UIStoryboard(name: "PairingCatalog", bundle: nil)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: "BrandList")
      as? CatalogBrandListViewController else {
      return nil
    }
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // dismissPairingDevices should be called when the view is first created
    dismissPairingDevices { _ in }

    // Set up presenter
    guard let modelCache = RxCornea.shared.modelCache as? RxArcusModelCache,
      let cacheLoader = RxCornea.shared.cacheLoader as? RxArcusModelCacheLoader,
      let placeAddress = RxCornea.shared.settings?.currentPlace?.address,
      let provider = PairingSubsystemModelProvider(SubsystemCache.sharedInstance.pairingSubsystem(),
                                                   modelCache: modelCache,
                                                   cacheLoader: cacheLoader),
      let pres = CatalogBrandListPresenter(delegate: self,
                                           pairingSubsystemModelProvider: provider,
                                           modelCache: modelCache,
                                           currentPlace: placeAddress)
      else {
        // Fatal Error
        DDLogError("Fatal Error in CatalogBrandListViewController, creating presenter")
        ArcusAnalytics.tag(AnalyticsTags.DevicePairingFatalError, attributes: [:])
        tableView.dataSource = nil
        tableView.delegate = nil
        ApplicationRoutingService.defaultService.showDashboard()
        return
    }
    presenter = pres

    // Set up Search
    if let searchPresenter = ProductSearchPresenter() {
      searchController = ProductSearchController.create(withDelegate: self,
                                                        presenter: searchPresenter)
    }

    // Check if the warning modal needs to be presented
    presenter?.checkPairingWarning()

    // Set up Navigation Controller
    self.navigationController?.delegate = self.navigationControllerDelegate

    // Configure Views
    addScleraBackButton(delegate: self)
    addScleraStyleToNavigationTitle()
    updateViews()
  }

  @IBAction func unwindToBrandList(segue: UIStoryboardSegue) {
    // Nothing to do
  }

  // MARK: BackButtonDelegate

  func onBackButtonPressed() {
    // use ExitPairingPresenter
    handleExitPairing()
  }

  /**
   Unwind action that updates the view controller with data when navigating back.
   - parameter sender: The segue connecting back to the view controller.
   */
  @IBAction func unwindFromDeviceList(_ sender: UIStoryboardSegue) {
    if let deviceListViewController = sender.source as? CatalogDeviceListViewController,
      let deviceListPresenter = deviceListViewController.presenter {
      searchController?.delegate = self
      selectedFilter = deviceListViewController.selectedFilter
    }
  }
  
  /**
   Action called when the segmented control changes selected value.
   */
  @IBAction func filterOptionPressed(_ sender: Any) {
    let filter = ProductCatalogFilterOptions(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .allProducts
    advancedUserButton.isHidden = true
    selectedFilter = filter
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

  func updateViews() {
    let totalDevices = selectedBrandList.reduce(0) { (result, vm) -> Int in
      return result + vm.productList.count
    }
    if totalDevices == 1 {
      totalDeviceCount.text = "1 Result"
    } else {
      totalDeviceCount.text = "\(totalDevices) Results"
    }

    filterSegmentedControl.setSelectedSegment(withIndex: selectedFilter.rawValue)
    tableView.reloadData()
  }

  func filterDidUpdate() {
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
}

// MARK: CatalogBrandListPresenterDelegate

extension CatalogBrandListViewController: CatalogBrandListPresenterDelegate {
  
  func shouldPresentPairingWarning() {
    performSegue(withIdentifier: PairingCatalogSegue.showPairingWarning.rawValue, sender: self)
  }

  func availableBrandsDidUpdate() {
    guard let _ = viewIfLoaded else { return }
    updateViews()
  }
}

// MARK: UITableViewDataSource

extension CatalogBrandListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedBrandList.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell") as? CatalogBrandListCell,
      selectedBrandList.count > indexPath.row else {
      return UITableViewCell()
    }
    
    advancedUserButton.isHidden = false
    bind(cell, viewModel: selectedBrandList[indexPath.row])
    return cell
  }

  private func bind(_ cell: CatalogBrandListCell, viewModel: CatalogBrandViewModel) {
    cell.deviceCount.text = "\(viewModel.productList.count)"
    cell.brandImage.sd_setImage(with: viewModel.imageURL)
  }
}

extension CatalogBrandListViewController: PairingCatalogSeguePerformer {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    /// Special prep for the push to CatalogDeviceListViewController
    if let segueId = segue.identifier,
      let pairingCatalogSegue = PairingCatalogSegue(rawValue: segueId),
      pairingCatalogSegue == .showDeviceList,
      let deviceListViewController = segue.destination as? CatalogDeviceListViewController,
      let selectedIndex = tableView.indexPathForSelectedRow?.row,
      let brand = selectedBrandList[safe: selectedIndex] {

      let brandName = brand.name
      let deviceListPresenter = CatalogDeviceListPresenter(brandName: brandName,
                                                           cache: self.presenter)
      deviceListViewController.searchController = self.searchController
      deviceListViewController.presenter = deviceListPresenter
      deviceListViewController.selectedFilter = selectedFilter
      return
    }
    
    if let pairingWarning = segue.destination as? PairingWarningViewController {
      pairingWarning.delegate = self
    }
    
    /// Handle all the other segues the same
    prepareShared(segue: segue, sender: sender)
  }
}

// MARK: UITableViewDelegate

extension CatalogBrandListViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollableHeaderScrollViewDidUpdate(scrollView)
  }
  
}

// MARK: UISearchControllerDelegate

extension CatalogBrandListViewController: UISearchControllerDelegate {
  // Use the default implementation of `func presentSearchController(_ searchController: UISearchController)`
}

// MARK: ExitPairingPresenter

extension CatalogBrandListViewController: ExitPairingPresenter {

  /// A Helper function for using `ExitPairingPresenter.prepareToExitPairing()`
  func handleExitPairing() {
    let strat = prepareToExitPairing()
    switch strat {
    case .exit:
      dismissPairingDevices { zwaveRebuild in
        if zwaveRebuild {
          ApplicationRoutingService.defaultService.showZWRebuild()
        }
      }
      self.navigationController?.popViewController(animated: true)
    case .shouldDisplayPopup(let type):
      switch type {
      case .normal:
        self.performSegue(withIdentifier: PairingCatalogSegue.showExitPairingNormalPopup.rawValue,
                          sender: nil)
      case .warning:
        self.performSegue(withIdentifier: PairingCatalogSegue.showExitPairingWarningPopup.rawValue,
                          sender: nil)
      }
    }
  }
}

// MARK: ExitPairingPopupDelegate

extension CatalogBrandListViewController: ExitPairingPopupDelegate {

  func dismissExitPairingPopup() {
    self.dismiss(animated: true, completion: nil)
  }

  func shouldExitPairing() {
    dismissPairingDevices { zwaveRebuild in
      if zwaveRebuild {
        ApplicationRoutingService.defaultService.showZWRebuild()
      }
    }
    if presentedViewController != nil {
      self.dismiss(animated: false) {
        self.navigationController?.popViewController(animated: true)
      }
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }

  func shouldViewPairedDevices() {
    self.dismiss(animated: false) {
      let showPairingCart = PairingCatalogSegue.showPairingCart.rawValue
      self.performSegue(withIdentifier: showPairingCart, sender: false)
    }
  }

}

// MARK: AdvancedPairingPopupDelegate

extension CatalogBrandListViewController: PairingWarningDelegate {
  func shouldTransitionToActivation() {
    performSegue(withIdentifier: PairingCatalogSegue.showKitSetup.rawValue, sender: false)
  }
  
  func shouldTransitionToImproperlyPaired() {
    performSegue(withIdentifier: PairingCatalogSegue.showPairingCart.rawValue, sender: false)
  }
}

// MARK: AdvancedPairingPopupDelegate

extension CatalogBrandListViewController: AdvancedPairingPopupDelegate, DeviceModelVerificationPresenter {

  func dismissAdvancedPairingPopup() {
    self.dismiss(animated: true, completion: nil)
  }

  func shouldViewAdvancedPairing() {
    self.dismiss(animated: false) {
      // default has hubRequired as true
      let hubRequiredViewModel = CatalogDeviceViewModel()
      let nextStep = self.didSelect(deviceViewModel: hubRequiredViewModel)
      var segue = PairingCatalogSegue.segueFor(deviceModelVerification: nextStep)
      if segue == .showPairingInstructions {
        segue = .showPairingCart
      }
      if self.shouldPerformSegue(withIdentifier: segue.rawValue, sender: hubRequiredViewModel) {
        self.performSegue(withIdentifier: segue.rawValue, sender: hubRequiredViewModel)
      }
    }
  }
}
