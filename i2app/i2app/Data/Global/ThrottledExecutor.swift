//
//  ThrottledExecutor.swift
//  i2app
//
//  Arcus Team on 8/22/16.
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

@objc class ThrottledExecutor: NSObject {

  fileprivate let throttlePeriodSec: TimeInterval
  fileprivate let throttleQueue: DelayedExecutionDispatcher
  fileprivate let quiescenceQueue: DelayedExecutionDispatcher

  var quiescenceDelay: Double = 0.0
  var lastExecution: TimeInterval = 0.0
  var lastRequest: TimeInterval = 0.0
  var quiescenceTask: (() -> Void)?
  var firstTry: Bool = true

  @objc required init (throttlePeriodSec: TimeInterval, quiescencePeriodSec: TimeInterval) {
    self.throttlePeriodSec = throttlePeriodSec
    self.quiescenceDelay = quiescencePeriodSec

    self.throttleQueue = DelayedExecutionDispatcher(name: "Throttle")
    self.quiescenceQueue = DelayedExecutionDispatcher(name: "Quiescence")
  }

  /*
   * Executes the given the task on a background thread, assuring it is invoked no more frequently than
   * the throttle period.
   *
   * For example, lets say a UI slider control generates a stream of value changes every few milliseconds
   * as long as the user keeps their finger on the slider, but we don't want the platform value updated
   * more than once every three seconds. To satisfy this, create a ThrottledExecutor(3.0), then invoke
   * this method each time the slider provides a value change and wrap the call to update the platform
   * in the provided task.
   *
   * Note that the last invocation of this method will always execute (just not before the throttle period
   * expires). This assures that the "most recent" value is used.
   */
  @objc func execute (_ task: @escaping () -> Void) {

    lastRequest = Date.timeIntervalSinceReferenceDate
    let secSinceLastExecution = Date.timeIntervalSinceReferenceDate - lastExecution
    let secUntilNextExecution = throttlePeriodSec - secSinceLastExecution

    if secUntilNextExecution <= 0 {
      //NSLog("Executing throttled task now; last executed %.1f seconds ago.", secSinceLastExecution)

      throttleQueue.dispatchNow({
        self.lastExecution = Date.timeIntervalSinceReferenceDate
        self.fireQuiescenceDelay()
        task()
      })
    } else {
      // NSLog("Throttling task last executed %.1f seconds ago; waiting %.1f seconds before executing.",
      // secSinceLastExecution, secUntilNextExecution)
      throttleQueue.dispatchWithDelay(secUntilNextExecution, task: {
        self.lastExecution = Date.timeIntervalSinceReferenceDate
        self.fireQuiescenceDelay()
        task()
      })
    }
    fireQuiescenceDelay()
  }

  /*
   * Same behavior as execute:task: but assures that the first invocation of task does not occur until
   * the given time interval has been reached.
   */
  @objc func execute (_ task: @escaping () -> Void, firstNoSoonerThan: TimeInterval) {
    if firstTry {
      self.lastExecution = Date.timeIntervalSinceReferenceDate +
        (firstNoSoonerThan - throttlePeriodSec)
      self.firstTry = false
    }
    self.execute(task)
  }

  /*
   * Executes the given task after a period of quiescence (inactivty) has been reached. Quiescence
   * is defined as no calls being made to execute:task, execute:task:firstNoSoonerThan or
   * executeAfterQuiescence.
   *
   * For example, lets say you only want to send a value change to the platform after the user has
   * stopped adjusting some setting. You could wrap the platform call in the provided task and then
   * invoke this method each time the adjusts the setting.
   */
  @objc internal func executeAfterQuiescence(_ task: @escaping () -> Void) {
    self.quiescenceTask = task
    fireQuiescenceDelay()
  }

  fileprivate func fireQuiescenceDelay () {

    let secSinceLastRequest = Date.timeIntervalSinceReferenceDate - lastRequest
    let secUntilQuiescence = self.quiescenceDelay - secSinceLastRequest

    // DDLogInfo("Quiescent task will fire in %.1f seconds", secUntilQuiescence)

    quiescenceQueue.dispatchWithDelay(secUntilQuiescence, task: {
      // DDLogInfo("Executing quiescence task now.")
      self.lastExecution = Date.timeIntervalSinceReferenceDate
      self.quiescenceTask?()
    })
  }

  fileprivate class DelayedExecutionDispatcher {

    var timer: Timer = Timer()
    var task: (() -> Void)?
    let name: String

    required init (name: String) {
      self.name = name
    }

    func dispatchNow (_ task: @escaping () -> Void) {
      // DDLogInfo("\(name): Firing now.")
      DispatchQueue.global(qos: .background).async {
        task()
      }
    }

    func dispatchWithDelay (_ delay: TimeInterval, task: @escaping () -> Void) {
      // NSTimer must be managed on the same thread; i.e., can't create on one thread, invalidate on another
      DispatchQueue.main.async {
        // DDLogInfo("\(self.name): Will fire in %.1f", delay)
        self.task = task
        if self.timer.isValid {
          self.timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: delay, target: self,
                                          selector: #selector(self.onFire),
                                          userInfo: nil, repeats: false)
      }
    }

    @objc func onFire () {
      dispatchNow(self.task!)
    }
  }
}
