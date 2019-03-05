//
//  NestC2CViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/27/17.
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

class NestC2CViewController: BasePairingViewController {

  // MARK: Properties

  @IBOutlet weak var webView: UIWebView!

  private var presenter: NestC2CPresenterProtocol!
  
  var isReconnectFlow = false

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    navBar(withTitle: NSLocalizedString("Link Account", comment: ""), enableBackButton: false)
    navigationItem.setHidesBackButton(true, animated: false)
    navigationItem.leftBarButtonItem = nil

    presenter = NestC2CPresenter(delegate: self)
    presenter.fetchRevokedDevices()

    createNavigationCancelButton()

    if let url = URL(string: presenter.nestPairURL()) {
      webView.loadRequest(URLRequest(url: url))
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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

  fileprivate func presentPairedDeviceConfiguration() {
    var devicesJustPaired = DevicePairingManager.sharedInstance().justPairedDevices

    let reconnected = presenter.reconnectedDevices()
    
    if reconnected.count > 0 {
      if devicesJustPaired == nil {
        devicesJustPaired = NSMutableArray()
      }

      for device in reconnected {
        // check if revoked device is already in justPairedDevices
        if !checkFor(device: device, inDeviceList: devicesJustPaired!) {
          devicesJustPaired?.add(device)
        }
      }
    }
    
    DevicePairingManager.sharedInstance().justPairedDevices = devicesJustPaired
    
    DispatchQueue.main.async {
      if devicesJustPaired != nil && devicesJustPaired!.count > 0 {
        DevicePairingManager.sharedInstance().customizeDevice(self)
      } else {
        self.navigateToDashboard()
      }
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

extension NestC2CViewController: UIWebViewDelegate {
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {

    // Make sure we do not hit the url with state=pair twice in order to avoid creating two nest tokens
    // ITWO-12743
    if request.url?.absoluteString.range(of: "") != nil &&
      request.url?.absoluteString.range(of: "state=pair") == nil {
      // Check for status code
      
      let configuration = URLSessionConfiguration.default
      let session = URLSession(configuration: configuration)
      let task = session.dataTask(with: request) { (_, response, _) in
        if let response = response as? HTTPURLResponse {
          if response.statusCode == 204 {
            
            // Go to adding devices
            
            self.presentPairedDeviceConfiguration()
          } else if response.statusCode == 203 {
            // Go to the dashboard
            
            DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()
            
            self.navigateToDashboard()
          } else if response.statusCode == 400 || response.statusCode == 404 {
            self.createNavigationCancelButton()
          }
        }
      }
      
      task.resume()
    }

    return true
  }

  func webViewDidFinishLoad(_ webView: UIWebView) {

    // Check for cancel button

    if let url = webView.request?.url {
      if url.absoluteString.range(of: "") != nil &&
        url.absoluteString.range(of: "state=") != nil {
        navigationItem.leftBarButtonItem = nil
      } else {
        createNavigationCancelButton()
      }
    }
  }
}

// MARK: NestC2CPresenterDelegate

extension NestC2CViewController: NestC2CPresenterDelegate {
  
}
