//
//  AlarmGracePeriodsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/9/17.
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

struct AlarmGracePeriodsModel {

  var shouldSound: Bool
  /// A list of tuples that have a Grace period Type and a Time Interval in correct presentation order
  var timeIntervals: [GracePeriodTimeInterval]

  init(shouldSound: Bool,
       timeIntervals: [GracePeriodTimeInterval]) {
    self.shouldSound = shouldSound
    self.timeIntervals = timeIntervals
  }

}

struct GracePeriodTimeInterval {
  var type: AlarmGracePeriodType
  var interval: Int

  init( _ type: AlarmGracePeriodType, _ interval: Int ) {
    self.type = type
    self.interval  = interval
  }

  var stringForInterval: String {
    return "\(interval)s"
  }
}

func ==(lhs: GracePeriodTimeInterval, rhs: GracePeriodTimeInterval) -> Bool {
  return lhs.type == rhs.type && lhs.interval == rhs.interval
}

extension GracePeriodTimeInterval: Equatable {}

enum AlarmGracePeriodType: String {

  case EntranceDelay
  case ExitDelay
  case PartialEntranceDelay
  case PartialExitDelay

  var title: String {
    switch self {
    case .EntranceDelay:
      return "ON - ENTRANCE DELAY"
    case .ExitDelay:
      return "ON - EXIT DELAY"
    case .PartialEntranceDelay:
      return "PARTIAL - ENTRANCE DELAY"
    case .PartialExitDelay:
      return "PARTIAL - EXIT DELAY"
    }
  }

  var subtitle: String {
    switch self {
    case .EntranceDelay:
      return "Time Needed to Disarm After Entering Home"
    case .ExitDelay:
      return "Time Needed to Exit Before the Alarm Arms"
    case .PartialEntranceDelay:
      return "Time Needed to Disarm After Entering Home"
    case .PartialExitDelay:
      return "Time Needed to Exit Before the Alarm Arms"
    }
  }
}

protocol AlarmGracePeriodsPresenterProtocol {

  var delegate: GenericPresenterDelegate? { get set }
  init(delegate: GenericPresenterDelegate)
  var data: AlarmGracePeriodsModel { get }
  func timeIntervalOfType(_ type: AlarmGracePeriodType,
                          didChangeToInterval interval: Int )
  func toggleShouldSound(_ should: Bool)
}

/// Testable code needs to set the data to a fixture
protocol AlarmGracePeriodsPresenterProtocolCommunications {
  var data: AlarmGracePeriodsModel { get set }
  var securitySubSystemController: SecuritySubsystemAlertController? { get set }
  func createViewModels(_ securitySubSystemController: SecuritySubsystemAlertController)
}

class AlarmGracePeriodsPresenter: AlarmGracePeriodsPresenterProtocol,
AlarmGracePeriodsPresenterProtocolCommunications {

  weak var delegate: GenericPresenterDelegate?

  required init(delegate: GenericPresenterDelegate) {
    self.delegate = delegate
    self.observeChangeEvents()
    if let securitySubSystemController = securitySubSystemController {
      createViewModels(securitySubSystemController)
      self.data.shouldSound = securitySubSystemController.getSoundsEnabled()
    }
  }

  var data: AlarmGracePeriodsModel = Stubs.defaultData {
    didSet {
      delegate?.updateLayout()
    }
  }

  func timeIntervalOfType(_ type: AlarmGracePeriodType, didChangeToInterval interval: Int ) {

    let obj = data.timeIntervals.filter({return $0.type == type }).first!
    let idx = self.data.timeIntervals.index(of: obj)!
    self.data.timeIntervals[idx] = GracePeriodTimeInterval(type, interval)
    self.persist(self.data.timeIntervals[idx])
    delegate?.updateLayout()

    switch type {
    case .EntranceDelay:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsMoreGraceOnEntrance)
    case .ExitDelay:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsMoreGraceOnExit)
    case .PartialEntranceDelay:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsMoreGracePartialEntrance)
    case .PartialExitDelay:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsMoreGracePartialExit)
    }
  }

  func toggleShouldSound(_ should: Bool) {
    self.data.shouldSound = should
    self.persistShouldSound(should)
    delegate?.updateLayout()
  }

  func createViewModels(_ securitySubSystemController: SecuritySubsystemAlertController) {
    self.data = AlarmGracePeriodsModel(shouldSound: true,
                                       timeIntervals:
      [
        GracePeriodTimeInterval(.EntranceDelay,
                                Int(securitySubSystemController.getEntranceDelaySecForModeOn())),
        GracePeriodTimeInterval(.ExitDelay,
                                Int(securitySubSystemController.getExitDelaySecForModeOn()) ),
        GracePeriodTimeInterval(.PartialEntranceDelay,
                                Int(securitySubSystemController.getEntranceDelaySecForModePartial())),
        GracePeriodTimeInterval(.PartialExitDelay,
                                Int(securitySubSystemController.getExitDelaySecForModePartial()))
      ])
  }

  fileprivate func persistShouldSound(_ shouldSound: Bool ) {
    DispatchQueue.global(qos: .background).async {
      guard let ctrl = self.securitySubSystemController else { return }
      ctrl.setSoundsEnabled(shouldSound)
    }
  }

  fileprivate func persist(_ interval: GracePeriodTimeInterval ) {
    DispatchQueue.global(qos: .background).async {
      guard let ctrl = self.securitySubSystemController else { return }
      switch interval.type {
      case .EntranceDelay:
        ctrl.setEntranceDelaySecForModeOn(Int32(interval.interval))
      case .ExitDelay:
        ctrl.setExitDelaySecForModeOn(Int32(interval.interval))
      case .PartialEntranceDelay:
        ctrl.setEntranceDelaySecForModePartial(Int32(interval.interval))
      case .PartialExitDelay:
        ctrl.setExitDelaySecForModePartial(Int32(interval.interval))
      }
    }
  }

  // MARK: - SecuritySubsystemAlertController

  var securitySubSystemController: SecuritySubsystemAlertController? =
    SubsystemsController.sharedInstance().securityController

  func observeChangeEvents() {
    let center = NotificationCenter.default
    let changeSelector = #selector(AlarmGracePeriodsPresenter.securitySubSystemChanged(_:))
    let onEntranceDelaySecNoteName = Model.attributeChangedNotificationName("%@:ON")
    center.addObserver(self, selector: changeSelector, name: onEntranceDelaySecNoteName, object: nil)
    let partialEntranceDelaySecNoteName = Model.attributeChangedNotificationName("%@:PARTIAL")
    center.addObserver(self, selector: changeSelector, name: partialEntranceDelaySecNoteName, object: nil)
    let onExitDelaySecNoteName = Model.attributeChangedNotificationName("%@:ON")
    center.addObserver(self, selector: changeSelector, name: onExitDelaySecNoteName, object: nil)
    let partialExitDelaySecNoteName = Model.attributeChangedNotificationName("%@:PARTIAL")
    center.addObserver(self, selector: changeSelector, name: partialExitDelaySecNoteName, object: nil)
  }

  @objc fileprivate func securitySubSystemChanged(_ note: Notification) {
    guard let securitySubSystemController = SubsystemsController.sharedInstance().securityController else {
      return
    }
    self.securitySubSystemController = securitySubSystemController
    createViewModels(self.securitySubSystemController!)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  class Stubs {
    static let defaultData = AlarmGracePeriodsModel(shouldSound: true,
                                                    timeIntervals: [
                                                      GracePeriodTimeInterval(.EntranceDelay, 30),
                                                      GracePeriodTimeInterval(.ExitDelay, 30),
                                                      GracePeriodTimeInterval(.PartialEntranceDelay, 30),
                                                      GracePeriodTimeInterval(.PartialExitDelay, 30)
      ])
  }
}
