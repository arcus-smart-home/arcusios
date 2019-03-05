//
//  AlarmStatusViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/12/16.
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

private enum StatusViewConstants {
  static let statusCellIdentifier = "StatusCell"
  static let statusSecurityCellIdentifier = "StatusSecurityCell"
  static let statusEmptyCellIdentifier = "StatusEmptyCell"
  static let alarmCellIdentifier = "AlarmCell"
  static let cellHeight: CGFloat = 95
  static let titleWaterCell = "WATER LEAK"
  static let segueArmBypass = "AlarmStatusToArmBypass"
  static let segueAlarmDevices = "AlarmStatusToAlarmDevices"
  static let segueLearnMore = "AlarmStatusToLearnMore"
  static let segueAlarmTracker = "AlarmTrackerSegue"
  static let seguePromptToAddContact = "promptToAddContact"
}

class AlarmStatusViewController: UIViewController, ArcusTabBarComponent {

  // MARK: Public Properties

  @IBOutlet var segmentedControl: ArcusSegmentedControl!
  @IBOutlet var tableView: UITableView!

  weak var statusCell: UITableViewCell!
  weak var topBannerContraint: NSLayoutConstraint?
  
  var alarmStatusPresenter: AlarmStatusPresenterProtocol!
  var popupWindow: PopupSelectionWindow!
  var bannerTarget: URL?

  private var cancelPopUpViewController = ArmingWarningPopupViewController.create()

  // MARK: Public Functions
  
  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }

  @IBAction func offButtonPressed(_ sender: AnyObject) {
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsStatusSecurityOff)

    alarmStatusPresenter.disarmSecurityAlarm()
  }

  @IBAction func cancelButtonPressed(_ sender: AnyObject) {
    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsStatusSecurityCancelled)

    alarmStatusPresenter.cancelSecurityAlarm()
  }

  @IBAction func partialButtonPressed(_ sender: AnyObject) {
    if let button = sender as? UIButton {
      button.isEnabled = false
    }

    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsStatusSecurityPartial)
    alarmStatusPresenter.armPartialSecurityAlarm()
  }

  @IBAction func onButtonPressed(_ sender: AnyObject) {
    if let button = sender as? UIButton {
      button.isEnabled = false
    }

    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsStatusSecurityOn)
    alarmStatusPresenter.armSecurityAlarm()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    alarmStatusPresenter = AlarmStatusPresenter(delegate: self)
    alarmStatusPresenter.fetchAlarmStatus()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200.0
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    alarmStatusPresenter.fetchAlarmStatus()
    configureLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsDevices)
    configureNavigationBar()
    configureSegmentedControl(tabBarController)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    alarmStatusPresenter.tearDown()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StatusViewConstants.segueArmBypass {
      guard let securityModel = alarmStatusPresenter.alarmStatusModelWithType(AlarmType.Security),
        let destination = segue.destination as? AlarmStatusArmBypassViewController else {
          return
      }

      destination.statusViewController = self
      destination.devicePresenter =
        BypassedOfflineDevicesPresenter(destination, deviceModels: securityModel.triggeredDevices)
    } else if segue.identifier == StatusViewConstants.segueAlarmDevices {
      guard let destination = segue.destination as? AlarmDevicesViewController,
        let indexPath = sender as? IndexPath else {
          return
      }

      let statusModel = alarmStatusPresenter.alarmStatusModels[indexPath.row]
      destination.alarmType = statusModel.alarmType

      switch statusModel.alarmType {
      case .CO:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsDevicesCoDevice)
      case .Smoke:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsDevicesSmokeDevice)
      case .Water:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsDevicesWaterDevice)
      case .Security:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsDevicesSecurityDevice)
      case .Panic:
        break
      }

    } else if segue.identifier == StatusViewConstants.segueAlarmTracker {
      if let alarmTrackerViewController: AlarmTrackerViewController =
        segue.destination as? AlarmTrackerViewController {

        alarmTrackerViewController.incidentPresenter = AlarmTrackerPresenter(
          delegate: alarmTrackerViewController,
          subsystemModel: alarmStatusPresenter.subsystemModel,
          incidentId: alarmStatusPresenter.currentAlarmIncident())
      }
    } else if segue.identifier == StatusViewConstants.segueLearnMore {
      guard let destination = segue.destination as? AlarmsLearnMoreViewController,
        let indexPath = sender as? IndexPath else {
          return
      }

      let statusModel = alarmStatusPresenter.alarmStatusModels[indexPath.row]
      destination.alarmType = statusModel.alarmType
    }
  }

  func callArmBypass() {
    if alarmStatusPresenter.partialIndicator {
      alarmStatusPresenter.armBypassPartialSecurityAlarm()
    } else {
      alarmStatusPresenter.armBypassSecurityAlarm()
    }
  }

  func handleArmBypassedSecurity() {
    alarmStatusPresenter.armBypassSecurityAlarm()
  }

  func handleArmBypassedPartialSecurity() {
    alarmStatusPresenter.armBypassPartialSecurityAlarm()
  }

  func configureLayout() {
    configureNavigationBar()
    configureBackground()
    configureTableView()
  }

  func configureNavigationBar() {
    navBar(withTitle: navigationItem.title, enableBackButton: true)
    addDarkOverlay(BackgroupOverlayLightLevel)
  }

  func configureBackground() {
    setBackgroundColorToDashboardColor()
  }

  func configureTableView() {
    tableView.backgroundColor = UIColor.clear
  }
  
  // MARK: Private Functions

  fileprivate func presentArmBypassPopup() {
    performSegue(withIdentifier: StatusViewConstants.segueArmBypass, sender: self)
  }

  fileprivate func presentFailedPopup(titleText: String, errorText: String) {
    let title = titleText
    let text = errorText

    // The controller needs to be re-created to avoid bug ITWO-11493
    cancelPopUpViewController = ArmingWarningPopupViewController.create()

    cancelPopUpViewController?.configureCancelPopup(title, message: text, closeBlock: {
      self.dismissPopup()
    })

    popupWindow = PopupSelectionWindow.popup(self.view,
                                             subview: cancelPopUpViewController,
                                             owner: self,
                                             displyCloseButton: false,
                                             close: nil,
                                             style: PopupWindowStyleCautionWindow)
    cancelPopUpViewController?.window = popupWindow
    popupWindow.open()
  }

  private func dismissPopup() {
    if popupWindow.displaying == true {
      popupWindow.close()
    }
  }
}

// MARK: AlarmStatusPresenterDelegate

extension AlarmStatusViewController: AlarmStatusPresenterDelegate {

  func shouldRestoreAlarmButtons() {
    let securityIndex = IndexPath(row: 3, section: 0)

    if let securityCell = tableView.cellForRow(at: securityIndex) as? SecurityAlarmStatusTableViewCell {
      securityCell.onButton.isEnabled = !alarmStatusPresenter.isSwitchingSecurityMode
      securityCell.partialButton.isEnabled = !alarmStatusPresenter.isSwitchingSecurityMode
    }
  }

  func updateLayout() {
    DispatchQueue.main.async {
      if self.tableView != nil {
        self.tableView.reloadData()
      }
    }
  }

  func updateSecurityCell(_ ringViewModel: AlarmStatusRingViewModel) {
    if self.tableView != nil && self.tableView.numberOfRows(inSection: 0) >= 3 {
      let indexPath = IndexPath(row: 3, section: 0)

      DispatchQueue.main.async {
        if let securityCell = self.tableView.cellForRow(at: indexPath) as?
          AlarmStatusTableViewCell {

          securityCell.alarmStatusRing.configureRing(ringViewModel)
        }
      }
    }
  }

  func shouldPromptToAddContact() {
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: StatusViewConstants.seguePromptToAddContact, sender: self)
    }
  }

  func shouldPresentArmBypassWarning() {
    DispatchQueue.main.async {
      self.presentArmBypassPopup()
    }
  }

  func shouldPresentArmFailed(_ errorText: String) {
    DispatchQueue.main.async {
      self.presentFailedPopup(titleText: AlarmStatusMessage.armFailedTitle, errorText: errorText)
    }
  }

  func shouldPresentDisarmFailed(_ errorText: String) {
    DispatchQueue.main.async {
      self.presentFailedPopup(titleText: AlarmStatusMessage.disarmFailedTitle, errorText: errorText)
    }
  }
}

// MARK: UITableViewDataSource

extension AlarmStatusViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard alarmStatusPresenter != nil else {
      return 0
    }

    return alarmStatusPresenter.alarmStatusModels.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let presenter = alarmStatusPresenter
    let indexOfStatusModel = indexPath.row

    if let totalStatusModels = presenter?.alarmStatusModels.count {
      if indexOfStatusModel >= totalStatusModels {
        return UITableViewCell()
      }
    }

    let alarmStatus = presenter?.alarmStatusModels[indexOfStatusModel]
    var cellIdentifier = ""

    if (alarmStatus?.isEmpty)! {
      cellIdentifier = StatusViewConstants.statusEmptyCellIdentifier
    } else if alarmStatus!.alarmType == AlarmType.Security &&
              !alarmStatus!.isAlarming &&
              alarmStatus!.securityState != .prealerting {
      cellIdentifier = StatusViewConstants.statusSecurityCellIdentifier
    } else {
      cellIdentifier = StatusViewConstants.statusCellIdentifier
    }

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
      return UITableViewCell()
    }

    return bindDataToCell(cell, alarmStatus: alarmStatus!)
  }
}

// MARK: UITableViewDelegate
extension AlarmStatusViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let statusModel = alarmStatusPresenter.alarmStatusModels[indexPath.row]

    if statusModel.isEmpty {
      performSegue(withIdentifier: StatusViewConstants.segueLearnMore, sender: indexPath)
    } else if statusModel.isAlarming || statusModel.securityState == .prealerting {
      self.performSegue(withIdentifier: StatusViewConstants.segueAlarmTracker, sender: statusModel)
    } else if statusModel.alarmType != AlarmType.Panic {
      self.performSegue(withIdentifier: StatusViewConstants.segueAlarmDevices, sender: indexPath)
    }
  }

  func tableView(_ tableView: UITableView,
                 willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if tableView.isLastCellInSection(indexPath) {
      statusCell = cell
    }
  }
}

// MARK: Data Binding
extension AlarmStatusViewController {
  func bindDataToCell(_ cell: UITableViewCell,
                      alarmStatus: AlarmStatusViewModel) -> UITableViewCell {
    cell.backgroundColor = UIColor.clear
    if let statusCell = cell as? AlarmStatusTableViewCell {

      // Change title for the Water Leak Alarm
      let title = (alarmStatus.alarmType == AlarmType.Water) ?
        StatusViewConstants.titleWaterCell : alarmStatus.alarmType.rawValue

      statusCell.alarmTitle.text = title
      statusCell.alarmDescription.text = alarmStatus.status
      statusCell.alarmIcon.image = UIImage(named: alarmStatus.iconName)

      // Alarming styles
      if alarmStatus.isAlarming {
        if alarmStatusPresenter.isNextAlarmAlarming(alarmStatus.alarmType) {
          statusCell.separatorInset = UIEdgeInsets.zero
        } else {
          statusCell.separatorInset.left = view.frame.width
        }
        statusCell.alarmingIcon.isHidden = false
        statusCell.backgroundColor =
          alarmStatusPresenter.alarmingColorForAlarmType(alarmStatus.alarmType)
      } else {
        if alarmStatusPresenter.isNextAlarmAlarming(alarmStatus.alarmType) {
          statusCell.separatorInset.left = view.frame.width
        } else {
         statusCell.separatorInset.left = 15
        }
        statusCell.alarmingIcon?.isHidden = true
        statusCell.backgroundColor = UIColor.clear
      }

      // Extend the cell separators to take the whole width.
      cell.preservesSuperviewLayoutMargins = false
      cell.layoutMargins = UIEdgeInsets.zero

      // Configure the ring if needed
      if let ringViewModel = alarmStatus.ringViewModel {
        statusCell.alarmStatusRing.configureRing(ringViewModel)
      }

      if alarmStatus.alarmType == .Panic {
        statusCell.accessoryImage.isHidden = true
      } else {
        statusCell.accessoryImage.isHidden = false
      }

      // Set the promon badge
      statusCell.badgePro.isHidden = !alarmStatus.isPromonitored
    }

    // Early exit if the cell is not security
    guard let securityCell = cell as? SecurityAlarmStatusTableViewCell,
      let securityState = alarmStatus.securityState,
      securityState != .prealerting else {
        return cell
    }

    securityCell.onButton.isHidden = false
    securityCell.offButton.isHidden = false
    securityCell.partialButton.isHidden = false

    if alarmStatusPresenter.isSwitchingSecurityMode {
      if securityState == .arming {
        fadeButton(securityCell.cancelButton)
        securityCell.cancelButton.isEnabled = false

        securityCell.onButton.isHidden = true
        securityCell.offButton.isHidden = true
        securityCell.partialButton.isHidden = true
      } else {
        securityCell.onButton.isEnabled = false
        securityCell.partialButton.isEnabled = false
        securityCell.offButton.isEnabled = false
        fadeButton(securityCell.onButton)
        fadeButton(securityCell.partialButton)
        fadeButton(securityCell.offButton)
      }
    } else {
      switch securityState {
      case .on, .partial:
        securityCell.onButton.isEnabled = false
        securityCell.partialButton.isEnabled = false
        securityCell.offButton.isEnabled = true
        fadeButton(securityCell.onButton)
        fadeButton(securityCell.partialButton)
        fadeButton(securityCell.offButton, inverse: true)
        hideCancelButton(securityCell.cancelButton)
      case .off:
        securityCell.onButton.isEnabled = true
        securityCell.partialButton.isEnabled = true
        securityCell.offButton.isEnabled = false
        fadeButton(securityCell.onButton, inverse: true)
        fadeButton(securityCell.partialButton, inverse: true)
        fadeButton(securityCell.offButton)
        hideCancelButton(securityCell.cancelButton)

      case .arming:
        securityCell.cancelButton.backgroundColor = ObjCMacroAdapter.arcusPinkAlertColor()
        securityCell.cancelButton.isEnabled = true
        securityCell.onButton.isEnabled = false
        securityCell.partialButton.isEnabled = false
        securityCell.offButton.isEnabled = false
        fadeButton(securityCell.onButton)
        fadeButton(securityCell.partialButton)
        fadeButton(securityCell.offButton)
        showCancelButton(securityCell.cancelButton)
        
      default:
        break
      }
    }

    return cell
  }

  fileprivate func hideCancelButton(_ button: UIButton) {
    let colorFaded = button.backgroundColor?.withAlphaComponent(0)
    let colorTextFaded = button.titleLabel?.textColor.withAlphaComponent(0)

    UIView.transition(with: view,
                              duration: 0.3,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                button.backgroundColor = colorFaded
                                button.titleLabel?.textColor = colorTextFaded},
                              completion: { (_: Bool) in
                                button.isHidden = true
    })
  }

  fileprivate func showCancelButton(_ button: UIButton) {
    let colorFaded = button.backgroundColor?.withAlphaComponent(1.0)
    let colorTextFaded = button.titleLabel?.textColor.withAlphaComponent(1.0)

    UIView.transition(with: view,
                              duration: 0.5,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                button.backgroundColor = colorFaded
                                button.titleLabel?.textColor = colorTextFaded},
                              completion: { (_: Bool) in
                                button.isHidden = false
    })
  }

  fileprivate func fadeButton(_ button: UIButton, inverse: Bool = false) {
    let color = button.backgroundColor?.withAlphaComponent(1.0)
    let colorFaded = button.backgroundColor?.withAlphaComponent(0.4)
    let colorText = button.titleLabel?.textColor.withAlphaComponent(1.0)
    let colorTextFaded = button.titleLabel?.textColor.withAlphaComponent(0.4)

    var useColor = colorFaded
    var useText = colorTextFaded
    if inverse {
      useColor = color
      useText = colorText
    }

    UIView.transition(with: view,
                              duration: 0.5,
                              options: UIViewAnimationOptions.transitionCrossDissolve,
                              animations: {
                                button.backgroundColor = useColor
                                button.titleLabel?.textColor = useText},
                              completion: nil)
  }
}
