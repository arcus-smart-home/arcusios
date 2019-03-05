//
//  ClipTimeFilter.swift
//  i2app
//
//  Created by Arcus Team on 8/18/17.
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

enum ClipTimeFilter {

  case allDays
  case today
  case yesterday
  case last24Hours
  case last7Days
  case last30Days
  case last3Months
  case at3MonthsAndOlder
  case at6MonthsAndOlder
  case olderThan1Year

  var filterName: String {
    switch self {
    case .allDays:
      return NSLocalizedString("All Days", comment: "")
    case .today:
      return NSLocalizedString("Today", comment: "")
    case .yesterday:
      return NSLocalizedString("Yesterday", comment: "")
    case .last24Hours:
      return NSLocalizedString("24 Hours Ago", comment: "")
    case .last7Days:
      return NSLocalizedString("Last 7 Days", comment: "")
    case .last30Days:
      return NSLocalizedString("Last 30 Days", comment: "")
    case .last3Months:
      return NSLocalizedString("Last 3 Months", comment: "")
    case .at3MonthsAndOlder:
      return NSLocalizedString("3 Months & Older", comment: "")
    case .at6MonthsAndOlder:
      return NSLocalizedString("6 Months & Older", comment: "")
    case .olderThan1Year:
      return NSLocalizedString("Older Than 1 Year", comment: "")
    }
  }

  /// Time nearest to Date.now()
  var filterStartTime: Date {
    switch self {
    case .allDays, .today, .last7Days, .last30Days, .last3Months, .last24Hours:
      return Date()
    case .yesterday:
      return Date.yesterdayStartMidnight
    case .at3MonthsAndOlder:
      return Date.threeMonthsAgo
    case .at6MonthsAndOlder:
      return Date.sixMonthsAgo
    case .olderThan1Year:
      return Date.oneYearAgo
    }
  }

  /// Time furthest from Date.now()
  var filterEndTime: Date {
    switch self {
    case .allDays, .at3MonthsAndOlder, .at6MonthsAndOlder, .olderThan1Year:
      return Date(timeIntervalSince1970: 0)
    case .today:
      return Date.yesterdayStartMidnight
    case .yesterday:
      return Date.yesterdayEndMidnight
    case .last24Hours:
      return Date.twentyFourHoursAgo
    case .last7Days:
      return Date.sevenDaysAgo
    case .last30Days:
      return Date.thirtyDaysAgo
    case .last3Months:
      return Date.threeMonthsAgo
    }
  }

  static let allClipTimeFilters: [ClipTimeFilter] =
    [.allDays, .today, .yesterday, .last7Days, .last30Days, .last3Months, .at3MonthsAndOlder,
     .at6MonthsAndOlder, .olderThan1Year]
  
  static let defaultFilter: ClipTimeFilter = .allDays
}
