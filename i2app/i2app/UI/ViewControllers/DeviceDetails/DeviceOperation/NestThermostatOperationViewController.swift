//
//  NestThermostatOperationViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/13/17.
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

import Cornea

class NestThermostatOperationViewController: DeviceOperationBaseController {

  // MARK: IBOutlets

  @IBOutlet weak var thermostatControl: ArcusThermostatControl!

  // MARK: IBActions

  @IBAction func thermostatControlValueChanged(_ sender: Any) {
    if presenter.thermostatViewModel.mode == .auto {
      presenter.update(heatSetpoint: thermostatControl.viewModel.heatSetpoint)
      presenter.update(coolSetpoint: thermostatControl.viewModel.coolSetpoint)
    } else if thermostatControl.activeHandle == .heatHandle {
      presenter.update(heatSetpoint: thermostatControl.viewModel.heatSetpoint)
    } else {
      presenter.update(coolSetpoint: thermostatControl.viewModel.coolSetpoint)
    }
  }
  
  // MARK: Properties
  
  var presenter: NestThermostatOperationPresenterProtocol!
  var isDisplayingTempLock = false
  var isDisplayingUnauthorized = false
  var isDisplayingTimeout = false
  var isDisplayingDeviceRemoved = false

  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    thermostatControl.delegate = self

    presenter = NestThermostatOperationPresenter(delegate: self)
    presenter.fetchThermostatData()
    presenter.fetchNestThermostatData()
  }
  
  // MARK: DeviceOperationBaseController Overrides

  override func deviceWillAppear(_ animated: Bool) {
    super.deviceWillAppear(animated)

    isDisplayingUnauthorized = false
    isDisplayingTempLock = false
    isDisplayingTimeout = false
    isDisplayingDeviceRemoved = false
  }

  override static func create(withDeviceId deviceId: String) -> DeviceOperationBaseController {
    let controller = self.create()
    controller.deviceId = deviceId

    if let deviceModel = RxCornea.shared.modelCache?
      .fetchModel(DeviceModel.addressForId(deviceId)) as? DeviceModel {
      controller.deviceModel = deviceModel
    }

    return controller
  }

  override static func create() -> DeviceOperationBaseController {
    let storyboard = UIStoryboard(name: "DeviceOperation", bundle: nil)
    let viewController =
      storyboard.instantiateViewController(withIdentifier: "NestThermostatOperationViewController")

    if let viewController = viewController as? NestThermostatOperationViewController {
      return viewController
    }

    return DeviceOperationBaseController()
  }

  override func updateDeviceState(_ attributes: [AnyHashable : Any], initialUpdate isInitial: Bool) {
    presenter.fetchThermostatData()
    presenter.fetchNestThermostatData()
  }
  
  // MARK: Event Handlers

  func handleModePressed(_ selectedValue: Any) {
    if let mode = selectedValue as? ThermostatMode {
      presenter.update(selectedMode: mode)
    }
  }

  func handleCredentialsRevokedBanner() {
    performSegue(withIdentifier: "PresentNestCredentialsRevoked", sender: self)
  }

  func handleDeviceRemovedBanner() {
    performSegue(withIdentifier: "NestDeviceRemoved", sender: self)
  }
  
  func handleTimeoutBanner() {
    UIApplication.shared.open(NSURL.SupportNest)
  }
}

// MARK: CommonThermostatOperationPresenterDelegate

extension NestThermostatOperationViewController: CommonThermostatOperationPresenterDelegate {
  func updateThermostat() {

    // Display or Hide the temp lock banner. Arcust priority banner
    if presenter.thermostatViewModel.isTemperatureLocked &&
      !presenter.hasDeviceRemovedError &&
      !presenter.hasUnauthorizedError &&
      !presenter.hasTimeoutError &&
      !deviceModel.isDeviceOffline() {
      presentTempLockBanner()
    } else if isDisplayingTempLock {
      isDisplayingTempLock = false
      closePopupAlert(false)
    }

    // Display or hide the timeout banner. Do not present if there is an unauthorized or removed error.
    if presenter.hasTimeoutError &&
      !presenter.hasDeviceRemovedError &&
      !presenter.hasUnauthorizedError &&
      !deviceModel.isDeviceOffline() {
      presentTimeoutBanner()
      setFooterToPink(true)
    } else if isDisplayingTimeout &&
      !presenter.hasDeviceRemovedError &&
      !presenter.hasUnauthorizedError &&
      !presenter.thermostatViewModel.isTemperatureLocked {
      isDisplayingTimeout = false
      closePopupAlert(false)
      setFooterToPink(false)
    }
    
    // Display or hide the unauthorized banner
    if presenter.hasUnauthorizedError &&
      !presenter.hasDeviceRemovedError &&
      !deviceModel.isDeviceOffline() {
      presentUnauthorizedBanner()
      setFooterToPink(true)
    } else if isDisplayingUnauthorized &&
      !presenter.hasTimeoutError &&
      !presenter.hasDeviceRemovedError &&
      !presenter.thermostatViewModel.isTemperatureLocked {
      isDisplayingUnauthorized = false
      closePopupAlert(false)
      setFooterToPink(false)
    }
    
    // Display or hide the device removed banner
    if presenter.hasDeviceRemovedError &&
      !deviceModel.isDeviceOffline() {
      presentDeviceRemovedBanner()
      setFooterToPink(true)
    } else if isDisplayingDeviceRemoved &&
      !presenter.hasTimeoutError &&
      !presenter.hasUnauthorizedError &&
      !presenter.thermostatViewModel.isTemperatureLocked {
      isDisplayingDeviceRemoved = false
      closePopupAlert(false)
      setFooterToPink(false)
    }

    // Check for device offline
    if deviceModel.isDeviceOffline() {
      setFooterToPink(true)
    } else if !presenter.hasUnauthorizedError &&
      !presenter.hasTimeoutError &&
      !presenter.hasDeviceRemovedError {
      setFooterToPink(false)
    }

    // Update the thermostat control for any new values
    thermostatControl.updateThermostatControl(presenter.thermostatViewModel)
  }

  private func presentTimeoutBanner() {
    if isCenterMode() && !isDisplayingTimeout {
      isDisplayingTimeout = true

      // close any previously opened alerts
      isDisplayingTempLock = false

      popupLinkAlert(presenter.timeoutBannerText(),
                     type: AlertBarType.typeWarning,
                     sceneType: AlertBarSceneType.inDevice,
                     grayScale: true,
                     linkText: "Get Support",
                     selector: #selector(handleTimeoutBanner),
                     displayArrow: true)
    }
  }
  
  private func presentDeviceRemovedBanner() {
    if isCenterMode() && !isDisplayingDeviceRemoved {
      isDisplayingDeviceRemoved = true
      
      // close any previously opened alerts
      isDisplayingTempLock = false
      isDisplayingTimeout = false
      
      popupLinkAlert(presenter.deviceRemovedBannerText(),
                     type: AlertBarType.typeWarning,
                     sceneType: AlertBarSceneType.inDevice,
                     grayScale: true,
                     linkText: "hidden_text",
                     selector: #selector(handleDeviceRemovedBanner),
                     displayArrow: true)
    }
  }

  private func presentUnauthorizedBanner() {
    if isCenterMode() && !isDisplayingUnauthorized {
      isDisplayingUnauthorized = true

      // close any previously opened alerts
      isDisplayingTempLock = false
      isDisplayingTimeout = false
      isDisplayingDeviceRemoved = false

      popupLinkAlert(presenter.unauthorizedBannerText(),
                     type: AlertBarType.typeWarning,
                     sceneType: AlertBarSceneType.inDevice,
                     grayScale: true,
                     linkText: "hidden_text",
                     selector: #selector(handleCredentialsRevokedBanner),
                     displayArrow: true)
    }
  }

  private func presentTempLockBanner() {
    if isCenterMode() && !isDisplayingTempLock {
      isDisplayingTempLock = true
      popupAlert(presenter.lockBannerText(), type: AlertBarType.typeLockWhite, canClose: false, under: 108)
    }
  }
}

// MARK: ArcusThermostatControlDelegate

extension NestThermostatOperationViewController: ArcusThermostatControlDelegate {
  func modeButtonPressed(_ arcusThermostatControl: ArcusThermostatControl) {
    var buttons = [PopupSelectionButtonModel]()

    for mode in presenter.modesAvailable {
      var title = mode.title()

      if mode == .auto {
        title = NSLocalizedString("HEAT ● COOL", comment: "")
      }

      buttons.append(PopupSelectionButtonModel.create(title,
                                                      event: #selector(handleModePressed),
                                                      obj: mode))
    }

    let buttonView = PopupSelectionButtonsView.create(
      withTitle: NSLocalizedString("Choose A Mode", comment: ""), buttons: buttons)
    buttonView?.owner = self

    popup(buttonView)
  }

  func interactionStarted(_ arcusThermostatControl: ArcusThermostatControl) {
      deviceController.enableSwipe = false
  }

  func interactionEnded(_ arcusThermostatControl: ArcusThermostatControl) {
      deviceController.enableSwipe = true
  }
}
