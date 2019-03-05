//  HoneywellC2CThermostatOperationViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/12/17.
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

class HoneywellC2CThermostatOperationViewController: DeviceOperationBaseController {

  // MARK: IBOutlets

  @IBOutlet weak var thermostatControl: ArcusThermostatControl!

  // MARK: IBActions

  @IBAction func thermostatSliderValueChanged(_ sender: Any) {
    if presenter.thermostatViewModel.mode == .auto {
      presenter.update(heatSetpoint: thermostatControl.viewModel.heatSetpoint)
      presenter.update(coolSetpoint: thermostatControl.viewModel.coolSetpoint)

      deviceModel.addNewEventForAttribute(kAttrThermostatCoolsetpoint)
      deviceModel.addNewEventForAttribute(kAttrThermostatHeatsetpoint)
    } else if thermostatControl.activeHandle == .heatHandle {
      presenter.update(heatSetpoint: thermostatControl.viewModel.heatSetpoint)
      deviceModel.addNewEventForAttribute(kAttrThermostatHeatsetpoint)
    } else {
      presenter.update(coolSetpoint: thermostatControl.viewModel.coolSetpoint)
      deviceModel.addNewEventForAttribute(kAttrThermostatCoolsetpoint)
    }

    checkForWaiting()
  }

  // MARK: Properties

  var presenter: GenericThermostatOperationPresenterProtocol!
  var isWaiting = false

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    thermostatControl.delegate = self

    presenter = GenericThermostatOperationPresenter(delegate: self)
    presenter.fetchThermostatData()
  }

  // MARK: DeviceOperationBaseController Overrides

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
      storyboard.instantiateViewController(withIdentifier: "HoneywellC2CThermostatOperationViewController")

    if let viewController = viewController as? HoneywellC2CThermostatOperationViewController {
      return viewController
    }

    return DeviceOperationBaseController()
  }

  override func updateDeviceState(_ attributes: [AnyHashable : Any], initialUpdate isInitial: Bool) {
    checkForWaiting()
    presenter.fetchThermostatData()

    if deviceModel.isDeviceOffline() {
      setFooterToPink(true)
    } else {
      setFooterToPink(false)
    }
  }

  // MARK: Event Handlers

  func handleModePressed(_ selectedValue: Any) {
    if let mode = selectedValue as? ThermostatMode {
      if mode != presenter.thermostatViewModel.mode {
        presenter.update(selectedMode: mode)
        deviceModel.addNewEventForAttribute(kAttrThermostatHvacmode)

        checkForWaiting()
      }
    }
  }

  // MARK: Helpers

  func checkForWaiting() {
    let duration = deviceModel.clearStaleEventsAndReturnLongestDuration(120)

    if duration > 0 {
      let deadline = DispatchTime.now() + .milliseconds(500)

      DispatchQueue.main.asyncAfter(deadline: deadline) {
        self.displayWaiting()
      }
    } else {
      dismissWaiting()
    }
  }

  func displayWaiting() {
    if !isWaiting {
      isWaiting = true
      
      setFooterSideText(NSLocalizedString("Waiting on ", comment: ""))
      popupLinkAlert(NSLocalizedString("Just a moment...", comment: ""),
                     type: AlertBarType.typeWaiting,
                     sceneType: AlertBarSceneType.inDevice,
                     grayScale: true,
                     linkText: nil,
                     selector: nil,
                     displayArrow: false)
    }
  }

  func dismissWaiting() {
    if isWaiting {
      setFooterSideText(nil)
      closePopupAlert(true)

      isWaiting = false
    }
  }
}

// MARK: CommonThermostatOperationPresenterDelegate

extension HoneywellC2CThermostatOperationViewController: CommonThermostatOperationPresenterDelegate {
  func updateThermostat() {
    thermostatControl.updateThermostatControl(presenter.thermostatViewModel)
  }
}

// MARK: ArcusThermostatControlDelegate

extension HoneywellC2CThermostatOperationViewController: ArcusThermostatControlDelegate {
  func modeButtonPressed(_ arcusThermostatControl: ArcusThermostatControl) {
    var buttons = [PopupSelectionButtonModel]()

    for mode in presenter.modesAvailable {
      buttons.append(PopupSelectionButtonModel.create(mode.title(),
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
