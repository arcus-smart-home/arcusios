//
//  GenericThermostatOperationViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/25/17.
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

class GenericThermostatOperationViewController: DeviceOperationBaseController {

  // MARK: IBOutlets

  @IBOutlet weak var nextEvent: ArcusLabel!
  @IBOutlet weak var thermostatControl: ArcusThermostatControl!

  // MARK: IBActions

  @IBAction func thermostatSliderValueChanged(_ sender: Any) {
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
  
  var presenter: GenericThermostatOperationPresenterProtocol!
  
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
      storyboard.instantiateViewController(withIdentifier: "GenericThermostatOperationViewController")

    if let viewController = viewController as? GenericThermostatOperationViewController {
      return viewController
    }

    return DeviceOperationBaseController()
  }

  override func updateDeviceState(_ attributes: [AnyHashable : Any], initialUpdate isInitial: Bool) {
    presenter.fetchThermostatData()
    
    if let eventText = presenter.nextEventText() {
      nextEvent.attributedText = eventText
      nextEvent.isHidden = false
    } else {
      nextEvent.isHidden = true
    }
  }
  
  // MARK: Event Handlers

  func handleModePressed(_ selectedValue: Any) {
    if let mode = selectedValue as? ThermostatMode {
      presenter.update(selectedMode: mode)
    }
  }
}

// MARK: CommonThermostatOperationPresenterDelegate

extension GenericThermostatOperationViewController: CommonThermostatOperationPresenterDelegate {
  func updateThermostat() {
    thermostatControl.updateThermostatControl(presenter.thermostatViewModel)
  }
}

// MARK: ArcusThermostatControlDelegate

extension GenericThermostatOperationViewController: ArcusThermostatControlDelegate {
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
