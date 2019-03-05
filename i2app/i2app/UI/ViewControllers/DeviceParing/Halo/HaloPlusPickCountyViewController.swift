//
//  HaloPlusPickCountyViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/1/16.
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

// We are using this view controller in both Pairing and Device Details/More
// The way we differentiate is by checking if self.step is nil (Device Detail/More) or not (Pairing)

class HaloPlusPickCountyViewController: BasePairingViewController, HaloSetupPresenterDelegate {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var setupRadioButton: ArcusButton!
    @IBOutlet weak var skipSetupButton: ArcusButton!

    var popupWindow: PopupSelectionWindow!

    var states: OrderedDictionary = [:]
    var counties: OrderedDictionary = [:]

    var selectedCode: String?

    let presenter: HaloSetupPresenter = HaloSetupPresenter()

    @objc class func create(_ device: DeviceModel) -> HaloPlusPickCountyViewController {
        let vc: HaloPlusPickCountyViewController = (UIStoryboard(name: "PairHalo", bundle: nil)
            .instantiateViewController(withIdentifier: "HaloPlusPickCountyViewController")
            as? HaloPlusPickCountyViewController)!

        vc.deviceModel = device

        return vc
    }

    class func createWithDevice(_ device: DeviceModel) -> HaloPlusPickCountyViewController {
        let vc: HaloPlusPickCountyViewController = (UIStoryboard(name: "DeviceDetailSettingHalo", bundle: nil)
            .instantiateViewController(withIdentifier: "HaloPlusPickCountyViewController")
            as? HaloPlusPickCountyViewController)!

        vc.deviceModel = device

        return vc
    }

    @objc class func createWithDeviceStep(_ step: PairingStep,
                                          device: DeviceModel) -> HaloPlusPickCountyViewController {
        let vc: HaloPlusPickCountyViewController = self.create(device)

        vc.setDeviceStep(step)

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.step == nil {
            self.setBackgroundColorToLastNavigateColor()
            self.addDarkOverlay(BackgroupOverlayLightLevel)
            self.navBar(withBackButtonAndTitle: "Choose your county")
        }

        // WHY?
        self.states = OrderedDictionary(objects: Constants.usStatesAbbreviated,
                                        forKeys: Constants.usStatesAbbreviated
                                          as [NSCopying])
        self.states.sortArray()


        // Set the initial state to the state and county in the current Place
        if let currentPlace: PlaceModel = RxCornea.shared.settings?.currentPlace,
          let state = PlaceCapability.getStateFrom(currentPlace) {
            self.doCloseStatePicker(state)
            if let county = PlaceCapability.getAddrCounty(from: currentPlace) {
                self.doCloseCountyPicker(county)
            }
        }
        DispatchQueue.global(qos: .background).async {
            self.presenter.getSameStatesList(self)
        }
    }

    @IBAction func selectStatePressed(_ sender: AnyObject) {
        let popupSelection =
            PopupSelectionTextPickerView.create(NSLocalizedString("STATES", comment: ""),
                                                list: self.states)
        popupSelection?.setCurrentKey(self.stateLabel.text)
        self.popupWindow =
            PopupSelectionWindow.popup(self.view,
                                       subview: popupSelection,
                                       owner: self,
                                       close: #selector(doCloseStatePicker(_:)))
    }

    func doCloseStatePicker(_ state: String) {
         if let index = self.states.allValues.index(where: {$0 as? String == state}) {
            if self.stateLabel.text != state {
                self.countyLabel.text = nil
            }

            self.stateLabel.text = self.states.allValues[index] as? String

             DispatchQueue.global(qos: .background).async {
                self.presenter.getSameCountiesList(state, delegate: self)
            }
        }
    }

    @IBAction func selectCountyPressed(_ sender: AnyObject) {
        let pickerView =
            PopupSelectionTextPickerView.create(NSLocalizedString("COUNTIES", comment: ""),
                                                list: self.counties)
        pickerView?.setCurrentKey(self.countyLabel.text)
        self.popupWindow =
            PopupSelectionWindow.popup(self.view,
                                       subview: pickerView,
                                       owner: self,
                                       close: #selector(doCloseCountyPicker(_:)))
    }

    func doCloseCountyPicker(_ county: String) {
        self.countyLabel.text = county

        DispatchQueue.global(qos: .background).async {
            self.presenter.getSameCode(self.stateLabel.text!, countyCode: county, delegate: self)
        }
    }

    @IBAction func setupWeatherRadioPressed(_ sender: AnyObject) {
        if self.selectedCode == nil || self.selectedCode?.characters.count == 0 {
            self.displayErrorMessage("You must select a state and a " +
                "county in order to identify the location for the weather radio.",
                                     withTitle:"Location Information")
            return
        } else {
            DispatchQueue.global(qos: .background).async {
                self.presenter.setNoaaLocation(self.selectedCode!,
                                               deviceModel: self.deviceModel,
                                               delegate: self)
            }
        }
    }

    @IBAction func skipWeatherRadioPressed(_ sender: AnyObject) {
        DevicePairingManager.sharedInstance().pairingWizard.skipNextPairingStep()
       super.nextButtonPressed(sender)
    }

    // Needed for Device Detail/More page
    override func back(_ sender: NSObject) {
        if self.step == nil && (self.selectedCode?.characters.count)! > 0 {
            self.createGif()
            DispatchQueue.global(qos: .background).async {
                self.presenter.setNoaaLocation(self.selectedCode!,
                                               deviceModel: self.deviceModel,
                                               delegate: self)
            }
        } else {
            self.navigationController!.popViewController(animated: true)
        }
    }
}

// MARK: - HaloSetupPresenterDelegate
extension HaloPlusPickCountyViewController {
    func getSameStates(_ states: OrderedDictionary) {
        self.states = states
    }
    func getSameCounties(_ counties: OrderedDictionary) {
        self.counties = counties
    }
    func getSameCode(_ code: String) {
        self.selectedCode = code
    }

    func setNoaaLocation(_ success: Bool) {
        DispatchQueue.main.async {
            self.hideGif()
            if success {
                if self.step != nil {
                    DevicePairingManager.sharedInstance().pairingWizard.createNextStepObject(true)
                } else {
                    self.navigationController!.popViewController(animated: true)
                }
            } else {
                self.displayGenericErrorMessage()
            }
        }
    }

}
