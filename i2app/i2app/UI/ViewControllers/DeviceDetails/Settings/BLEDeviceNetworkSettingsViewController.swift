//
//  BLEDeviceNetworkSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/12/18.
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
import Cornea

protocol BLEDeviceNetworkSettingsPresenter: ArcusWiFiCapability {
  var deviceModel: DeviceModel! { get set }

  var ssid: Variable<String> { get set }
  var signalStrengthImage: Variable<UIImage> { get set }

  var disposeBag: DisposeBag { get set }

  func getDeviceSSID()
  func getDeviceSignalStrength()
  func configureBindings()
}

extension BLEDeviceNetworkSettingsPresenter {
  func getDeviceSSID() {
    guard let wifiSSID = getWiFiSsid(deviceModel) else {
      return
    }
    ssid.value = wifiSSID
  }

  func getDeviceSignalStrength() {
    guard let wifiSignal = getWiFiRssi(deviceModel) else {
      return
    }
    let signal = Double(wifiSignal)
    signalStrengthImage.value = WiFiScanItem.imageForSignalStrength(signal)
  }
}

class BLEDeviceNetworkSettingsViewController: UIViewController, StoryboardCreatable, BLEDeviceNetworkSettingsPresenter {
  @IBOutlet weak var ssidLabel: ArcusLabel!
  @IBOutlet weak var signalStrengthImageView: UIImageView!

  // MARK: - StoryboardCreatable

  static var storyboardName: String = "DeviceDetails"
  static var storyboardIdentifier: String = "BLEDeviceNetworkSettingsViewController"

  // MARK: - BLECameraNetworkSettingsPresenter
  var deviceModel: DeviceModel! {
    didSet {
      getDeviceSSID()
      getDeviceSignalStrength()
    }
  }

  var ssid: Variable<String> = Variable("")
  var signalStrengthImage: Variable<UIImage> = Variable(WiFiScanItem.imageForSignalStrength(-150))

  var disposeBag: DisposeBag = DisposeBag()

  // MARK: - View Life Cycle

  static func create() -> BLEDeviceNetworkSettingsViewController {
    return createFromStoryboard() as! BLEDeviceNetworkSettingsViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navBar(withBackButtonAndTitle: navigationItem.title)
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    disposeBag = DisposeBag()
  }

  // MARK: - BLECameraNetworkSettingsPresenter

  func configureBindings() {
    ssid
      .asObservable()
      .bind(to: ssidLabel.rx.text)
      .disposed(by: disposeBag)

    signalStrengthImage
      .asObservable()
      .bind(to: signalStrengthImageView.rx.image)
      .disposed(by: disposeBag)
  }
}
