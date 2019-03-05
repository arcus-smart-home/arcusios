//
//  EditPlaceInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/18/16.
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
import PromiseKit
import RxSwift

class EditPlaceInfoViewController: ArcusBaseTimeZoneViewController,
  CustomPickerDelegate,
  UITableViewDataSource,
  UITableViewDelegate,
  VerifyAddressDelegate,
SaveAddressDelegate {
  
  @IBOutlet var homeNameTextField: AccountTextField!
  @IBOutlet var addressOneTextField: AccountTextField!
  @IBOutlet var addressTwoTextField: AccountTextField!
  @IBOutlet var cityTextField: AccountTextField!
  @IBOutlet var zipTextField: AccountTextField!
  @IBOutlet var stateButton: UIButton!
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var placeInfoTextFields: [AccountTextField]!
  
  let segueToVerifyAddress = "segueToVerifyAddress"
  let segueToCantVerify = "segueToCantVerify"
  let segueToInvalidAddress = "segueToCantVerify"
  
  let kZipCodeMaxLength: Int = 6
  var editMode: Bool = false
  var isTimezoneDirty: Bool = false
  var verifyAddressPresenter: VerifyAddressPresenter?
  var savePresenter: SaveAddressPresenter?
  
  var isPro: Bool?
  var isValid: Bool?
  var enteredAddress: [String:String]?
  var suggestedAddresses: [[String:String]]?
  
  internal var currentPlace: PlaceModel? {
    didSet {
      configureTimeZoneInfo()
    }
  }
  
  internal var streetAddress: [String:String] {
    var line1 = ""
    var line2 = ""
    var city = ""
    var state = ""
    var zip = ""

    if let text = addressOneTextField.text {
      line1 = text
    }

    if let text = addressTwoTextField.text {
      line2 = text
    }

    if let text = cityTextField.text {
      city = text
    }

    if let text = stateButton.title(for: .normal) {
      state = text
    }

    if let text = zipTextField.text {
      zip = text
    }

    return VerifyAddressPresenter
      .streetAddressFor(line1: line1, line2: line2, city: city, state: state, zip: zip)
  }
  
  var timeZone: String = ""
  var timeZoneId: String = ""
  var timeZoneOffset: Double = 0
  var timeZoneUsesDST: Bool = false

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setBackgroundColorToParentColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
    configureNavigationBarForEditDoneState(false, initialConfiguration: true)

    configureTextFields()
    configureForm()
    enableTextFieldEditing(false)

    refreshAndConfigure()

    // Workaround to allow selection of a UITableView in BaseTextViewController
    for gesture in view.gestureRecognizers! {
      view.removeGestureRecognizer(gesture)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    refreshAndConfigure()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Needed to refresh the form after address verification
    configureForm()
    configureTimeZoneInfo()
    tableView.reloadData()     // Refresh timezone changes
  }

  // MARK: UI Configuration & Manipulation

  func refreshAndConfigure() {
    if let place = currentPlace {
      place.refreshModel()
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self, place] _ in
          self?.verifyAddressPresenter = VerifyAddressPresenter(currentPlace: place)
          self?.savePresenter = SaveAddressPresenter(currentPlace: place)

          self?.configureForm()
          self?.configureTimeZoneInfo()
          self?.tableView.reloadData()     // Refresh timezone changes
        })
        .disposed(by: disposeBag)
    }
  }

  func configureTextFields() {
    homeNameTextField.placeholder = NSLocalizedString("Home", comment: "")
    homeNameTextField.autocapitalizationType = .sentences
    homeNameTextField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    homeNameTextField.setupType(AccountTextFieldTypeGeneral)
    addressOneTextField.isRequired = true
    
    addressOneTextField.placeholder = NSLocalizedString("Address Line 1", comment: "")
    addressOneTextField.autocapitalizationType = .words
    addressOneTextField.keyboardType = .numbersAndPunctuation
    addressOneTextField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    addressOneTextField.setupType(AccountTextFieldTypeGeneral)
    addressOneTextField.isRequired = true
    
    addressTwoTextField.placeholder = NSLocalizedString("Address Line 2", comment: "")
    addressTwoTextField.autocapitalizationType = .words
    addressTwoTextField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    addressTwoTextField.setupType(AccountTextFieldTypeGeneral, isRequired: false)
    
    cityTextField.placeholder = NSLocalizedString("City", comment: "")
    cityTextField.autocapitalizationType = .words
    cityTextField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    cityTextField.setupType(AccountTextFieldTypeGeneral)
    cityTextField.isRequired = true
    
    zipTextField.placeholder = NSLocalizedString("Zip", comment: "")
    zipTextField.setAccountFieldStyle(AccountTextFieldStyleWhite)
    zipTextField.setupType(AccountTextFieldTypeZipCode, isRequired: true)
    zipTextField.isRequired = true
    
  }
  
  func configureForm() {
    if currentPlace != nil {
      homeNameTextField.text = PlaceCapability.getNameFrom(currentPlace)
      addressOneTextField.text = PlaceCapability.getStreetAddress1(from: currentPlace)
      addressTwoTextField.text = PlaceCapability.getStreetAddress2(from: currentPlace)
      cityTextField.text = PlaceCapability.getCityFrom(currentPlace)
      zipTextField.text = PlaceCapability.getZipCode(from: currentPlace)
      if let state: String = PlaceCapability.getStateFrom(currentPlace) {
        stateButton.setTitle(state.uppercased(), for: UIControlState())
      }
    }
  }
  
  func configureTimeZoneInfo() {
    if let _ = PlaceCapability.getTzName(from: currentPlace) {
      timeZone = PlaceCapability.getTzName(from: currentPlace)
    }
    if let tzId = PlaceCapability.getTzId(from: currentPlace) {
      timeZoneId = tzId
    }

    timeZoneOffset = PlaceCapability.getTzOffset(from: currentPlace)
    timeZoneUsesDST = PlaceCapability.getTzUsesDST(from: currentPlace)
  }
  
  func enableTextFieldEditing(_ enabled: Bool) {
    for textField: AccountTextField in placeInfoTextFields {
      textField.isUserInteractionEnabled = enabled
    }
    
    stateButton.isUserInteractionEnabled = enabled
  }
  
  func configureNavigationBarForEditDoneState(_ isEditing: Bool, initialConfiguration initial: Bool) {
    var editDoneTitle: String = NSLocalizedString("Edit", comment: "")
    if isEditing {
      editDoneTitle = NSLocalizedString("Done", comment: "")
    }

    navBar(withTitle: navigationItem.title,
           andRightButtonText: editDoneTitle,
           with: #selector(editDoneButtonPressed(_:)))
    
    if initial {
      addBackButtonItemAsLeftButtonItem()
    }
  }
  
  func updateEditDoneState() {
    // Update Button State
    configureNavigationBarForEditDoneState(editMode, initialConfiguration: false)
    // Update Form Interaction State
    enableTextFieldEditing(editMode)
    
    tableView.reloadData()
  }
  
  func updateEditDoneButtonState(_ isEditing: Bool) {
    if isEditing {
      navBar(withTitle: navigationItem.title,
             andRightButtonText: "Done",
             with: #selector(editDoneButtonPressed(_:)))
      
    } else {
      navBar(withTitle: navigationItem.title,
             andRightButtonText: "Edit",
             with: #selector(editDoneButtonPressed(_:)))
    }
  }
  
  // MARK: Actions
  @IBAction func editDoneButtonPressed(_ sender: AnyObject) {
    let wasEditing: Bool = editMode
    editMode = !editMode
    
    // Save if Needed
    if wasEditing && !updatePlaceInfo() {
      // Entry was invalid or couldn't save; stay in edit mode
      editMode = true
    }
    
    updateEditDoneState()
  }
  
  @IBAction func stateButtonPressed(_ sender: AnyObject) {
    if let customPickerController: CustomPickerController = CustomPickerController
      .customPickerView(withDataSource: Constants.usStatesAbbreviated,
                        displayDataSource: Constants.usStates,
                        withPickerButton: stateButton) {
      customPickerController.delegate = self
      customPickerController.currentSelection = stateButton.currentTitle
      present(customPickerController,
              animated: true,
              completion: nil)
    }
  }
  
  // MARK: _
  
  @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
    _ = currentPlace?.refresh().swiftThen { _ in
      self.configureTimeZoneInfo()
      self.configureForm()
      return nil
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      if let vc = segue.destination as? EditPlaceVerifyAddressViewController,
        identifier == segueToVerifyAddress {
        vc.currentPlace = currentPlace
        vc.streetAddress = streetAddress
        vc.onShowSuggestions(isPro!,
                             isValid: isValid!,
                             enteredAddress: enteredAddress!,
                             suggestedAddresses: suggestedAddresses!)
      } else if let vc = segue.destination as? EditPlaceVerifyAddressViewController,
        identifier == segueToInvalidAddress {
        vc.currentPlace = currentPlace
        vc.streetAddress = streetAddress
        vc.onShowInvalidAddress()
      } else if let vc = segue.destination as? ProMonCantVerifyViewController,
        identifier == segueToCantVerify {
        vc.currentPlace = currentPlace
        vc.address = streetAddress
      }
    }
  }
  
  func updatePlaceInfo() -> Bool {
    var errorMessageKey: NSString? = ""
    
    if isPlaceNameDirty() {
      submitPlaceName()
    }
    
    if isAddressDirty() {
      if isDataValid(&errorMessageKey) {
        createGif()
        verifyAddressPresenter?.verifyAddress(delegate: self, address: streetAddress)
        return true
      } else {
        return false
      }
    } else if isTimezoneDirty {
      submitTimezone()
    }
    
    return true
  }
  
  func submitPlaceName() {
    guard let place = currentPlace else { return }

    createGif()
    
    // TODO: Should probably be moved into a presenter/controller
    guard let text = homeNameTextField.text else { return }
    PlaceCapabilityLegacy.setName(text, model: place)
    _ = place.commit()

    _ = currentPlace?.refresh().swiftThen { _ in
      self.hideGif()
      self.configureForm()
      return nil
    }

  }
  
  func submitTimezone() {
    // TODO: Should probably be moved into a presenter/controller
    guard let place = currentPlace else { return }

    createGif()

    PlaceCapabilityLegacy.setTzName(timeZone, model: place)
    PlaceCapabilityLegacy.setTzId(timeZoneId, model: place)
    PlaceCapabilityLegacy.setTzOffset(timeZoneOffset, model: place)
    _ = place.commit()

    _ = currentPlace?.refresh().swiftThen { _ in
      self.hideGif()
      self.configureForm()
      return nil
    }
  }
  
  func isPlaceNameDirty() -> Bool {
    return PlaceCapability.getNameFrom(currentPlace) != homeNameTextField.text
  }
  
  func isAddressDirty() -> Bool {
    var addressTwoText = ""
    if let text = addressTwoTextField.text,
      text.count > 0 {
      addressTwoText = text
    }
    
    return PlaceCapability.getStreetAddress1(from: currentPlace) != addressOneTextField.text ||
      PlaceCapability.getStreetAddress2(from: currentPlace) != addressTwoText ||
      PlaceCapability.getCityFrom(currentPlace) != cityTextField.text ||
      PlaceCapability.getStateFrom(currentPlace) != stateButton.titleLabel!.text ||
      PlaceCapability.getZipCode(from: currentPlace) != zipTextField.text
  }
  
  // MARK: CustomPickerDelegate
  func picker(_ pickerViewController: CustomPickerController,
              didPressCloseButtonWithSelection selection: String) {
    pickerViewController.pickerButton.setTitle(selection,
                                               for: UIControlState())
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ArcusTitleDetailTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: "cell")!
        as? ArcusTitleDetailTableViewCell
    
    if indexPath.row == 0 {
      cell?.titleLabel.text = NSLocalizedString("Time Zone", comment: "")
      cell?.descriptionLabel.text = timeZone
      cell?.accessoryImage.isHidden = !editMode
      if editMode {
        cell?.selectionStyle = .gray
      } else {
        cell?.selectionStyle = .none
      }
    }
    
    return cell!
  }
  
  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if editMode {
      onClickTimeZone(self)
    }
  }
  
  // MARK: UITextFieldDelegate
  override func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
    if textField != zipTextField {
      return true
    }
    let newText: String = (textField.text! as NSString)
      .replacingCharacters(in: range,
                           with: string)
    return (newText.count <= kZipCodeMaxLength)
  }
  
  // MARK: ArcusBaseTimeZoneViewController
  override func userChoseTimezone(withName timeZone: String!,
                                  timeZoneID tzID: String!,
                                  offset: NSNumber!,
                                  usesDST: Bool) {
    self.timeZone = timeZone
    timeZoneId = tzID
    timeZoneOffset = offset.doubleValue
    timeZoneUsesDST = usesDST
    tableView.reloadData()
    
    // Special case: Forced timezone selection; save immediately
    if !editMode {
      submitTimezone()
    }
    
    isTimezoneDirty = true
  }
  
  // MARK: SaveAddressDelegate
  
  func onSaveError() {
    hideGif()
    
    let description = NSLocalizedString("The address cannot be saved and/or verified. Please ensure your "
      + "address is correct and try again.", comment: "")
    let vc = ArcusPinkErrorTextModalViewController.create(
      NSLocalizedString("INVALID ADDRESS", comment: ""),
      description: description)
    
    navigationController?.popViewController(animated: true)
    navigationController?.present(vc, animated: true, completion: nil)
  }
  
  func onSaveSuccess(_ needsTimezoneUpdate: Bool, needsPermit: Bool) {
    hideGif()
    
    if isPro! && needsPermit {
      performSegue(withIdentifier: "segueToPermitRequired", sender: self)
    }
  }
  
  // MARK: VerifyAddressDelegate
  
  func onShowSuggestions(isPro: Bool,
                         isValid: Bool,
                         enteredAddress: [String:String],
                         suggestedAddresses: [[String:String]]) {
    hideGif()
    
    self.isPro = isPro
    self.isValid = isValid
    self.enteredAddress = enteredAddress
    self.suggestedAddresses = suggestedAddresses
    
    if (isValid) {
      savePresenter?.saveAddress(delegate: self, address: enteredAddress)
    } else {
      performSegue(withIdentifier: segueToVerifyAddress, sender: self)
    }
  }
  
  func onShowInvalidAddress(_ isPro: Bool) {
    hideGif()
    
    if (isPro) {
      let description = NSLocalizedString("The address cannot be saved and/or verified. Please assure "
        + "your address is correct and try again.", comment: "")
      let vc = ArcusPinkErrorTextModalViewController.create(NSLocalizedString("INVALID ADDRESS", comment: ""),
                                                           description: description)
      
      navigationController?.present(vc, animated: true, completion: nil)
    } else {
      performSegue(withIdentifier: segueToInvalidAddress, sender: self)
    }
  }
  
  func onShowProMonNotServiced() {
    hideGif()
    
    let vc = ProMonNoAgenciesViewController.create()
    navigationController?.present(vc, animated: true, completion: nil)
  }
  
  func onShowCantVerifyAddress() {
    hideGif()
    performSegue(withIdentifier: segueToCantVerify, sender: self)
  }
  
  func onShowProMonNotAvailable() {
    hideGif()
    
    let description = NSLocalizedString("Professional Monitoring is not currently offered at this address. "
      + ""
      + "change your address.", comment: "")
    let vc = ArcusPinkErrorTextModalViewController.create(
      NSLocalizedString("NOT AVAILABLE", comment: ""),
      description: description)
    
    // Reject changes; refresh screen with data from the model
    configureForm()
    configureTimeZoneInfo()
    tableView.reloadData()     // Refresh timezone changes
    
    navigationController?.present(vc, animated: true, completion: nil)
  }
}
