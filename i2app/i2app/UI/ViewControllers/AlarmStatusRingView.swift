//
//  AlarmStatusRingView.swift
//  i2app
//
//  Created by Arcus Team on 12/19/16.
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

import UIKit

enum AlarmRingState {
  case solidDisabled
  case solidEnabled
  case segmentedDisabled
  case segmentedEnabled
}

class AlarmStatusRingViewModel {
  var ringState: AlarmRingState! = .solidDisabled
  var statusText: NSAttributedString!
  var ringSegments: [ArcusAlarmRingSegmentState]?

  required init(state: AlarmRingState!,
                statusText: NSAttributedString!,
                segments: [ArcusAlarmRingSegmentState]?) {
    self.ringState = state
    self.statusText = statusText
    self.ringSegments = segments
  }
}

class AlarmStatusRingView: ArcusAlarmRingView {
  @IBOutlet var statusLabel: UILabel!

  func configureRing(_ viewModel: AlarmStatusRingViewModel) {
    statusLabel.attributedText = viewModel.statusText

    if viewModel.ringState == .solidDisabled {
      segments = [.inactive]
    } else if viewModel.ringState == .solidEnabled {
      segments = [.active]
    } else if viewModel.ringSegments != nil {
      if viewModel.ringState == .segmentedDisabled {
        var disabledSegments: [ArcusAlarmRingSegmentState] = [ArcusAlarmRingSegmentState]()
        for _ in viewModel.ringSegments! {
          disabledSegments.append(.inactive)
        }
        segments = disabledSegments
      } else {
        segments = viewModel.ringSegments!
      }
    }
  }
}
