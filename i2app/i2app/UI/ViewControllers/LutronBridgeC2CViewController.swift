//
//  LutronBridgeC2CViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/19/17.
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

class LutronBridgeC2CViewController: BasePairingViewController {

  // IBOutlets
  @IBOutlet weak var webView: UIWebView!

  // properties

  /// our presenter, get the url and handles devices added
  var presenter: LutronBridgeC2CPresenter = LutronBridgeC2CPresenter()

  override func viewDidLoad() {
    super.viewDidLoad()

    navBar(withTitle: NSLocalizedString("Link Account", comment: ""), enableBackButton: false)
    navigationItem.setHidesBackButton(true, animated: false)
    navigationItem.leftBarButtonItem = nil
    presenter.fetchRevokedDevices()
    createNavigationCancelButton()
    if let urlRequest = presenter.pairURLRequest {
      webView.loadRequest(urlRequest)
    }
  }

  deinit {
    webView.delegate = nil
  }

  // MARK: Events

  func cancelButtonTapped() {
    // Check if device details exists in the stack and if so present it
    if let navigationController = navigationController {
      let viewControllers = navigationController.viewControllers

      for viewController in viewControllers {
        if let viewController = viewController as? DeviceDetailsTabBarController {
          navigationController.popToViewController(viewController, animated: true)
          return
        }
      }
    }

    navigateToDashboard()
  }

  // MARK: Helpers

  fileprivate func navigateToDashboard() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      DispatchQueue.main.async {
        DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()
        ApplicationRoutingService.defaultService.showDashboard()
      }
    }
  }

  fileprivate func createNavigationCancelButton() {
    let editButton = UIButton(type: .custom)
    editButton.setAttributedTitle(FontData.getString(NSLocalizedString("Cancel", comment: ""),
                                                     withFont: FontDataTypeNavBar),
                                  for: UIControlState())
    editButton.frame = CGRect(x: 0, y: 0, width: 50, height: 12)
    editButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: editButton)
  }

  fileprivate var presentingPairedDeviceConfiguration = false

  fileprivate func presentPairedDeviceConfiguration() {

    if presentingPairedDeviceConfiguration {
      return
    }
    presentingPairedDeviceConfiguration = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      var devicesJustPaired = DevicePairingManager.sharedInstance().justPairedDevices

      let reconnected = self.presenter.reconnectedDevices()

      if reconnected.count > 0 {
        if devicesJustPaired == nil {
          devicesJustPaired = NSMutableArray()
        }

        for device in reconnected {
          // check if revoked device is already in justPairedDevices
          if !self.checkFor(device: device, inDeviceList: devicesJustPaired!) {
            devicesJustPaired?.add(device)
          }
        }
      }

      DevicePairingManager.sharedInstance().justPairedDevices = devicesJustPaired

      if devicesJustPaired != nil && devicesJustPaired!.count > 0 {
        DevicePairingManager.sharedInstance().customizeDevice(self)
      } else {
        self.navigateToDashboard()
      }
      self.presentingPairedDeviceConfiguration = false
    }
  }

  private func checkFor(device: DeviceModel, inDeviceList list: NSArray) -> Bool {
    for deviceFromList in list {
      if let deviceFromList = deviceFromList as? DeviceModel {
        if deviceFromList.address == device.address {
          return true
        }
      }
    }
    return false
  }
}

// MARK: UIWebViewDelegate

extension LutronBridgeC2CViewController: UIWebViewDelegate {
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    guard let urlString = request.url?.absoluteString else {
      return true
    }
    if urlString.range(of: "/pair/success") != nil {
      presentPairedDeviceConfiguration()
      return false
    } else if urlString.range(of: "/pair/cancel") != nil {
      DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()
      navigateToDashboard()
      return false
    }
    return true
  }

  func webViewDidFinishLoad(_ webView: UIWebView) {
    // Check for cancel button
    if let url = webView.request?.url {
      if url.absoluteString.range(of: "lutron.com") != nil {
        createNavigationCancelButton()
      } else {
        navigationItem.leftBarButtonItem = nil
      }
    }
    if let url = webView.request?.url,
      url.absoluteString.range(of: "/pair") != nil,
      let request = webView.request,
      let httpResponse = URLCache.shared.cachedResponse(for: request)?.response as? HTTPURLResponse {
      switch httpResponse.statusCode {
      case 204:
        self.presentPairedDeviceConfiguration()
      case 203: // No Content (Check this?)
        DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()
        self.navigateToDashboard()
      default:
        break
      }
    }
    if let request = webView.request,
      let httpResponse = URLCache.shared.cachedResponse(for: request)?.response as? HTTPURLResponse {
      switch httpResponse.statusCode {
      case 400...599:
        self.createNavigationCancelButton()
      default:
        break
      }
    }
  }
}
