//
//  DashboardBannerHandling.swift
//  i2app
//
//  Created by Arcus Team on 2/11/17.
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

// MARK: BannerPresenterCallback
extension DashboardTwoViewController: BannerPresenterCallback {
  func showBanner(_ banner: Banner) {
    var tag: Int = -1

    switch banner.bannerType {
    case DashboardBannerType.hubisRunningOnBattery.rawValue:
      let alertType = AlertBarType(rawValue: banner.alertType)
      let sceneType = AlertBarSceneType(rawValue: banner.sceneType)

      tag = popupLinkAlert(banner.title,
                           type: alertType!,
                           sceneType: sceneType!,
                           linkText: banner.subtitle,
                           selector: nil)
      banner.tag = tag

    case DashboardBannerType.hubOffline.rawValue:
      let alertType = AlertBarType(rawValue: banner.alertType)
      let sceneType = AlertBarSceneType(rawValue: banner.sceneType)

      tag = popupLinkAlert(banner.title,
                           type: alertType!,
                           sceneType: sceneType!,
                           linkText: banner.subtitle,
                           selector: Selector(banner.action!))

      banner.tag = tag
    case DashboardBannerType.lteActivateDevice.rawValue,
         DashboardBannerType.lteConfigureDevice.rawValue:
      let alertType = AlertBarType(rawValue: banner.alertType)
      let sceneType = AlertBarSceneType(rawValue: banner.sceneType)

      tag = popupAlert(banner.title,
                       type: alertType!,
                       canClose: false,
                       sceneType: sceneType!,
                       bottomButton: banner.subtitle,
                       selector: Selector(banner.action!))

      banner.tag = tag
    case DashboardBannerType.lteUpdatePlan.rawValue:
      let alertType = AlertBarType(rawValue: banner.alertType)
      let sceneType = AlertBarSceneType(rawValue: banner.sceneType)

      tag = popupLinkAlert(banner.title,
                           type: alertType!,
                           sceneType: sceneType!,
                           linkText: banner.subtitle,
                           selector: nil)

      banner.tag = tag

    case DashboardBannerType.hasInvitation.rawValue,
         DashboardBannerType.deviceFirmwareUpdate.rawValue:
      let alertType = AlertBarType(rawValue: banner.alertType)
      let sceneType = AlertBarSceneType(rawValue: banner.sceneType)

      tag = popupLinkAlert(banner.title,
                           type: alertType!,
                           sceneType: sceneType!,
                           grayScale: false,
                           linkText: banner.subtitle,
                           selector: Selector(banner.action!),
                           displayArrow: true)

      banner.tag = tag

    default:
      break
    }
  }

  func removeBanner(_ tag: Int) {
    closePopupAlert(withTag: tag)
  }

  func removeAllBanners() {
    closePopupAlert(false)
  }
}

// MARK: PersonInvitationsCallback
extension DashboardTwoViewController: PersonInvitationsCallback {
  func setupInvitationsController() {
    removeInvitationsController()

    if let currentPerson: PersonModel = RxCornea.shared.settings?.currentPerson {
      personInvitationsController = PersonInvitationsController(
        model: currentPerson, callback: self)
    }
  }

  func removeInvitationsController() {
    if personInvitationsController == nil {
      return
    }

    personInvitationsController.removeCallback()
    personInvitationsController = nil
  }

  func showInvitationsPending(_ invitations: [Invitation]) {
    guard let presenter: BannerPresenter = bannerPresenter else {
      return
    }

    if presenter.containsBanner(DashboardBannerType.hasInvitation.rawValue) {
      return
    }

    let banner = Banner()
    banner.title = NSLocalizedString("You've been invited!", comment: "")
    banner.alertType = AlertBarType.updateFirmware.rawValue
    banner.sceneType = AlertBarSceneType.inDashboard.rawValue
    banner.priority = DashboardBannerType.hasInvitation.rawValue
    banner.bannerType = DashboardBannerType.hasInvitation.rawValue
    banner.action = "showPendingInvitationsList"

    presenter.addBanner(banner)
  }

  func showNoInvitations() {
    guard let presenter: BannerPresenter = bannerPresenter else {
      return
    }
    
    if presenter.containsBanner(DashboardBannerType.hasInvitation.rawValue) {
      presenter.removeBanner(DashboardBannerType.hasInvitation.rawValue)
    }
  }

  func showPendingInvitationsList() {
    let viewController = PersonInvitationsListViewController.create()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: CellularBackupCallback
extension DashboardTwoViewController: CellularBackupCallback {
  func showOnBroadband() {
    removeCellularBackupBanner()
  }

  func showOnCellularBackup() {
    removeCellularBackupBanner()
  }

  func showNeedsActivation() {
    guard let presenter: BannerPresenter = bannerPresenter else {
      return
    }

    if presenter.containsBanner(DashboardBannerType.lteActivateDevice.rawValue) {
      return
    }

    let banner = Banner()
    banner.title = NSLocalizedString(
      "Your Backup Cellular service has been suspended. Please call the Arcus Support Team",
      comment: "")
    banner.subtitle = NSLocalizedString("1-0", comment: "")
    banner.alertType = AlertBarType.typeClickableWarning.rawValue
    banner.sceneType = AlertBarSceneType.inDashboard.rawValue
    banner.priority = DashboardBannerType.lteActivateDevice.rawValue
    banner.bannerType = DashboardBannerType.lteActivateDevice.rawValue
    banner.action = "callSupport"

    presenter.addBanner(banner)
  }

  func showNeedsConfiguration() {
    guard let presenter: BannerPresenter  = bannerPresenter else {
      return
    }

    if presenter.containsBanner(DashboardBannerType.lteConfigureDevice.rawValue) {
      return
    }

    let banner = Banner()
    banner.title = NSLocalizedString(
      "Cellular device configuration required. Please call the Arcus Support Team",
      comment: "")
    banner.subtitle = NSLocalizedString("1-0", comment: "")
    banner.alertType = AlertBarType.typeClickableWarning.rawValue
    banner.sceneType = AlertBarSceneType.inDashboard.rawValue
    banner.priority = DashboardBannerType.lteConfigureDevice.rawValue
    banner.bannerType = DashboardBannerType.lteConfigureDevice.rawValue
    banner.action = "callSupport"

    presenter.addBanner(banner)
  }

  func showNeedsServicePlan() {
    guard let presenter: BannerPresenter  = bannerPresenter else {
      return
    }

    if presenter.containsBanner(DashboardBannerType.lteUpdatePlan.rawValue) {
      return
    }

    let banner = Banner()
    banner.title = NSLocalizedString(
      "Update your service plan to include Backup Cellular",
      comment: "")
    banner.alertType = AlertBarType.typeClickableWarning.rawValue
    banner.sceneType = AlertBarSceneType.inDashboard.rawValue
    banner.priority = DashboardBannerType.lteUpdatePlan.rawValue
    banner.bannerType = DashboardBannerType.lteUpdatePlan.rawValue

    presenter.addBanner(banner)
  }

  func removeCellularBackupBanner() {
    guard let presenter: BannerPresenter = bannerPresenter else {
      return
    }

    if presenter.containsBanner(DashboardBannerType.lteActivateDevice.rawValue) {
      presenter.removeBanner(DashboardBannerType.lteActivateDevice.rawValue)
    }

    if presenter.containsBanner(DashboardBannerType.lteUpdatePlan.rawValue) {
      presenter.removeBanner(DashboardBannerType.lteUpdatePlan.rawValue)
    }

    if presenter.containsBanner(DashboardBannerType.lteConfigureDevice.rawValue) {
      presenter.removeBanner(DashboardBannerType.lteConfigureDevice.rawValue)
    }
  }

  func callSupport() {
    guard let phoneUrl: URL = URL(string: "telprompt:\(DashboardConstants.callSupportNumber)") else {
        return
    }

    if UIApplication.shared.canOpenURL(phoneUrl) {
      UIApplication.shared.openURL(phoneUrl)
    }
  }
}

// MARK: Device Firmware - handling
extension DashboardTwoViewController {
  func checkForDeviceFirmwareUpdates() {
    guard let presenter: BannerPresenter = bannerPresenter else {
      return
    }

    if DeviceManager.instance().devicesUndergoingFirmwareUpdate().count > 0 {
      let banner = Banner()
      banner.title = NSLocalizedString("Firmware Updating...", comment: "")
      banner.subtitle = NSLocalizedString("Show All", comment: "")
      banner.alertType = AlertBarType.updateFirmware.rawValue
      banner.sceneType = AlertBarSceneType.inDashboard.rawValue
      banner.priority = DashboardBannerType.deviceFirmwareUpdate.rawValue
      banner.bannerType = DashboardBannerType.deviceFirmwareUpdate.rawValue
      banner.action = "showDeviceFirmwareUpdateList"

      presenter.addBanner(banner)
    } else if presenter.containsBanner(DashboardBannerType.deviceFirmwareUpdate.rawValue) {
      presenter.removeBanner(DashboardBannerType.deviceFirmwareUpdate.rawValue)
    }
  }

  func showDeviceFirmwareUpdateList() {
    navigationController?.pushViewController(
      DeviceFirmwareUpdateListViewController.create(), animated: true)
  }
}

// MARK: Hub is down handling
extension DashboardTwoViewController {
  func navigateToHub() {
    guard let hub: HubModel = RxCornea.shared.settings?.currentHub else {
      return
    }

    navigationController?.pushViewController(
      DeviceDetailsTabBarController.create(with: hub),
      animated: true)
  }

  func checkHubState() {
    guard let presenter: BannerPresenter = bannerPresenter,
      let hubModel: HubModel = RxCornea.shared.settings?.currentHub else {
      return
    }

    if hubModel.isDown == true {
      guard !presenter.containsBanner(DashboardBannerType.hubOffline.rawValue) else { return }
      let banner = Banner()
      banner.title = NSLocalizedString("Hub is Offline", comment: "")
      banner.alertType = AlertBarType.typeWarning.rawValue
      banner.sceneType = AlertBarSceneType.inDashboard.rawValue
      banner.subtitle = NSLocalizedString("View Hub Details >", comment: "")
      banner.priority = DashboardBannerType.hubOffline.rawValue
      banner.bannerType = DashboardBannerType.hubOffline.rawValue
      banner.action = "navigateToHub"
      presenter.addBanner(banner)
    } else if hubModel.isRunningOnBattery == true {
      guard !presenter.containsBanner(DashboardBannerType.hubisRunningOnBattery.rawValue) else { return }
      let banner = Banner()
      banner.title = NSLocalizedString("Running on Battery", comment: "")
      banner.alertType = AlertBarType.typeLowBattery.rawValue
      banner.sceneType = AlertBarSceneType.inDashboard.rawValue
      banner.subtitle = ""
      banner.priority = DashboardBannerType.hubisRunningOnBattery.rawValue
      banner.bannerType = DashboardBannerType.hubisRunningOnBattery.rawValue
      banner.action = nil
      presenter.addBanner(banner)
    } else {
      presenter.removeBanner(DashboardBannerType.hubOffline.rawValue)
      presenter.removeBanner(DashboardBannerType.hubisRunningOnBattery.rawValue)
    }
  }
}
