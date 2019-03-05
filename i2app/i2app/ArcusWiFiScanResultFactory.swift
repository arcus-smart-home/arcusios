//
//  ArcusWiFiScanResultFactory.swift
//  i2app
//
//  Created by Arcus Team on 7/10/18.
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

import RxSwift

protocol ArcusWiFiScanResultFactory {
  /**
   Check if WiFIScanResult has more results to read.

   - Parameters:
   - resultJson: Dictionary of the result from WiFiScan.

   - Returns: `Bool` indicating if more results need to be read.
   */
  func scanHasMoreResults(_ resultJson: [String: AnyObject]) -> Bool

  /**
   Create array of `WiFiScanItem` from the WiFiScan result.

   - Parameters:
   - resultJson: Dictionary of the result from WiFiScan.

   - Returns: `[WiFiScanItem]` parsed from the result.
   */
  func buildScanItemsForResult(_ resultJson: [String: AnyObject]) -> [WiFiScanItem]

  /**
   Merge array of `WiFiScanItem` from the WiFiScan result with existing items.

   - Parameters:
   - newItems: `[WiFiScanItem]` of the new items to merge with existing.
   - existingItems: `[WiFiScanItem]` of the existing items to merge with new.

   - Returns: `[WiFiScanItem]` of the merged items.
   */
  func mergeScanItems(_ newItems: [WiFiScanItem], existingItems: [WiFiScanItem]) -> [WiFiScanItem]
}

extension ArcusWiFiScanResultFactory {
  func scanHasMoreResults(_ resultJson: [String: AnyObject]) -> Bool {
    if let moreResults = resultJson["more"] as? String, moreResults == "true" {
      return true
    }
    return false
  }

  func buildScanItemsForResult(_ resultJson: [String: AnyObject]) -> [WiFiScanItem] {
    guard let scanResults = resultJson["scanresults"] as? [[String: AnyObject]] else {
      return []
    }
    return scanResults.map { return WiFiScanItem(json: $0) }.sorted(by: >)
  }

  func mergeScanItems(_ newItems: [WiFiScanItem],
                      existingItems: [WiFiScanItem]) -> [WiFiScanItem] {
    // Prefer newer results to older results
    var uniques = Set<WiFiScanItem>(newItems)
    uniques = uniques.union(existingItems)
    return Array(uniques).sorted(by: >)
  }
}
