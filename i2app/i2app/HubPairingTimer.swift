//
//  HubPairingTimer.swift
//  i2app
//
//  Created by Arcus Team on 6/1/17.
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

/// Delegate will handle a tic of the timer with this callback
protocol HubPairingTimerDelegate: class {
  func timeCallback(withTimer timer: HubPairingTimer,
                    startTime: TimeInterval, timePassed: TimeInterval)
}

/// Helper class for a timer that will give callbacks at a certain rate.
/// Removed a lot of Timer code from the HubPairing Presenter
class HubPairingTimer {
  private weak var delegate: HubPairingTimerDelegate?
  private var startTime: Date!
  private var timeout: TimeInterval!
  private var updateInterval: TimeInterval!
  private var callbackTimer: Timer?

  required init(delegate: HubPairingTimerDelegate,
                timeout: TimeInterval,
                updateInterval: TimeInterval) {
    self.delegate = delegate
    self.timeout = timeout
    self.updateInterval = updateInterval
  }

  /// Would be private if it could but the `Timer` needs to call this function
  @objc func callUpdate() {
    guard callbackTimer != nil else { return }
    let timePassed = Date().timeIntervalSince(startTime)
    let ref = startTime.timeIntervalSinceReferenceDate
    if timePassed > timeout {
      delegate?.timeCallback(withTimer: self, startTime: ref, timePassed: ref + timeout)
    } else {
      delegate?.timeCallback(withTimer: self, startTime: ref, timePassed: ref + timePassed)
    }
  }

  /// Create the Timer and delegates start getting tics back after the first delay
  func startUpdates() {
    startTime = Date()
    callbackTimer = Timer.scheduledTimer(
      timeInterval: updateInterval,
      target: self,
      selector: #selector(HubPairingTimer.callUpdate),
      userInfo: nil,
      repeats: true)
  }

  /// Destroys then cleans up the functionality of the HubPairingTimer
  func cancelUpdate() {
    if let callbackTimer = callbackTimer {
      callbackTimer.invalidate()
    }
    callbackTimer = nil
    delegate = nil
  }
}
