//
//  PairingCartViewController.swift
//  i2app
//
//  Arcus Team on 3/7/18.
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
import RxSwift
import Cornea

class PairingCartViewController: UIViewController {

  /// lifecycle: created at viewDidLoad and destroyed on deinit
  var presenter: PairingCartPresenter!

  // Needed for PairingCustomizationPresenter
  let disposeBag = DisposeBag()

  var productAddress: String?
  var formInput: [String:String]?
  var viewModel: PairingCartSectionViewModel?
  var startSearchingOnLoad: Bool = true
  var buttonsAreDocked: Bool = false {
    didSet {
      buttonStack.isHidden = !buttonsAreDocked
    }
  }
  var topButtonTitle: String?
  var bottomButtonTitle: String?

  @IBOutlet weak var buttonStack: UIStackView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var topButton: ScleraButton!
  @IBOutlet weak var bottomButton: ScleraButton!

  override public func viewDidLoad() {
    super.viewDidLoad()

    configureInitialViews()

    guard let modelCache = RxCornea.shared.modelCache as? RxArcusModelCache,
      let cacheLoader = RxCornea.shared.cacheLoader as? RxArcusModelCacheLoader,
      let provider = PairingSubsystemModelProvider(SubsystemCache.sharedInstance.pairingSubsystem(),
                                                   modelCache: modelCache,
                                                   cacheLoader: cacheLoader),
      let pres = PairingCartPresenter(provider, modelCache: modelCache) else {
        // Fatal Error
        DDLogError("Fatal Error in PairingCartViewController")
        ArcusAnalytics.tag(AnalyticsTags.DevicePairingCartFatalError, attributes: [:])
        ApplicationRoutingService.defaultService.showDashboard()
        return
    }
    pres.delegate = self
    presenter = pres

    tableView.dataSource = self
    tableView.delegate = self

    if startSearchingOnLoad {
      startSearching()
    } else {
      presenter.checkForPairedDevices()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    self.tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    if segue.identifier == PairingCartSegues.segueToFactoryReset.rawValue {
      FactoryResetBaseViewController.productAddress = self.productAddress
    }
    
    if let destination = segue.destination as? MispairedNavigationController,
       let mispairedDev = sender as? PairingDeviceModel {

      destination.mispairedDev = mispairedDev
    }

    if segue.identifier == PairingCartSegues.segueToConfirmexitPairing.rawValue,
      let vc = segue.destination as? ConfirmExitPairingViewController {
      vc.delegate = self
    }
    
    if let vc = segue.destination as? PairingTimeoutViewController {
      vc.delegate = self

      if segue.identifier == PairingCartSegues.segueToTimeout.rawValue {
      
        if let disposition = sender as? CartDisposition {
          vc.topButtonSender = disposition
          vc.bottomButtonSender = disposition

          if disposition == .noDevices {
            vc.titleText = "Exit Pairing"
            vc.subtitleText = "No devices have been found yet."
            vc.topButtonTitle = "SEARCH FOR DEVICES"
            vc.bottomButtonTitle = "GO TO DASHBOARD"
          } else if disposition == .uncustomizedDevices {
            vc.titleText = "Exit Pairing"
            // swiftlint:disable:next line_length
            vc.subtitleText = "We recommend customizing all devices before going to the Dashboard. Default settings will be applied if you exit now."
            vc.topButtonTitle = "CUSTOMIZE MY DEVICE(S)"
            vc.bottomButtonTitle = "GO TO DASHBOARD"
            vc.dismissOnBackgroundTap = true
          } else if disposition == .timeoutNoDevices {
            vc.titleText = "Pairing Has Timed Out"
            vc.subtitleText = "Do you want to keep searching for new devices?"
            vc.topButtonTitle = "YES, KEEP SEARCHING"
            vc.bottomButtonTitle = "NO, GO TO DASHBOARD"
          } else if disposition == .timeoutWithDevices {
            vc.titleText = "Pairing Has Timed Out"
            vc.subtitleText = "Do you want to keep searching for new devices?"
            vc.topButtonTitle = "YES, KEEP SEARCHING"
            vc.bottomButtonTitle = "NO, VIEW MY DEVICES"
          }
        }
      } else if segue.identifier == PairingCartSegues.segueToMispairedExit.rawValue {
        vc.bottomButtonSender = CartDisposition.clean
        vc.titleText = "Exit Pairing"
        // swiftlint:disable:next line_length
        vc.subtitleText = "One or more devices were paired but needs your attention. We recommend resolving before going to the dashboard."
        vc.topButtonTitle = "RETURN TO DEVICES"
        vc.bottomButtonTitle = "GO TO DASHBOARD"
      }
    }
  }

  private func configureInitialViews() {
    buttonStack.isHidden = true
    removeScleraBackButton(animated: false)
    navigationItem.title = "Add a Device"
    addScleraStyleToNavigationTitle()
  }

  fileprivate func startSearching() {
    presenter.search(forProduct: productAddress, formInput: formInput ?? [:])
  }
  
  // MARK: IBActions

  @IBAction func onTappedPairAnotherDevice(_ sender: Any) {
    self.performSegue(withIdentifier: PairingCartSegues.unwindToProductCatalog.rawValue, sender: nil)
  }

  @IBAction func onTappedGoToDashboard(_ sender: Any) {
    presenter.abortToDashboard()
  }
  
  @IBAction func unwindToPairingCart(segue: UIStoryboardSegue) {
    startSearching()
  }
  
  @IBAction func unwindToPairingCartNoSearching(segue: UIStoryboardSegue) {
    presenter.checkForPairedDevices()
  }

}

extension PairingCartViewController: PairingCustomizationPresenter {

  func onCustomize(_ device: DeviceModel) {
    // Retrieve the customization steps given the device address of the selected entry
    pairingCustomizationPresenterFetchSteps(deviceAddress: device.address) { (viewModel) in
      self.presenter.stopSearching()
    
      // Ensure that all the data needed to present the steps is present
      guard let viewModel = viewModel,
      let firstStep = viewModel.steps.first,
      let stepType = firstStep.stepType,
      let viewController =
        PairingCustomizationViewControllerFactory.viewController(forStepType: stepType) else {
        return
      }

      // Configure the data for the first step
      viewController.deviceAddress = device.address
      viewController.stepIndex = 0
      viewController.pairingCustomizationViewModel = viewModel

      // Create a navigation controller for the customization workflow and present it modally
      let navigation = UINavigationController(rootViewController: viewController)
      self.present(navigation, animated: true, completion: nil)
    }
  }

  func onResolve(_ pairDev: PairingDeviceModel) {
    self.performSegue(withIdentifier: PairingCartSegues.segueToResolutionSteps.rawValue, sender: pairDev)
  }

}

extension PairingCartViewController : BackButtonDelegate {

  func onBackButtonPressed() {
    presenter.stopTimeoutUpdates()
    navigationController?.popViewController(animated: true)
    if navigationController?.topViewController is CatalogBrandListViewController {
      presenter.stopSearching()
    }
  }

}

extension PairingCartViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    if (viewModel?.sections.count ?? 0) > indexPath.row, let section = viewModel?.sections[indexPath.row] {
      return section.isActionable
    }
    return false
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let section = viewModel?.sections[indexPath.row] {
      if let section = section as? CustomizeDeviceSectionModel {
        presenter.customize(section.address)
      } else if let section = section as? RemoveDeviceSectionModel {
        presenter.resolve(section.pairDev)
      }
    }
  }

}

extension PairingCartViewController: UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if buttonsAreDocked {
      return self.viewModel?.sections.count ?? 0
    } else {
      return (self.viewModel?.sections.count ?? 0) + visibleButtonCount()
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
        
          // After having rendered last cell, check if we should update button dock
          if indexPath == lastVisibleIndexPath {
            if self.updateButtonDock() {
              self.tableView.reloadData()
            }
          }
      }
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let sections = self.viewModel?.sections {
      // Synthesize undocked button cell
      if indexPath.row >= sections.count {
        if topButtonUndocked() && indexPath.row == sections.count {
          return getUndockedTopButtonCell()
        } else {
          return getUndockedBottomButtonCell()
        }
      }
      
      // Create normal section cell
      else {
        let model = sections[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier) {
          
          if let cell = cell as? HomeAnimationCell,
             let model = model as? HomeAnimationSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? TitleCell,
             let model = model as? TitleSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? TroubleshootingTitleCell,
             let model = model as? TroubleshootingTitleSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? TroubleshootingTipCell,
             let model = model as? TroubleshootingTipSectionModel {
            cell.bindToModel(model, delegate: self)
          }

          if let cell = cell as? PendingDeviceCell,
             let model = model as? PendingDeviceSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? CustomizeDeviceCell,
             let model = model as? CustomizeDeviceSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? RemoveDeviceCell,
             let model = model as? RemoveDeviceSectionModel {
            cell.bindToModel(model)
          }

          if let cell = cell as? CompletedDeviceCell,
             let model = model as? CompletedDeviceSectionModel {
            cell.bindToModel(model)
          }

          return cell
        }
      }
    }
    return UITableViewCell()
  }
  
  func getUndockedTopButtonCell() -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "TopButtonCell") as? ButtonCell {
      if let title = topButtonTitle {
        cell.button.setTitle(title, for: .normal)
      }
      return cell
    }
    return UITableViewCell()
  }
  
  func getUndockedBottomButtonCell() -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "BottomButtonCell") as? ButtonCell {
      if let title = bottomButtonTitle {
        cell.button.setTitle(title, for: .normal)
      }
      return cell
    }
    return UITableViewCell()
  }
}

extension PairingCartViewController: PairingCartDelegate {

  func onUpdatePairingCartView(_ viewModel: PairingCartSectionViewModel) {
    self.viewModel = viewModel
    self.topButtonTitle = self.viewModel?.topButton
    self.bottomButtonTitle = self.viewModel?.bottomButton
    _ = self.updateButtonDock()
    self.tableView.reloadData()

    // Back button only when in pairing mode
    if viewModel.isStillSearching() {
      addScleraBackButton(delegate: self)
    } else {
      removeScleraBackButton()
    }
  }

  func onSearchTimeout(_ disposition: CartDisposition) {
    if self.viewIfLoaded?.window != nil {
      self.performSegue(withIdentifier: PairingCartSegues.segueToTimeout.rawValue, sender: disposition)
    } else {
      DDLogInfo("Ignoring request to show timeout because pairing cart is not visible.")
    }
  }

  func onSegueToDashboard(_ disposition: CartDisposition) {
    switch disposition {
    case .clean:
      presenter.dismissAll()
      
    case .mispairedDevices:
      self.performSegue(withIdentifier: PairingCartSegues.segueToMispairedExit.rawValue, sender: disposition)

    case .noDevices:
      self.performSegue(withIdentifier: PairingCartSegues.segueToConfirmexitPairing.rawValue, sender: nil)
        
    default:
      self.performSegue(withIdentifier: PairingCartSegues.segueToTimeout.rawValue, sender: disposition)
    }
  }

  func onPairingComplete(zwRebuild: Bool) {
    if zwRebuild {
      presenter.stopTimeoutUpdates()
      ApplicationRoutingService.defaultService.showZWRebuild()
    } else {
      self.navigationController?.popToRootViewController(animated: true)
    }
  }

  func onPairingError(_ reason: String) {
    presenter.stopTimeoutUpdates()
    DDLogError(reason)
    self.displayGenericErrorMessage()
  }
}

extension PairingCartViewController: PairingTimeoutDelegate {

  // User clicked the "CUSTOMIZE DEVICE(S)" or "SEARCH FOR DEVICES" button
  func onTimeoutTopButtonTapped(_ sender: Any?) {
    if let disposition = sender as? CartDisposition {
      switch disposition {
        case .clean, .timeoutWithDevices, .timeoutNoDevices, .noDevices:
          startSearching()
        case .uncustomizedDevices, .mispairedDevices:
          break
      }
    }
  }
  
  // User clicked the "GO TO DASHBOARD" button
  func onTimeoutBottomButtonTapped(_ sender: Any?) {
    if let disposition = sender as? CartDisposition {
      switch disposition {
        case .clean, .noDevices, .uncustomizedDevices, .mispairedDevices, .timeoutNoDevices:
          onSegueToDashboard(.clean)
        case .timeoutWithDevices:
          break
      }
    }
  }
}

extension PairingCartViewController: TroubleshootingTipActionDelegate {
  func onTroubleshootingActionTaken(_ model: TroubleshootingTipSectionModel?) {
    if model?.tip.isFactoryResetAction() ?? false {
      performSegue(withIdentifier: PairingCartSegues.segueToFactoryReset.rawValue, sender: nil)
    }
  }
}

extension PairingCartViewController {
  
  func buttonStackOccludesTable() -> Bool {
    return (tableView.frame.minY + tableView.contentSize.height) > buttonStack.frame.minY
  }
  
  func viewControllerOccludesTable() -> Bool {
    return (tableView.frame.minY + tableView.contentSize.height) > buttonStack.frame.maxY
  }
  
  func topButtonUndocked() -> Bool {
    return !buttonsAreDocked && topButtonTitle != nil
  }
  
  func visibleButtonCount() -> Int {
    var count = 0
    if topButtonTitle != nil {
      count += 1
    }
    if bottomButtonTitle != nil {
      count += 1
    }
    return count
  }
  
  /// Hides the buttons docked to the button of the screen and refrash the table data
  /// causing the hidden buttons to appear as cells at the bottom of the table.
  func undockButtons() {
    self.buttonsAreDocked = false
    
    // Hide docked buttons
    self.topButton.superview?.isHidden = true
    self.bottomButton.superview?.isHidden = true
  }

  /// Removes buttons from the bottom of the table and "docks" them to the bottom of
  /// the screen.
  func dockButtons() {
    self.buttonsAreDocked = true
    
    if let topButtonTitle = self.topButtonTitle {
      self.topButton.setTitle(topButtonTitle, for: .normal)
      self.topButton.superview?.isHidden = false
    } else {
      self.topButton.superview?.isHidden = true
    }
    
    if let bottomButtonTitle = self.bottomButtonTitle {
      self.bottomButton.setTitle(bottomButtonTitle, for: .normal)
      self.bottomButton.superview?.isHidden = false
    } else {
      self.bottomButton.superview?.isHidden = true
    }
  }
  
  /// Updates the "call to action" buttons that are either docked to the button of the screen, or,
  /// appended to the end of the table when the table content size exceeds the height of the screen.
  ///
  /// -returns: True if changes were made to the button dock that require the table to be reloaded;
  ///           false otherwise.
  func updateButtonDock() -> Bool {
    if buttonsAreDocked && buttonStackOccludesTable() {
      undockButtons()
      return true
    } else if !buttonsAreDocked && !viewControllerOccludesTable() {
      dockButtons()
      return true
    } else if buttonsAreDocked {
      dockButtons()
    }
    return false
  }
}

extension PairingCartViewController: ConfirmExitPairingDelegate {
  func confirmExitPairingTopButtonPressed() {
    guard let viewModel = viewModel else {
      return
    }
    
    if !viewModel.isStillSearching() {
      startSearching()
    }
  }

  func confirmExitPairingBottomButtonPressed() {
    presenter.dismissAll()
    ApplicationRoutingService.defaultService.showDashboard(animated: true, completion: nil)
  }
}

enum PairingCartSegues: String {
  case unwindToProductCatalog = "UnwindToBrandList"
  case segueToTimeout = "SegueToTimeout"
  case segueToMispairedExit = "SegueToExitPairing"
  case segueToFactoryReset = "SegueToFactoryReset"
  case segueToResolutionSteps = "SegueToResolutionSteps"
  case segueToConfirmexitPairing = "SegueToConfirmExitPairing"
}
