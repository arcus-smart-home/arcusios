//
//  WSSPairingExternalSettingsViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/13/16.
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
import CocoaLumberjack
import RxSwift

@objc class WSSPairingExternalSettingsViewController: BaseDeviceStepViewController,
  UITextViewDelegate,
  SwannSmartSwitchPairingDelegate,
IPCDServiceDelegate {
  @IBOutlet var textView: UITextView!
  @IBOutlet var needHelpButton: ArcusButton!

  var pairingClient: SwannSmartSwitchPairingClient?
  var ipcdServicerController: IPCDServiceController?
  var attemptPairing: Bool = false
  var devicePaired: Bool = false
  var existingSwitches: [DeviceModel] = []

  var disposeBag: DisposeBag = DisposeBag()

  internal var ssid: String = ""
  internal var key: String = ""
  var macAddress: String = ""

  var popupWindow: PopupSelectionWindow?

  var ipcdRetryCount: Int = 12

  // MARK: View LifeCycle
  class func create() -> WSSPairingExternalSettingsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "PairDevice", bundle:nil)
    let viewController: WSSPairingExternalSettingsViewController? =
      storyboard
        .instantiateViewController(
          withIdentifier: String(describing: WSSPairingExternalSettingsViewController.self))
        as? WSSPairingExternalSettingsViewController

    return viewController!
  }

  class func create(_ pairingStep: PairingStep) -> WSSPairingExternalSettingsViewController {
    let viewController: WSSPairingExternalSettingsViewController =
      WSSPairingExternalSettingsViewController.create()
    viewController.setDeviceStep(pairingStep)

    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let devices = RxCornea.shared.modelCache?
      .fetchModels(Constants.deviceNamespace) as? [DeviceModel] {
      existingSwitches = devices.filter { $0.productId == self.step.productCatalog.productId }
    }

    if let session = RxCornea.shared.session as? RxSwiftSession {
      observeSessionState(session)
    }

    // TODO: Update to use ArcusApplicationServiceProtocol
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(applicationEnteredBackgroundNotificationReceived(_:)),
                   name: Notification.Name.UIApplicationDidEnterBackground,
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(deviceAddedEventReceived(_:)),
                   name: Notification.Name.modelAdded,
                   object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureNavBar()
    configureBackground()
    configureHelpButton()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    if ipcdServicerController != nil {
      ipcdServicerController?.stopPairing()
      ipcdServicerController = nil
    }
  }

  // MARK: UI Configuration
  func configureNavBar() {
    navBar(withBackButtonAndTitle: navigationItem.title)
  }

  func configureBackground() {
    setBackgroundColorToDashboardColor()
    addWhiteOverlay(BackgroupOverlayMiddleLevel)
  }

  func configureHelpButton() {
    let title = "Need Help?"
    let font = needHelpButton.titleLabel!.font
    let attributes = [NSFontAttributeName: font!,
                      NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]

    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString(string: title,
                                attributes: attributes)
    needHelpButton.setAttributedTitle(attributedString, for: UIControlState())
  }

  // MARK: Notification Handling
  func deviceAddedEventReceived(_ notification: Notification) {
    DispatchQueue.main.async(execute: {
      if let addedDevice = notification.object as? DeviceModel {
        let addedProductId = DeviceCapability.getProductId(from: addedDevice)
        if addedProductId != nil && self.step?.productCatalog != nil {
          let filteredSwitches: [DeviceModel] = self.existingSwitches.filter { $0.address == addedDevice.address }
          if self.step.productCatalog.productId == addedProductId && filteredSwitches.count == 0 {
            if self.devicePaired == false {
              self.hideGif()
              DevicePairingManager.sharedInstance().currentDevice = addedDevice
              DevicePairingManager.sharedInstance().justPairedDevices.add(addedDevice)
              DevicePairingManager.sharedInstance().currentDevice = addedDevice
              super.nextButtonPressed(self)
              self.devicePaired = true

              // Allow app level routing once device is paired.
              CorneaController.suspendRouting(false)
            }
          }
        }
      }
    })
  }

  func applicationEnteredBackgroundNotificationReceived(_ notification: Notification) {
    if attemptPairing == false {
      beginPairingAttempt()
    }
  }

  // MARK: IBActions
  @IBAction override func nextButtonPressed(_ sender: Any) {

    var showConnectionPopup = false

    if attemptPairing == true {
      pairingClient = SwannSmartSwitchPairingClient(delegate: self)
      showConnectionPopup = true
    } else if macAddress.count > 0 {
      attemptPairing = true
      showConnectionPopup = true
      beginPairingWithMacAddress(macAddress)
    }

    if showConnectionPopup == true {
      createGif()

      let title = NSLocalizedString("Connecting", comment: "")
      let subtitle = NSLocalizedString("Please be patient while the device pairs to Arcus." +
        "\nThis device may take several minutes to pair.",
                                       comment: "")
      displayPopUp(title,
                   subtitle: subtitle,
                   error: false)
    }
  }

  @IBAction func settingsLabelPressed(_ sender: AnyObject) {
    let settingsUrl = URL(string: "App-Prefs:")
    if let url = settingsUrl {
      beginPairingAttempt()
      UIApplication.shared.openURL(url)
    }
  }

  @IBAction func needHelpPressed(_ sender: AnyObject) {
    UIApplication.shared.openURL(NSURL.SupportWifiSmartSwitch)
  }

  override func back(_ sender: NSObject!) {
    // Allow app level routing to resume.
    CorneaController.suspendRouting(false)

    // Reconnect the suspended session.
    RxCornea.shared.session?.resume()

    super.back(sender)
  }

  func beginPairingAttempt() {
    attemptPairing = true

    // Prevent the app from routing away from this VC while attempting pairing.
    CorneaController.suspendRouting(true)

    // Disconnect the session's socket, but prevent session from becoming inaactive.
    RxCornea.shared.session?.suspend()

    // Prevent the DevicePairingManager from hi-jacking the pairing
    // process by setting it to ignore added devices.
    DevicePairingManager.sharedInstance().ignoreDeviceAdded = true
  }

  func beginPairingWithMacAddress(_ mac: String) {
    if mac.count > 0 {
      if ipcdServicerController != nil {
        ipcdServicerController?.stopPairing()
        ipcdServicerController = nil
      }

      let attributes: [AnyHashable: Any] = ["IPCD:sn": mac,
                                            "IPCD:v1devicetype": "other"]

      ipcdServicerController = IPCDServiceController(target: step.target,
                                                     attributes: attributes)
      ipcdServicerController?.delegate = self
      ipcdServicerController?.timeout = 15
      ipcdServicerController?.startPairing()
    }
  }

  // MARK: Popup Handling
  func displayPopUp(_ title: String, subtitle: String, error: Bool) {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }

    if error == true {
      let contactSupportSelectionModel: PopupSelectionButtonModel =
        PopupSelectionButtonModel.create(NSLocalizedString("1-0", comment: ""),
                                         event: #selector(contactSupport(_:)))

      let buttonView: PopupSelectionButtonsView =
        PopupSelectionButtonsView.create(withTitle: title,
                                         subtitle: subtitle,
                                         buttons: [contactSupportSelectionModel])
      buttonView.owner = self

      popupWindow = PopupSelectionWindow.popup(view,
                                               subview: buttonView,
                                               owner: self,
                                               close: #selector(closeErrorPopUp(_:)),
                                               style: PopupWindowStyleCautionWindow)
    } else {
      let buttonView: PopupSelectionButtonsView =
        PopupSelectionButtonsView.create(withTitle: title,
                                         subtitle: subtitle,
                                         buttons: nil)
      buttonView.owner = self

      popupWindow = PopupSelectionWindow.popup(view,
                                               subview: buttonView,
                                               owner: self,
                                               displyCloseButton: false,
                                               close: #selector(closePopup(_:)),
                                               style: PopupWindowStyleMessageWindow)
    }
  }

  func closePopup(_ sender: AnyObject!) {
    ipcdServicerController?.stopPairing()
    ipcdServicerController = nil
    attemptPairing = false
    ipcdRetryCount = 12
    hideGif()
  }

  func closeErrorPopUp(_ sender: AnyObject!) {
    closePopup(sender)
    var chooseViewController: ChooseDeviceViewController? = nil

    if let viewControllers = navigationController?.viewControllers {
      for viewController in viewControllers {
        if viewController.isKind(of: ChooseDeviceViewController.self) {
          chooseViewController = viewController as? ChooseDeviceViewController
        }
      }
    }

    if chooseViewController != nil {
      // Allow app level routing to continue.
      CorneaController.suspendRouting(false)

      // Reconnect the suspended session.
      RxCornea.shared.session?.resume()

      navigationController?.popToViewController(chooseViewController!, animated: true)
    }
  }

  func contactSupport(_ sender: AnyObject!) {
    let phoneNo: String = "telprompt:+18554694747"
    if let phoneUrl = URL(string: phoneNo) {
      if UIApplication.shared.canOpenURL(phoneUrl) == true {
        UIApplication.shared.openURL(phoneUrl)
      }
    }
  }

  // MARK: UITextViewDelegate
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange) -> Bool {
    if URL.absoluteString == "settings" {
      settingsLabelPressed(textView)
      return false
    }
    return true
  }

  // MARK: SwannSmartSwitchPairingDelegate
  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     connectionEstablished connected: Bool) {
    if connected == true {
      pairingClient?.startPairing(ssid,
                                  key: key)
    }
  }

  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     receivedMACAddress macAddress: String) {
    self.macAddress = macAddress
  }

  func pairingClient(_ client: SwannSmartSwitchPairingClient,
                     completedPairing success: Bool,
                     error: NSError?) {
    if success == true {
      // Reconnect the suspended session.
      RxCornea.shared.session?.resume()
//      arcusSessionConnected()
    } else {
      let subtitle = "Device needs to be reset. \nPlease call the Arcus Support Team."
      displayPopUp(NSLocalizedString("CONNECTION ERROR", comment: ""),
                   subtitle: NSLocalizedString(subtitle, comment: ""),
                   error: true)
    }
  }

  // MARK: Session Handling

  func observeSessionState(_ session: RxSwiftSession) {
    session.getState()
    .subscribe(onNext: { [weak self]
      state in
      if state == .active {
        self?.arcusSessionConnected()
      }
    })
    .addDisposableTo(disposeBag)
  }

  func arcusSessionConnected() {
    if attemptPairing == true {
      let dispatchTime: DispatchTime = DispatchTime.now()
        + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        self.beginPairingWithMacAddress(self.macAddress)
      })
    }
  }

  func arcusSessionConnectionFailed() {
    if attemptPairing == true {
      let dispatchTime: DispatchTime = DispatchTime.now()
        + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        // Allow app level routing to resume.
        CorneaController.suspendRouting(false)

        // Reconnect the suspended session.
        RxCornea.shared.session?.resume()
      })
    }
  }

  // MARK: ICPDServiceDelegate
  func successfulParing() { /* Never gets called */ }

  func paringHasTimeOut() {
    // TODO: Validate
    retryIPCDPairing()
  }

  func failedParingDeviceHasOwner() {
    DispatchQueue.main.async {
      let subtitle = "Your Arcus Wifi Smart Switch failed to " +
        "pair. You will need to reset the switch and attempt to " +
        "pair it again. Press and hold the on/off switch for 15 " +
        "seconds while the switch is plugged into the wall. The " +
        "lights will blink from red to purple when it is " +
      "successfully reset."

      self.displayPopUp(NSLocalizedString("DEVICE ALREADY CLAIMED", comment: ""),
                        subtitle: subtitle,
                        error: true)
    }
  }

  func failedParingDeviceNotFound() {
    retryIPCDPairing()
  }

  func retryIPCDPairing() {
    DispatchQueue.main.async {
      if self.ipcdRetryCount > 0 {
        print("retrying in 5 seconds")

        self.ipcdRetryCount -= 1
        let dispatchTime: DispatchTime = DispatchTime.now()
          + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
          print("retrying now")
          self.beginPairingWithMacAddress(self.macAddress)
        })
      } else {
        let subtitle = "Your Arcus Wifi Smart Switch failed to " +
          "pair. You will need to reset the switch and attempt to " +
          "pair it again. Press and hold the on/off switch for 15 " +
          "seconds while the switch is plugged into the wall. The " +
          "lights will blink from red to purple when it is " +
        "successfully reset."
        self.displayPopUp(NSLocalizedString("CONNECTION ERROR", comment: ""),
                          subtitle: NSLocalizedString(subtitle, comment: ""),
                          error: true)
      }
    }
  }
}
