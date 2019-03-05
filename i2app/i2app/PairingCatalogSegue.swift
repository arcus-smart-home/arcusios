//
//  PairingCatalogSegue.swift
//  i2app
//
//  Created by Arcus Team on 2/23/18.
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

/// Enumeration of all allowed Segues in the PairingCatalog.storyboard
enum PairingCatalogSegue: String {

  // Modal Transitions

  case showHubRequired
  case showHubOffline
  case showRequiredClientVersion
  case showDeviceRequired
  case showAdvancedUserPairingPopup

  /// Transition to pairing Instructions
  case showPairingInstructions

  /// transition between brands and device list
  /// - seealso: CatalogBrandListViewController
  case showDeviceList

  case showPairingCart
  
  /// Transitions to the screen that allows for kit device activation.
  case showKitSetup
  
  case showPairingWarning

  /// confirmation popup for exiting pairing, Normal
  case showExitPairingNormalPopup

  /// confirmation popup for exiting pairing, Warning Pink
  case showExitPairingWarningPopup

  case PairingInstructionSteps = "PairingInstructionsSegue"

  /// Helper to map the DeviceModelVerification enum to possible Segues
  /// - seealso: DeviceModelVerificationPresenter
  static func segueFor(deviceModelVerification: DeviceModelVerification) -> PairingCatalogSegue {
    switch deviceModelVerification {
    case .hubRequired:
      return PairingCatalogSegue.showHubRequired
    case .hubOffline:
      return PairingCatalogSegue.showHubOffline
    case .deviceRequired(_):
      return PairingCatalogSegue.showDeviceRequired
    case .mayContinue:
      return PairingCatalogSegue.showPairingInstructions
    case .requiredClientVersion:
      return PairingCatalogSegue.showRequiredClientVersion
    }
  }
}

/// There are a bunch of segues that are performed in the Product Catalog that need the same
/// preparation as they are performed. This protocol helps View Controllers share the logic for
/// preparation of those segues. This prevents duplication in Search, Brands & Devices List
protocol PairingCatalogSeguePerformer: class { }

extension PairingCatalogSeguePerformer where Self: UIViewController {

  /// A Helper function for view controllers to share required segue logic in one place
  /// This helper also handles the logic for setting a few other delegates during a segue as well
  func prepareShared(segue: UIStoryboardSegue, sender: Any?) {
    guard let id = segue.identifier,
      let segueId = PairingCatalogSegue(rawValue: id) else {
        /// fail gracefully and quietly
        return
    }
    if segueId == .showPairingCart,
      let shouldStartSearching = sender as? Bool,
      let dest = segue.destination as? PairingCartViewController {
      dest.startSearchingOnLoad = shouldStartSearching
    } else if segueId == .showPairingInstructions,
      let viewModel = sender as? CatalogDeviceViewModel,
      let dest = segue.destination as? PairingStepsParentViewController {
      dest.deviceName = viewModel.name
      dest.deviceShortName = viewModel.shortName
      dest.productAddress = viewModel.address
    } else if segueId == .showDeviceRequired,
      let requiredVC = segue.destination as? DeviceRequiredViewController,
      let deviceModel = sender as? CatalogDeviceViewModel,
      let productId = deviceModel.deviceRequired {
      requiredVC.productId = productId
    } else if segueId == .showExitPairingNormalPopup || segueId == .showExitPairingWarningPopup,
      let dest = segue.destination as? ExitPairingPopupViewController,
      let exitPairingDelegate = segue.source as? ExitPairingPopupDelegate {
       dest.delegate = exitPairingDelegate
    } else if segueId == .showAdvancedUserPairingPopup,
      let dest = segue.destination as? AdvancedPairingPopupViewController,
      let delegate = segue.source as? AdvancedPairingPopupDelegate {
      dest.delegate = delegate
    }
  }
}
