//
//  CacheLoadingStatus.swift
//  i2app
//
//  Created by Arcus Team on 12/15/17.
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

public struct CacheLoadingStatus: OptionSet, RawRepresentable {
  public let rawValue: UInt

  public init(rawValue: UInt) {
    self.rawValue = rawValue
  }
  
  public static let alarmsLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 0)
  public static let devicesLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 1)
  public static let hubLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 2)
  public static let rulesLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 3)
  public static let peopleLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 4)
  public static let placesLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 5)
  public static let productsLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 6)
  public static let scenesLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 7)
  public static let schedulersLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 8)
  public static let subsystemsLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 9)
  public static let pairingDevicesLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 1 << 10)

  // rawValue represents union of all combined loading states.
  public static let modelsLoaded: CacheLoadingStatus = CacheLoadingStatus(rawValue: 0x7FF)
  public static let modelsLoadedExcludeProductCatalogAlarms: CacheLoadingStatus =
    CacheLoadingStatus.modelsLoaded.symmetricDifference([.productsLoaded, .alarmsLoaded, .pairingDevicesLoaded])
  public static let dashboardReady: CacheLoadingStatus = [devicesLoaded,
                                                   hubLoaded,
                                                   peopleLoaded,
                                                   scenesLoaded,
                                                   subsystemsLoaded]
}

extension CacheLoadingStatus: CustomDebugStringConvertible {
  public var debugDescription: String {
    // swiftlint:disable:next line_length
    return "\n alarmsLoaded: \(self.contains(.alarmsLoaded)), \n devicesLoaded: \(self.contains(.devicesLoaded)), \n hubLoaded: \(self.contains(.hubLoaded)), \n rulesLoaded: \(self.contains(.rulesLoaded)), \n peopleLoaded: \(self.contains(.peopleLoaded)), \n placesLoaded: \(self.contains(.placesLoaded)), \n productsLoaded: \(self.contains(.productsLoaded)), \n scenesLoaded: \(self.contains(.scenesLoaded)), \n schedulersLoaded: \(self.contains(.schedulersLoaded)), \n subsystemsLoaded: \(self.contains(.subsystemsLoaded)), \n pairingDevicesLoaded: \(self.contains(.pairingDevicesLoaded)) "
  }
}
