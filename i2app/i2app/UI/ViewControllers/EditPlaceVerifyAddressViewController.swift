//
//  EditPlaceVerifyAddressViewController.swift
//  i2app
//
//  Arcus Team on 2/16/17.
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
import UIKit
import Cornea

class EditPlaceVerifyAddressViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
UINavigationControllerDelegate,
SaveAddressDelegate {

  fileprivate let disabledButtonAlpha: CGFloat = 0.4
  fileprivate let enabledButtonAlpha: CGFloat = 1.0

  internal var streetAddress: [String:String]?
  internal var currentPlace: PlaceModel?
  internal var presenter: SaveAddressPresenter?

  fileprivate var suggestedAddresses: [[String:String]] = []
  fileprivate var enteredAddress: [String:String] = [:]
  fileprivate var isPro: Bool = false
  fileprivate var isUpdatedSuccessfully = false
  fileprivate var isTimezoneValid = true
  fileprivate var selectedAddress: [String:String]?

  @IBOutlet weak var suggestionsTable: UITableView!
  @IBOutlet weak var residenceCheckbox: UIImageView!
  @IBOutlet weak var residenceTouchRegion: UIView!
  @IBOutlet weak var saveButton: ArcusButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    navBar(withBackButtonAndTitle: self.navigationItem.title)

    self.presenter = SaveAddressPresenter(currentPlace: currentPlace!)
    self.navigationController?.delegate = self
    suggestionsTable.dataSource = self
    suggestionsTable.delegate = self
    residenceTouchRegion
      .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                   action: #selector(self.onIsPrivateResidenceTapped)))

    updateSuggestions()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  func onIsPrivateResidenceTapped() {
    residenceCheckbox.isHighlighted = !residenceCheckbox.isHighlighted

    saveButton.isEnabled = residenceCheckbox.isHighlighted
    if saveButton.isEnabled {
      saveButton.alpha = enabledButtonAlpha
    } else {
      saveButton.alpha = disabledButtonAlpha
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let selectionViewController = segue.destination as? ProMonCantVerifyViewController {
      selectionViewController.currentPlace = currentPlace
      selectionViewController.address = streetAddress
    }
  }

  // MARK: UINavigationControllerDelegate

  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    if let placeEditVc = viewController as? EditPlaceInfoViewController {

      // If we couldn't verify user's address, return to EditPlaceInfoViewController already in the edit state
      if !isUpdatedSuccessfully {
        placeEditVc.updateEditDoneState()
      }

      if !isTimezoneValid {
        placeEditVc.onClickTimeZone(placeEditVc)
      }
    }
  }

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if hasUseWhatITyped() {
      return suggestedAddresses.count + 1
    } else {
      return suggestedAddresses.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var suggested: [String: String] = [:]
    var cellType: String

    if isUseWhatITypedRow(indexPath.row) {
      suggested = enteredAddress

      var line = ""
      if let line1 = enteredAddress["line1"] {
        line = line1
      }
      if let line2 = enteredAddress["line2"] {
        line = "\(line) \(line2)"
      }

      suggested["line2"] = line
      cellType = "UseWhatITypedCell"
    } else {
      suggested = suggestedAddresses[indexPath.row]
      if suggested.keys.contains("line2") {
        cellType = "DoubleLineSuggestionCell"
      } else {
        cellType = "SingleLineSuggestionCell"
      }
    }

    if let cell = tableView
      .dequeueReusableCell(withIdentifier: cellType) as? AddressSuggestionCell {
      // TODO: Causes seperators to dissapear when selected. Hrmm.
      let bgColorView = UIView()
      bgColorView.backgroundColor = UIColor.clear
      cell.selectedBackgroundView = bgColorView

      cell.backgroundColor = UIColor.clear

      if let line1 = suggested["line1"] {
        cell.line1?.text = line1.uppercased()
      }

      if let line2 = suggested["line2"] {
        cell.line2?.text = line2.uppercased()
      }

      var city = ""
      if let sCity = suggested["city"] {
        city = sCity.uppercased()
      }

      var state = ""
      if let sState = suggested["state"] {
        state = sState.uppercased()
      }

      var zip = ""
      if let sZip = suggested["zip"] {
        zip = sZip.uppercased()
      }

      cell.line3.text = "\(city), \(state) \(zip)"

      return cell
    }

    return UITableViewCell()
  }

  // MARK: UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    if hasUseWhatITyped() && isUseWhatITypedRow(indexPath.row) {
      selectedAddress = enteredAddress
    } else {
      selectedAddress = suggestedAddresses[indexPath.row]
    }
  }

  // MARK: VerifyAddressDelegate

  func onShowCantVerifyAddress() {
    hideGif()

    self.performSegue(withIdentifier: "segueToCantVerify", sender: self)
  }

  func onShowProMonNotAvailable() {
    hideGif()

    let vc = ArcusPinkErrorTextModalViewController.create(
      NSLocalizedString("NOT AVAILABLE", comment: ""),
      description: NSLocalizedString("Professional Monitoring is not currently offered at this address. "
        + ""
        + "change your address.", comment: ""))

    self.navigationController?.popViewController(animated: true)
    self.navigationController?.present(vc, animated: true, completion: nil)
  }

  func onShowInvalidAddress() {
    hideGif()

    let vc = ArcusPinkErrorTextModalViewController.create(
      NSLocalizedString("INVALID ADDRESS", comment: ""),
      description: NSLocalizedString("The address cannot be saved and/or verified. Please ensure your "
        + "address is correct and try again.", comment: ""))

    self.navigationController?.popViewController(animated: true)
    self.navigationController?.present(vc, animated: true, completion: nil)
  }

  func onShowProMonNotServiced() {
    hideGif()
    
    let vc = ProMonNoAgenciesViewController.create()
    self.navigationController?.popViewController(animated: true)
    self.navigationController?.present(vc, animated: true, completion: nil)
  }

  func onShowSuggestions(_ isPro: Bool,
                         isValid: Bool,
                         enteredAddress: [String : String],
                         suggestedAddresses: [[String : String]]) {
    hideGif()

    self.suggestedAddresses = suggestedAddresses
    self.enteredAddress = enteredAddress
    self.isPro = isPro
  }

  func onSaveError() {
    hideGif()

    let vc = ArcusPinkErrorTextModalViewController.create(
      NSLocalizedString("INVALID ADDRESS", comment: ""),
      description: NSLocalizedString("The address cannot be saved and/or verified. Please ensure "
        + "your address is correct and try again.", comment: ""))

    self.navigationController?.popViewController(animated: true)
    self.navigationController?.present(vc, animated: true, completion: nil)
  }

  func onSaveSuccess(_ needsTimezoneUpdate: Bool, needsPermit: Bool) {
    hideGif()

    self.isUpdatedSuccessfully = true
    self.isTimezoneValid = isPro || !needsTimezoneUpdate

    if isPro && needsPermit {
      self.performSegue(withIdentifier: "segueToPermitRequired", sender: self)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }

  // MARK: IBActions

  @IBAction func onSave(_ sender: AnyObject) {
    createGif()
    presenter?.saveAddress(delegate: self, address: selectedAddress!)
  }

  // MARK: Helpers

  fileprivate func hasUseWhatITyped() -> Bool {
    return !isPro && enteredAddress.keys.count > 0
  }

  fileprivate func isUseWhatITypedRow(_ row: Int) -> Bool {
    return row >= suggestedAddresses.count
  }

  private func updateSuggestions() {
    self.suggestionsTable.reloadData()

    // User needs to click "I confirm this is a residential property" before Save is available
    if isPro {
      saveButton.isEnabled = false
      saveButton.alpha = disabledButtonAlpha
    }

      // Don't show confirmation button to basic/premium users
    else {
      residenceTouchRegion.isHidden = true
    }

    let defaultSelection = IndexPath(item: 0, section: 0)
    suggestionsTable.selectRow(at: defaultSelection,
                               animated: false,
                               scrollPosition: UITableViewScrollPosition.top)
    self.tableView(suggestionsTable, didSelectRowAt: defaultSelection)
  }

}

class AddressSuggestionCell: UITableViewCell {
  @IBOutlet weak var line1: UILabel?
  @IBOutlet weak var line2: UILabel?
  @IBOutlet weak var line3: UILabel!
  @IBOutlet weak var checkbox: UIImageView!
}
