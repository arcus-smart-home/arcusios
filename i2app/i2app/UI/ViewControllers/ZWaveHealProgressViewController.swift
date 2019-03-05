//
//  ZWaveHealProgressViewController.swift
//  i2app
//
//  Arcus Team on 9/16/16.
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

open class ZWaveHealProgressViewController: UIViewController {

  let kBlockIncomingPlatformMessages = false
  let kDelayedStartTime: Double = 0
  var shouldStartHeal: Bool = false

  // May be better modeled as a state machine

  // When true, rebuild request has been made,
  // but hub still reports that rebuild is not in progress (hold UI at 0%)
  var isRebuildStarting: Bool = false
  // When true, hub attribute refresh is pending; attributes are unreliable (hold UI at 0%)
  var isWaitingToRefresh: Bool = true

  var popupWindow: PopupSelectionWindow!

  @IBOutlet weak var progressMeter: UIProgressView!
  @IBOutlet weak var percentLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var continueToDashboardButton: UIButton!
  @IBOutlet weak var cancelRebuildButton: UIButton!

  static func createAndStartRebuild() -> ZWaveHealProgressViewController {
    let controller: ZWaveHealProgressViewController = create()
    controller.shouldStartHeal = true
    return controller
  }

  static func create() -> ZWaveHealProgressViewController {
    let zWaveToolsStoryboard = UIStoryboard(name: "ZWaveTools", bundle: nil)
    if let viewController = zWaveToolsStoryboard
      .instantiateViewController(withIdentifier: "ZWaveHealProgressViewController")
      as? ZWaveHealProgressViewController {
      return viewController
    }
    return ZWaveHealProgressViewController()
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    configureNavBar()
    configureBackground()
    configureDisplay()
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    isWaitingToRefresh = true
    configureDisplay()
    refreshHubAttributes()

    // Listen for hub list refreshes
    NotificationCenter.default
      .addObserver(self, selector: #selector(onHubDeviceListChange),
                   name: Notification.Name.hubListRefreshed,
                   object: nil)

    // Listen for percent complete changes
    NotificationCenter.default
      .addObserver(self, selector: #selector(onHealStateChange),
                   name: Notification.Name(HubModel.attributeChangedNotification(kAttrHubZwaveHealPercent)),
                   object: nil)

    // Listen for changes to in progress state
    let name = Notification.Name(HubModel.attributeChangedNotification(kAttrHubZwaveHealInProgress))
    NotificationCenter.default
      .addObserver(self, selector: #selector(onHealStateChange),
                   name: name,
                   object: nil)
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName("HubListRefreshed"),
                      object: nil)
    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealPercent),
                      object: nil)
    NotificationCenter.default
      .removeObserver(self,
                      name: HubModel.attributeChangedNotificationName(kAttrHubZwaveHealInProgress),
                      object: nil)
  }

  fileprivate func configureNavBar() {
    self.navBar(withTitle: self.navigationItem.title)
  }

  fileprivate func configureBackground () {
    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
  }

  fileprivate func configureDisplay() {

    let isInProgress = isRebuilding() || isRebuildStarting || isWaitingToRefresh

    if isInProgress {
      if let progress = getRebuildProgress() {
        configureProgressMeter(progress)
      } else {
        configureProgressMeter(0)
      }
    } else {
      configureProgressMeter(100)
    }

    // Configure labels
    var title = "Success!"
    var description = "The Z-Wave network rebuild "
      + "process has \n completed."

    if isInProgress {
      title = "Rebuilding"
      description = "The rebuild process time varies depending \n on the number of Z-Wave "
        + "devices in your \n home. It may take a few minutes or several \n hours to complete. \n \n During "
        + "this process Z-Wave devices will not \n work optimally. These devices may \n disconnect and "
        + "reconnect to the hub until \n the rebuild process is complete."
    }

    titleLabel.attributedText =
      NSAttributedString(string: title,
                         attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18.0)!,
                                      NSKernAttributeName: 0.0,
                                      NSForegroundColorAttributeName: UIColor.white])

    descriptionLabel.attributedText =
      NSAttributedString(string: description,
                         attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 14.0)!,
                                      NSKernAttributeName: 0.0])

    // Configure buttons
    if isInProgress {
      cancelRebuildButton.isHidden = false
      cancelRebuildButton.styleSet("CANCEL REBUILD", andButtonType: FontDataTypeButtonLight, upperCase: true)
      continueToDashboardButton.styleSet("CONTINUE TO DASHBOARD",
                                         andButtonType: FontDataTypeButtonLight,
                                         upperCase: true)
    } else {
      cancelRebuildButton.isHidden = true
      continueToDashboardButton.styleSet("DONE", andButtonType: FontDataTypeButtonLight, upperCase: true)
    }
  }

  fileprivate func configureProgressMeter (_ percentComplete: Int) {
    progressMeter.progress = Float(percentComplete) / 100.0
    percentLabel.text = "\(percentComplete)%"
  }

  fileprivate func refreshHubAttributes() {
    self.isWaitingToRefresh = true

    if let hub = RxCornea.shared.settings?.currentHub {
      DispatchQueue.global(qos: .background).async {
        _ = hub.refresh().swiftThen({_ in
          self.isWaitingToRefresh = false

          // Start network rebuild (once) if requested
          if self.shouldStartHeal {
            self.shouldStartHeal = false
            self.startRebuilding()
          }

            // Refresh the screen
          else {
            self.configureDisplay()
          }

          return nil
        })
      }
    }
  }

  fileprivate func startRebuilding() {
    if let hubAttributes = RxCornea.shared.settings?.currentHub?.get() {
      let hubZwave = HubZwaveModel(attributes: hubAttributes)
      isRebuildStarting = true

      DispatchQueue.global(qos: .background).async {
        HubZwaveCapability.heal(withBlock: self.kBlockIncomingPlatformMessages,
                                withTime: self.kDelayedStartTime, on: hubZwave)
        self.configureProgressMeter(0)
      }
    }
  }

  fileprivate func cancelRebuilding() {
    if let hubAttributes = RxCornea.shared.settings?.currentHub?.get() {
      let hubZwave = HubZwaveModel(attributes: hubAttributes)

      DispatchQueue.global(qos: .background).async {
        HubZwaveCapability.cancelHeal(on: hubZwave)
      }
    }
  }

  fileprivate func isRebuilding() -> Bool {
    if let hubAttributes = RxCornea.shared.settings?.currentHub?.get() {
      let hubZwave = HubZwaveModel(attributes: hubAttributes)
      return HubZwaveCapability.getHealInProgress(from: hubZwave)
    }

    return false
  }

  fileprivate func getRebuildProgress() -> Int? {
    if let hubAttributes = RxCornea.shared.settings?.currentHub?.get() {
      let hubZwave = HubZwaveModel(attributes: hubAttributes)
      return Int(HubZwaveCapability.getHealPercent(from: hubZwave) * 100)
    }

    return nil
  }

  func onHubDeviceListChange (_ notification: Notification) {
    refreshHubAttributes()
  }

  func onHealStateChange (_ notification: Notification) {

    // Clear the isRebuildStarting flag once rebuild state reflects rebuild in progress
    if isRebuilding() {
      isRebuildStarting = false
    }

    DispatchQueue.main.async(execute: {
      self.configureDisplay()
    })
  }

  func onUserDidNotCancelRebuild (_ sender: AnyObject!) {
    popupWindow.close()
  }

  func onUserCancelledRebuild (_ sender: AnyObject!) {
    cancelRebuilding()
    _ = self.navigationController?.popToRootViewController(animated: true)
  }

  func onContinueToDashboardPopupClosed (_ sender: AnyObject!) {
    _ = self.navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func onCancel(_ sender: AnyObject) {
    let title = "ARE YOU SURE?"
    let subtitle = "Cancelling the Z-Wave rebuild process will abandon any improvements to your Z-Wave "
      + "network. It may take a few minutes to stop rebuilding."

    var buttons: [PopupSelectionButtonModel] = [PopupSelectionButtonModel]()
    buttons.append(PopupSelectionButtonModel.create("YES",
                                                    event: #selector(onUserCancelledRebuild(_:)),
                                                    obj: nil))
    buttons.append(PopupSelectionButtonModel.create("NO",
                                                    event: #selector(onUserDidNotCancelRebuild(_:)),
                                                    obj: nil))

    if let buttonView = PopupSelectionButtonsView.create(withTitle: title,
                                                         subtitle: subtitle,
                                                         buttons: buttons) {
      buttonView.owner = self
      popupWindow = PopupSelectionWindow.popup(self.view,
                                               subview: buttonView,
                                               owner: self, close: nil,
                                               style: PopupWindowStyleCautionWindow)
    }
  }

  @IBAction func onContinueToDashboard(_ sender: AnyObject) {
    if isRebuilding() {
      let title = "NOTE"
      let subtitle = "The rebuilding process will continue in the background. "
        + "Z-Wave devices will not work optimally during this process."

      let buttonView = PopupSelectionButtonsView.create(withTitle: title, subtitle: subtitle, buttons: [])
      buttonView?.owner = self

      popupWindow = PopupSelectionWindow.popup(self.view,
                                               subview: buttonView,
                                               owner: self,
                                               close: #selector(onContinueToDashboardPopupClosed(_:)),
                                               style: PopupWindowStyleMessageWindow)
    } else {
      _ = self.navigationController?.popToRootViewController(animated: true)
    }
  }
}
