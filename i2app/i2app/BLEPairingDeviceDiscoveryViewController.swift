//
//  BLEPairingDeviceDiscoveryViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/17/18.
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
import RxSwift
import RxSwiftExt
import RxCocoa
import CoreBluetooth
import Cornea

class BLEPairingDeviceDiscoveryViewController: UIViewController,
  StoryboardCreatable,
  HubBLEInstructionable {

  @IBOutlet weak var chooseDeviceLabel: UILabel!
  @IBOutlet weak var searchingLabel: UILabel!
  @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var dontSeeYourBluetoothDevice: UIView!
  @IBOutlet weak var tableView: UITableView!

  static var storyboardName: String = DeviceBLEPairingStoryboardName
  static var storyboardIdentifier: String = "BLEPairingDeviceDiscoveryViewController"

  // MARK: - PairingStepsPresenter
  var step: ArcusPairingStepViewModel?
  var presenter: BLEPairingPresenterProtocol?

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK: - ArcusBLEPairingClient
  var bleClient: (ArcusBLEAvailability & ArcusBLEScannable & ArcusBLEConnectable & ArcusBLEPairable)!
  var disposeBag: DisposeBag = DisposeBag()

  var hasConnected: Variable<Bool> = Variable(false)
  var backSubjectDisposeBag: DisposeBag = DisposeBag()

  // MARK - Constructor

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: BLEPairingPresenterProtocol) -> BLEPairingDeviceDiscoveryViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingDeviceDiscoveryViewController")
      as? BLEPairingDeviceDiscoveryViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let client = step.config as? (ArcusBLEAvailability & ArcusBLEScannable & ArcusBLEConnectable & ArcusBLEPairable) {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }

  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set ipcdDeviceType on PairingStepsParentViewController.
    presenter?.customStepDelegate.ipcdDeviceType = bleClient.ipcdDeviceType

    if let presenterDelegate = presenter?.customStepDelegate {
      customStepDelegate = presenterDelegate
    }

    if let deviceShortName = customStepDelegate?.deviceShortName {
      chooseDeviceLabel.text =
        chooseDeviceLabel.text?.replacingOccurrences(of: "<ShortName>",
                                                     with: deviceShortName)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    bleClient.disconnect()
    configureBindings()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    bindNextButton()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if presentedViewController == nil {
      // Dispose of existing subscriptions.
      disposeBag = DisposeBag()

      // Stop scanning.
      bleClient.stopScan()

      // Prevent Connection Failed Popup when returning here from a previous error.
      hasConnected.value = false
    }
  }

  // MARK: UI Configuration

  func configureBindings() {
    disposeBag = DisposeBag()

    bindPagingDelegate()

    bindTableView()

    bindSearchingIndicator()

    bindDontSeeYourBluetoothDevice()
  }

  private func bindSearchingIndicator() {
    searchingIndicator.startAnimating()

    bleClient.isScanning
      .asObservable()
      .bind(to: searchingIndicator.rx.isAnimating)
      .disposed(by: disposeBag)

    bleClient.isScanning
      .asObservable()
      .inverse()
      .bind(to: searchingLabel.rx.isHidden)
      .disposed(by: disposeBag)
  }

  private func bindNextButton() {
    guard let delegate = customStepDelegate else { return }

    bleClient.connectedDevice
      .asObservable()
      .map { bleDevice in
        return bleDevice != nil
      }
      .bind(to: delegate.pagingEnabled)
      .disposed(by: disposeBag)
  }

  private func bindDontSeeYourBluetoothDevice() {
    dontSeeYourBluetoothDevice.isHidden = true
    let timer = Observable<Int>.timer(30, scheduler: MainScheduler.asyncInstance)
    timer.subscribe(onNext: { [weak self] _ in
      self?.dontSeeYourBluetoothDevice.isHidden = false
    })
    .disposed(by: disposeBag)
  }

  private func bindPagingDelegate() {
    guard let delegate = customStepDelegate else { return }

    bleClient.connectedDevice
      .asObservable()
      .filterMap { bleDevice in
        return bleDevice != nil ? .map(true) : .ignore
      }
      .bind(to: hasConnected)
      .disposed(by: disposeBag)

    bleClient.connectedDevice
      .asObservable()
      .filter { [unowned self] bleDevice in
        return bleDevice == nil && self.hasConnected.value == true
      }
      .subscribe(onNext: { [unowned self, weak delegate] _ in
        self.hasConnected.value = false
        let segue = PairingStepSegues.segueToBLEConnectionLostErrorPopOver.rawValue
        delegate?.showPopupWithSegue(segue)
      })
      .disposed(by: disposeBag)

    delegate.stepsMovedBackSubject
      .asObservable()
      .delay(0.1, scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self, weak delegate] index in
        guard let step = self.step as? CustomPairingStepViewModel,
          step.order == index || step.order == index - 1 else {
          return
        }

        // Reset current state.
        self.hasConnected.value = false

        if step.order == index {
          self.bleClient.disconnect()
          self.bleClient.stopScan()
          self.bleClient.discoveredDevices.value = []
          self.disposeBag = DisposeBag()
          delegate?.pagingEnabled.value = true
        } else {
          self.configureBindings()
        }
      })
      .disposed(by: backSubjectDisposeBag)

    bleClient.isBLEAvailable()
      .shareReplay(1)
      .filter { available in
        return available == false
      }
      .subscribe(onNext: { [weak delegate] _ in
        let segueIdentifier = PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue
        delegate?.showPopupWithSegue(segueIdentifier)
      })
      .disposed(by: disposeBag)
  }

  private func bindTableView() {
    // Scan for BLE Devices, and bind to TableView.
    bleClient.scanForBLEDevices()
      .bind(to: tableView.rx
        .items(cellIdentifier: "cell",
               cellType: BLEDeviceTableViewCell.self)) {
                (_, model: ArcusBLEViewModel, cell: BLEDeviceTableViewCell) in
                cell.nameLabel.text = model.name
      }
      .disposed(by: disposeBag)

    // Bind BLE Device Cell Selection.
    tableView.rx.itemSelected
      .asObservable()
      .do(onNext: { [weak delegate = customStepDelegate] indexPath in
        // Display connecting popup.
        delegate?.loadingTitle.value = BLEPairingConnectingStrings.connectingTitle
        delegate?.loadingStatus.value = ""
        delegate?.showPopupWithSegue(PairingStepSegues.segueToBLELoadingPopOver.rawValue)
      })
      .map { [unowned self] indexPath in
        // Get the device for the selected cell.
        return self.bleClient.discoveredDevices.value[indexPath.row]
      }
      .flatMap { [unowned self] bleModel in
        // Attempt to connect to the selected device.
        return self.bleClient.connect(bleModel)
      }
      .delay(0.5, scheduler: MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [unowned self] _ in
          // Dismiss the connecting popup.
          self.customStepDelegate?.dismissPopup(nil)
        },
        onError: { [weak delegate = customStepDelegate] error in
          guard let error = error as? BLEPairingError else { return }
          delegate?.showPopupWithSegue(error.popupSegueIdentifier().rawValue)
      })
    .disposed(by: disposeBag)
  }

  // MARK - IBActions

  @IBAction func needHelpButtonPressed(_ sender: AnyObject) {
    guard let shortName = customStepDelegate?.deviceShortName else { return }

    if shortName == Constants.wifiCameraShortName {
      UIApplication.shared.open(NSURL.SupportSwannCameraNeedHelp)
    } else if shortName == Constants.wifiPlugShortName {
      if self.bleClient.ipcdDeviceType == Constants.V1DeviceType.greatStarIndoorPlug {
        UIApplication.shared.open(NSURL.SupportGsIndoorBleNeedHelp)
      } else {
        UIApplication.shared.open(NSURL.SupportGsOutdoorBleNeedHelp)
      }
    } else if shortName == Constants.hubDeviceName {
      UIApplication.shared.open(NSURL.SupportV3HubBLENeedHelp)
    }
  }
}
