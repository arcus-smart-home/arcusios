//
//  ExitPairingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/13/18.
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
import RxSwift
import Cornea

enum ExitPairingPopupType {
  case warning // pink
  case normal //white
}

enum ExitPairingStrategy {
  case exit
  case shouldDisplayPopup( type: ExitPairingPopupType )
}

protocol ExitPairingPresenter: ArcusPairingDeviceCapability, ArcusPairingSubsystemCapability {
  /// Return an `ExitPairingStrategy` given Pairing Cart conditions, specifically
  /// if something is misconfigured of mispaired in the cart
  /// - parameter cache: a default value is provided in the extension
  func prepareToExitPairing(cache: (ArcusModelCache & RxSwiftModelCache)?,
                            pairingSubsystem: SubsystemModel?) -> ExitPairingStrategy
}

extension ExitPairingPresenter {
  /// static helper function to clean up the next function default param for cache
  private static func optionalModelCache() -> (ArcusModelCache & RxSwiftModelCache)? {
    if let cache = RxCornea.shared.modelCache as? (ArcusModelCache & RxSwiftModelCache) {
      return cache
    }
    return nil
  }

  /// helper to reduce size of the next function definition `startMonitoringPairing(cache:pairingSubsystem:)`
  private static func pairingSubsystem() -> SubsystemModel? {
    return SubsystemCache.sharedInstance.pairingSubsystem()
  }

  func prepareToExitPairing(cache: (ArcusModelCache & RxSwiftModelCache)? = Self.optionalModelCache(),
                            pairingSubsystem: SubsystemModel? = Self.pairingSubsystem())
    -> ExitPairingStrategy {

      guard let cache = cache,
        let pairingSubsystem = pairingSubsystem,
        let pairingDeviceModels: [PairingDeviceModel] =
        cache.fetchModels(Constants.pairingDeviceNamespace) as? [PairingDeviceModel],
        let subsystemDevices = getPairingSubsystemPairingDevices(pairingSubsystem) else {
          return .exit
      }
      let meaningfulDevices = pairingDeviceModels.filter { model -> Bool in
        var containsKitTag = false
        if let tags = model.tags as? [String] {
          for tag in tags where tag.lowercased() == "kit" {
            containsKitTag = true
            break
          }
        }

        return subsystemDevices.contains(model.address) && !containsKitTag
      }
      guard meaningfulDevices.count > 0 else {
        return .exit
      }

      let misconfigured = meaningfulDevices
        .filter({
          let state = self.getPairingDevicePairingState($0)
          return state == .misconfigured || state == .mispaired
        })

      if misconfigured.count > 0 {
        return .shouldDisplayPopup(type: .warning)
      }
      return .shouldDisplayPopup(type: .normal)
  }
}
