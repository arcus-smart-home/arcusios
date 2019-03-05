//
//  Date+Util.swift
//  i2app
//
//  Created by Arcus Team on 8/14/17.
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

extension Date {

  func isSameDay(asDate date: Date) -> Bool {
    let lhs = Calendar.current.dateComponents([.era, .year, .month, .day], from: self)
    let rhs = Calendar.current.dateComponents([.era, .year, .month, .day], from: date)
    return lhs.day == rhs.day &&
      lhs.month == rhs.month &&
      lhs.year == rhs.year &&
      lhs.era == rhs.era
  }

  /// Returns the start of the day in the current Calendar
  func startOfDay(_ calendar: Calendar = Calendar.current) -> Date {
    return calendar.startOfDay(for: self)
  }
  
  init(mightnightToDate startDate: Date, days: Int, calendar: Calendar = Calendar.current) {
    self = calendar.date(byAdding: .day, value: days, to: startDate.startOfDay(calendar))!
  }

  init(monthsFromStartDate startDate: Date, months: Int, calendar: Calendar = Calendar.current) {
    self = calendar.date(byAdding: .month, value: months, to: startDate.startOfDay(calendar))!
  }

  init(yearsFromStartDate startDate: Date, years: Int, calendar: Calendar = Calendar.current) {
    self = calendar.date(byAdding: .year, value: years, to: startDate.startOfDay(calendar))!
  }

  static let yesterdayStartMidnight = Date.init(mightnightToDate: Date(), days: 0)
  static let yesterdayEndMidnight = Date.init(mightnightToDate: Date(), days: -1)
  static let sevenDaysAgo = Date.init(mightnightToDate: Date(), days: -7)
  static let twentyFourHoursAgo = Date.init(timeInterval: -3600*24, since: Date())
  static let thirtyDaysAgo = Date.init(mightnightToDate: Date(), days: -30)
  static let threeMonthsAgo = Date.init(monthsFromStartDate: Date(), months: -3)
  static let sixMonthsAgo = Date.init(monthsFromStartDate: Date(), months: -3)
  static let oneYearAgo = Date.init(yearsFromStartDate: Date(), years: -1)
}
