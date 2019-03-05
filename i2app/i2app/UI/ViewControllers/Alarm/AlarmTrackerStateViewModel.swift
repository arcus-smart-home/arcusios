//
//  AlarmTrackerStateViewModel.swift
//  i2app
//
//  Created by Arcus Team on 2/14/17.
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

protocol AlarmTrackerStateViewModel {
  var name: String! { get set }
  var iconName: String? { get set }
  var isCountdownState: Bool { get set }
  var countdownEnd: Date? { get set }
  var activeColor: UIColor! { get set }
  var inactiveColor: UIColor! { get set }
  var leftSegmentActiveType: SegmentType! { get set }
  var rightSegmentActiveType: SegmentType! { get set }
  var leftSegmentInactiveType: SegmentType! { get set }
  var rightSegmentInactiveType: SegmentType! { get set }
  var ringStateActive: AlarmTrackerIconState! { get set }
  var ringStateInactive: AlarmTrackerIconState! { get set }
  var beginHidden: Bool { get set }

  func attributedCountdownText() -> NSAttributedString?
}

class AlarmEventViewModel: AlarmTrackerStateViewModel {
  var name: String! = ""
  var iconName: String?
  var isCountdownState: Bool = false
  var countdownEnd: Date?
  var activeColor: UIColor! = UIColor.clear
  var inactiveColor: UIColor! = UIColor.clear
  var leftSegmentActiveType: SegmentType! = .noSegment
  var rightSegmentActiveType: SegmentType! = .noSegment
  var leftSegmentInactiveType: SegmentType! = .noSegment
  var rightSegmentInactiveType: SegmentType! = .noSegment
  var ringStateActive: AlarmTrackerIconState! = .hidden
  var ringStateInactive: AlarmTrackerIconState! = .hidden
  var beginHidden: Bool = false

  func attributedCountdownText() -> NSAttributedString? {
    if countdownEnd != nil {
      let countInterval = Date().timeIntervalSince(countdownEnd!)
      if countInterval < 0 {
        let countDown: Int = abs(Int(countInterval))
        let countText = formatTimerText(countDown)
        if countText.string != "0s" {
          return countText
        }
      }
    }
    return nil
  }

  fileprivate func formatTimerText(_ seconds: Int) -> NSAttributedString {
    let attributes: [String: AnyObject] =
      [NSFontAttributeName: UIFont(name: "Avenir Next", size: 36)!,
       NSForegroundColorAttributeName: UIColor(red: 255,
        green: 255,
        blue: 255,
        alpha: 0.7)]

    let subAttributes: [String: AnyObject] =
      [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!,
       NSForegroundColorAttributeName: UIColor(
        red: 255, green: 255, blue: 255, alpha: 0.7),
       NSBaselineOffsetAttributeName: 7.0 as AnyObject]

    let time = NSMutableAttributedString(string: "\(seconds)", attributes: attributes)
    let sub = NSAttributedString(string: "s", attributes:subAttributes)

    time.append(sub)
    return time
  }
}
