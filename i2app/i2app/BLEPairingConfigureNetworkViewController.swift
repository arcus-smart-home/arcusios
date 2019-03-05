//
//  BLEPairingConfigureNetworkViewController.swift
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
import Cornea
import RxSwift
import RxSwiftExt
import RxCocoa
import CoreBluetooth

struct BLEPairingConnectingStrings {
  static let connectingTitle: String = "Connecting"
  static let connectingDescription: String = "It is normal for the device to reboot during this process "
    + "and may take a few minutes to pair to Arcus."
  static let connectingWifi: String = "Setting up Wi-Fi"
  // swiftlint:disable:next line_length
  static let connectingArcus: String = "Connecting to Arcus Cloud Platform\n\nThis may take 5-10 minutes depending on the speed of your internet connection."
}

class BLEPairingConfigureNetworkViewController: UIViewController, ArcusBLEConfigureNetworkPresenter,
  HubBLEInstructionable {
  
  @IBOutlet weak var ssidTextField: ScleraTextField!
  @IBOutlet weak var keyTextField: ScleraTextField!
  @IBOutlet weak var showHideKeySwitch: UISwitch!

  // MARK: - PairingStepsPresenter
  var step: ArcusPairingStepViewModel?
  var presenter: BLEPairingPresenterProtocol?

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK: - ArcusBLEPairingClient

  // swiftlint:disable:next line_length
  var bleClient: (ArcusBLEAvailability & ArcusBLEWiFiConfigurable & ArcusBLEConfigurable & ArcusBLEPairable & ArcusBLEConnectable)!
  var disposeBag: DisposeBag = DisposeBag()

  var backSubjectDisposeBag: DisposeBag = DisposeBag()

  // MARK: - ArcusBLEConfigureNetworkPresenter

  var isManualConfig: Variable<Bool> = Variable(false)
  var networkKey: Variable<String?> = Variable(nil)
  var deviceSerial: Variable<String?> = Variable(nil)
  var isBLEAvailableSegueObserver: Disposable?
  var isBLEConnectedSegueObserver: Disposable?
  var attemptPairingObserver: Disposable?

  // MARK - Constructor

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: BLEPairingPresenterProtocol) -> BLEPairingConfigureNetworkViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingConfigureNetworkViewController")
      as? BLEPairingConfigureNetworkViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        // swiftlint:disable:next line_length
        let client = step.config as? (ArcusBLEAvailability & ArcusBLEWiFiConfigurable & ArcusBLEConfigurable & ArcusBLEPairable & ArcusBLEConnectable) {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }

  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if let presenterDelegate = presenter?.customStepDelegate {
      customStepDelegate = presenterDelegate
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if presentedViewController == nil {
      disposeBag = DisposeBag()
    }
  }

  // MARK: UI Configuration

  func configureBindings() {
    disposeBag = DisposeBag()

    customStepDelegate?.pagingEnabled.value = true

    bleClient.selectedNetwork
      .asObservable()
      .map { network in
        return network == nil
      }
      .bind(to: isManualConfig)
      .disposed(by: disposeBag)

    bindBLEAvailability()

    bindConnectedDevice()

    bindSSIDTextField()

    bindKeyTextField()

    bindShowPasswordSwitch()

    bindAttemptPairing()

    bindPagingDelegate()
  }

  private func bindBLEAvailability() {
    isBLEAvailableSegueObserver = bleClient.isBLEAvailable()
      .shareReplay(1)
      .filter { available in
        return available == false
      }
      .subscribe(onNext: { [weak customStepDelegate] _ in
        let segueIdentifier = PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue
        customStepDelegate?.showPopupWithSegue(segueIdentifier)
      })

    isBLEAvailableSegueObserver?.disposed(by: disposeBag)
  }

  func bindConnectedDevice() {
    guard bleClient.connectedDevice.value != nil else { return }

    isBLEConnectedSegueObserver = bleClient.connectedDevice
      .asObservable()
      .filter { bleDevice in
        return bleDevice == nil
      }
      .take(1)
      .subscribe(onNext: { [weak customStepDelegate] _ in
        let segue = PairingStepSegues.segueToBLEConnectionLostErrorPopOver.rawValue
        customStepDelegate?.showPopupWithSegue(segue)
      })
    isBLEConnectedSegueObserver?.disposed(by: disposeBag)
  }

  /**
   Private method used to bind `config.ssid` to `ssidTextField`.
   */
  private func bindSSIDTextField() {
    ssidTextField.rx.text
      .orEmpty
      .bind(to: networkKey)
      .disposed(by: disposeBag)

    isManualConfig
      .asObservable()
      .bind(to: ssidTextField.rx.isEnabled)
      .disposed(by: disposeBag)

    isManualConfig
      .asObservable()
      .subscribe(onNext: { [unowned self] isManual in
        self.ssidTextField.textColor = isManual ? UIColor.black : UIColor.gray.withAlphaComponent(0.6)
      })
      .disposed(by: disposeBag)

    bleClient.selectedNetwork
      .asObservable()
      .subscribe(onNext: { [unowned self] network in
        self.ssidTextField.text = network?.ssid
      })
      .disposed(by: disposeBag)
  }

  /**
   Private method used to bind `config.key` to `keyTextField`.
   */
  private func bindKeyTextField() {
    keyTextField.rx.text
      .orEmpty
      .bind(to: networkKey)
      .disposed(by: disposeBag)
  }

  /**
   Private method used to bind the inverse `showKeySwitch.value` to the `keyTextField.isSecureTextEntry`
   property.
   */
  private func bindShowPasswordSwitch() {
    showHideKeySwitch.rx.value
      .shareReplay(1)
      .map {
        !$0
      }
      .bind(to: keyTextField.rx.isSecureTextEntry)
      .disposed(by: disposeBag)
  }

  func bindAttemptPairing() {
    bleClient.configStatus.value = .intial
    attemptPairingObserver?.dispose()
    guard let delegate = customStepDelegate else { return }
    attemptPairingObserver = delegate.shouldAttemptPairing
      .asObservable()
      .filterMap { [unowned self] shouldAttempt in
        guard shouldAttempt == true else { return .ignore }

        return self.validateAttempt()
      }
      .do(onNext: { [unowned self] _ in
        self.showConnectingPopup()
        self.isBLEConnectedSegueObserver?.dispose()
      })
      .flatMap { [unowned self] (network, key) in
        return self.configureDeviceForPairing(network, key: key)
      }
      .filterMap { [unowned self] status in
        return self.filterMapConfigStatus(status)
      }
      .take(1)
      .flatMap { [unowned self] serial in
        return self.bleClient.pairBLEDevice(serial)
      }
      .delay(5.0, scheduler: MainScheduler.asyncInstance)
      .flatMap { [unowned self] _ in
        return self.stopPairing()
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: {  [weak delegate] _ in
        delegate?.customPairingCompleted()
      }, onError: { [unowned self, weak delegate] error in
        let errorSegue = self.handlePairingError(error)
        delegate?.showPopupWithSegue(errorSegue)
        delegate?.shouldAttemptPairing.value = false
        self.bindAttemptPairing()
        self.bindConnectedDevice()
      })
      attemptPairingObserver?.disposed(by: disposeBag)
  }

  private func bindPagingDelegate() {
    guard let pagingDelegate = customStepDelegate else { return }

    pagingDelegate.stepsMovedBackSubject
      .asObservable()
      .subscribe(onNext: { [unowned self] index in
        guard let step = self.step as? CustomPairingStepViewModel,
          step.order == index else {
            return
        }

        // Reset current state.
        self.disposeBag = DisposeBag()
        self.keyTextField.text = nil
        self.networkKey.value = nil
        self.deviceSerial.value = nil
        self.bleClient.availableNetworks.value = []
        self.bleClient.selectedNetwork.value = nil
      })
      .disposed(by: backSubjectDisposeBag)
  }

  // MARK: - Pairing Convenience Methods

  func configureDeviceForPairing(_ network: WiFiScanItem,
                                       key: String) -> Observable<BLEPairingConfigStatus> {
    return bleClient.getDeviceSerial()
      .asObservable()
      .do(onNext: { [unowned self] serial in
        self.deviceSerial.value = serial
      })
      .flatMap { [unowned self] _ in
        return self.bleClient.configureWifiNetwork(network, networkKey: key)
      }
      .flatMap { [unowned self] _ in
        return self.pollConfigStatusWithTimeout(3.0, timeout: 120)
      }
      .flatMap { [unowned self] _ in
        return self.bleClient.getDeviceConfigStatus()
      }
      .validateStatus(bleClient.ipcdDeviceType)
  }

  func pollConfigStatusWithTimeout(_ interval: TimeInterval, timeout: TimeInterval) -> Observable<Int> {
    return Observable<Int>.interval(interval, scheduler: MainScheduler.instance)
      .map { count in
        if (Double(count) * interval) > timeout {
          throw BLEPairingError(errorType: .noInternet)
        }
        return count
    }
  }

  func showConnectingPopup() {
    customStepDelegate?.loadingTitle.value = BLEPairingConnectingStrings.connectingTitle
    customStepDelegate?.loadingStatus.value = BLEPairingConnectingStrings.connectingDescription
    customStepDelegate?.showPopupWithSegue(PairingStepSegues.segueToBLELoadingPopOver.rawValue)
  }

  func validateAttempt() -> FilterMap<(WiFiScanItem, String)> {
    let key = keyTextField.text ?? ""

    guard let network = bleClient.selectedNetwork.value else {
      if self.isManualConfig.value == true, let ssid = ssidTextField.text {
        let network = WiFiScanItem(ssid: ssid, security: "None", channel: 0, signal: 0)
        return .map((network, key))
      }
      return .ignore
    }
    return .map((network, key))
  }

  func filterMapConfigStatus(_ status: BLEPairingConfigStatus) -> FilterMap<String> {
    guard status == .connected, let serial = self.deviceSerial.value else {
      return .ignore
    }
    return .map(serial)
  }

  func stopPairing() -> Single<Void> {
    guard let presenter = self.presenter else {
      return Single<Void>.create { single in
        single(.error(ClientError()))
        return Disposables.create()
      }
    }

    return presenter.finalizeCustomPairing()
  }

  func handlePairingError(_ error: (Error)) -> String {
    if let error = error as? BLEPairingError {
      return error.popupSegueIdentifier().rawValue
    } else if let error = error as? ClientError {
      if error.code == "request.destination.notfound" {
        // If the Device was not found, show Device Not Found Error.
        return PairingStepSegues.segueToBLEDeviceNotFoundErrorPopover.rawValue
      } else if error.code == "request.invalid" {
        // If the Device has already been claimed, show Already Claimed Error.
        return PairingStepSegues.segueToBLEDeviceClaimedErrorPopover.rawValue
      }
    }
    return PairingStepSegues.segueToBLECheckWifiErrorPopover.rawValue
  }
}
