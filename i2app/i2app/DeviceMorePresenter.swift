//
//  DeviceMorePresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/14/17.
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

/*
 `DeviceMoreActionType` enum is used to define the types of actions that may be triggered by selecting a
 `DeviceMoreItemViewModel`.
 **/
enum DeviceMoreActionType {
  case none
  case popup
  case segue
  case toggle
}

/*
 `DeviceMorePresenter` defines the expected properties of a presenter used by a `MVPDeviceMoreViewController`
 **/
protocol DeviceMorePresenter {
  weak var delegate: DeviceMorePresenterDelegate? { get set }
  var device: DeviceModel { get set }
  var moreItems: [DeviceMoreItemViewModel] { get }

  /**
   Performs the action specified by the viewModel.

   - Parameter viewModel: The `DeviceMoreItemViewModel` chosen to determine the action 
   to perform.
   */
  func performAction(_ viewModel: DeviceMoreItemViewModel)

  /**
   Used to update the presenter when the device is updated.

   - Parameter notification: The received `Notification`
   */
  func deviceUpdated(_ notification: Notification)

  /**
   Used to respond to the user pressing `Remove Device`
   */
  func onRemoveDevicePressed()

  /**
   Used to remove the device.
   */
  func removeDevice()

  /**
   Prepare a viewController to be presented.  Used to configure a ViewController that will
   be presented from a segue specified by a viewModel.

   - Parameter viewController: The UIViewController to prepare.
   */
  func prepareDesination(_ viewController: UIViewController)

  // EXTENDED:

  /**
   Add/Remove a device as a favorite.
   */
  func toggleFavorite()

  /**
   Used to check if the device is a favorite.

   - Returns: Bool indicating if device is a favorite.
   */
  func isFavorite() -> Bool
}

/*
 `DeviceMorePresenter` extension
 **/
extension DeviceMorePresenter {
  func toggleFavorite() {
    FavoriteController.toggleFavorite(self.device)
  }

  func isFavorite() -> Bool {
    return FavoriteController.modelIsFavorite(device)
  }
}

/*
 `DeviceMorePresenterDelegate` defines the expected behavior of a class that implements `DeviceMorePresenter`
 **/
protocol DeviceMorePresenterDelegate: class {
  /**
   Used to update the layout of DeviceMorePresenterDelegate.
   */
  func updateLayout()

  /**
   Used to have DeviceMorePresenterDelegate perform a specified segue.

   - Parameter identifier: The string of the segue to perform.
   */
  func performSegue(_ identifier: String)

  /**
   Used to have DeviceMorePresenterDelegate present a specified viewController.

   - Parameter viewController: The UIViewController to be preseneted.
   */
  func present(_ viewController: UIViewController?)

  /**
   Used by DeviceMorePresenterDelegate to show the removeDevice popup.
   */
  func displayRemovePopup()
}

/*
 `DeviceMoreItemViewModel` defines the expected properties of a ViewModel implemented by `DeviceMorePresenter`
 **/
protocol DeviceMoreItemViewModel {
  var title: String { get set }
  var description: String { get set }
  var info: String? { get set }
  var actionType: DeviceMoreActionType { get set }
  var actionIdentifier: String { get set }
  var cellIdentifier: String { get set }
  var metaData: [String: AnyObject]? { get set }
}
