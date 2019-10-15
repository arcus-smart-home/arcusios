//
//  AlarmTrackerPresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/10/17.
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

import Cornea

let kProMonConfirmColor = UIColor(red: 225.0/255.0,
                                  green: 24.0/255.0,
                                  blue: 19.0/255.0,
                                  alpha: 1.0)
let kProMonCancelColor = UIColor(red: 0.0,
                                 green: 174.0/255.0,
                                 blue: 239.0/255.0,
                                 alpha: 1.0)
let kCancelDisabledColor = UIColor(red: 136.0/255.0,
                                   green: 136.0/255.0,
                                   blue: 136.0/255.0,
                                   alpha: 1.0)
let kTrackerInactiveColor = UIColor(red: 204.0/255.0,
                                    green: 204.0/255.0,
                                    blue: 204.0/255.0,
                                    alpha: 1.0)

private let kCancelPopupTitle = "Cancel Alarm"

enum IncidentTrackerServiceLevel: Int {
  case basic
  case premium
  case proMonitored
}

enum IncidentTrackerButtonState {
  case hidden
  case cancel
  case cancelConfirm
}

protocol IncidentTrackerDelegate: class {
  func updateLayout()
  func updateTracker()
  func updateHistory()
  func updateCountdown()
  func fullLayoutRefresh()
  func dismissTracker()
  func showClearingPopup(_ title: String, message: String)
}

protocol IncidentTrackerPresenter {
  var delegate: IncidentTrackerDelegate? { get set }

  // MARK: Public Configuration Properties

  var alarmTitle: String { get set }
  var placeName: String { get set }
  var alarmEvents: [AlarmTrackerStateViewModel]? { get set }
  var alarmHistory: [AlarmTrackerHistoryViewModel]? { get set }
  var alarmEventActiveIndex: Int { get }
  var incidentColor: UIColor { get }
  var incidentBackgroundColor: UIColor { get }
  var proBadgeVisible: Bool { get }
  var isHubDown: Bool { get }
  var offlineBannerText: String { get }
  var offlinePopupTitleText: String { get }
  var offlinePopupSubText: String { get }

  // MARK: Presenter Loading/Unloading Methods

  func setUp(_ incident: AlarmIncidentModel?)
  func tearDown()

  // MARK: User Action Methods

  func confirm()
  func cancel()

  // MARK: Configuration Functions.

  func incidentButtonState() -> IncidentTrackerButtonState
  func cancelButtonEnabled() -> Bool
  func confirmButtonEnabled() -> Bool
  func trackerScrollingEnabled() -> Bool
}

class AlarmTrackerPresenter: IncidentTrackerPresenter,
  AlarmSubsystemController,
  AlarmIncidentController,
BatchNotificationObserver {

  // MARK: Public Properties

  weak var delegate: IncidentTrackerDelegate?
  var subsystemModel: SubsystemModel
  var subsystemName: String
  var alarmIncident: AlarmIncidentModel?
  var incidentId: String

  // MARK: Public Configuration Properties

  var alarmTitle: String = ""
  var placeName: String = ""

  var alarmEvents: [AlarmTrackerStateViewModel]?

  var alarmEventActiveIndex: Int {
    // Events should always be greater than two given 'padding' events.
    if alarmEvents != nil {
      if alarmEvents!.count > 2 {
        return alarmEvents!.count - 2
      }
    }
    return -1
  }

  var alarmHistory: [AlarmTrackerHistoryViewModel]?

  var incidentColor: UIColor {
    let type = NavigationBarAppearanceManager.sharedInstance.currentColorScheme
    if type != .none {
      return type.cellTintColor
    } else if alertState == .prealert {
      return Appearance.securityBlue
    }
    return kCancelDisabledColor
  }

  var incidentBackgroundColor: UIColor {
    if serviceLevel == .basic {
      let type = NavigationBarAppearanceManager.sharedInstance.currentColorScheme
      if type != .none {
        return incidentColor.withAlphaComponent(0.2)
      }
    }
    return UIColor.clear
  }

  var proBadgeVisible: Bool {
    return (serviceLevel == .proMonitored) && (incidentColor != Appearance.waterLeakTeal)
  }
  
  private(set) var isHubDown = false
  private(set) var offlineBannerText = ""
  private(set) var offlinePopupTitleText = ""
  private(set) var offlinePopupSubText = ""

  // MARK: Private Properties

  fileprivate var cancelButtonPressed: Bool = false
  fileprivate var prealertPeriodCountDown: Int = 0
  fileprivate var prealertPeriodTimer: Timer?
  fileprivate var alertState: IncidentAlertState? {
    if let incident: AlarmIncidentModel = self.alarmIncident {
      return IncidentAlertState(rawValue: getAlertState(incident))
    }
    return nil
  }
  fileprivate var isMonitored: Bool {
    if let incident: AlarmIncidentModel = self.alarmIncident {
      return getMonitored(incident)
    }
    return false
  }
  fileprivate var serviceLevel: IncidentTrackerServiceLevel {
    guard let settings = RxCornea.shared.settings else { return .basic }

    if settings.isProMonitoredAccount() {
      return .proMonitored
    } else if settings.isPremiumAccount() {
      return .premium
    }
    return .basic
  }

  // MARK: LifeCycle

  required init(delegate: IncidentTrackerDelegate,
                subsystemModel: SubsystemModel,
                incidentId: String) {
    self.delegate = delegate
    self.subsystemModel = subsystemModel
    self.subsystemName = subsystemModel.name as String
    self.incidentId = incidentId

    observeBatchNotifications(alertStateNotifications(),
                              selector: #selector(alarmStateChanged(_:)))
    observeBatchNotifications(incidentNotifications(),
                              selector: #selector(alarmIncidentUpdated(_:)))
    observeBatchNotifications(subsystemClearedNotifications(),
                              selector: #selector(subsystemModelCleared(_:)))

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleHubChange),
                                           name: Notification.Name.subsystemUpdated,
                                           object: nil)

    if let incident: AlarmIncidentModel = fetchIncident(incidentId) {
      setUp(incident)
    } else {
      fetchData()
    }
  }

  // MARK: Presenter Loading/Unloading Methods

  func setUp(_ incident: AlarmIncidentModel?) {
    guard incident != nil else {
      return
    }

    DispatchQueue.global(qos: .background).async {
      self.alarmIncident = incident

      self.setUpAlarmTitle(self.alarmIncident!)
      self.setUpPlaceName(self.alarmIncident!)

      if self.alertState == .prealert {
        self.addPrealertPeriodTimer()
      } else {
        self.removePrealertPeriodTimer()
      }

      self.setUpTrackerEvents(self.alarmIncident!)
      self.setUpTrackerHistory(self.alarmIncident!)
      
      self.setUpOffline()

      DispatchQueue.main.async {
        self.delegate?.updateLayout()
      }
    }
  }

  func tearDown() {
    delegate = nil
    removeAllBatchNotificationObservers()
    removePrealertPeriodTimer()
  }

  // MARK: User Action Methods

  func confirm() {
    DispatchQueue.global(qos: .background).async {
      if self.alarmIncident != nil {
        _ = self.verifyOnModel(self.alarmIncident!)
        DispatchQueue.main.async {
          self.delegate?.fullLayoutRefresh()
        }
      }
    }
  }

  func cancel() {
    DispatchQueue.global(qos: .background).async {
      if self.alarmIncident != nil {
        self.cancelButtonPressed = true
        _ = self.cancelOnModel(self.alarmIncident!).swiftThen({
          response in
          guard let response = response as? AlarmIncidentCancelResponse else { return nil }
          self.removePrealertPeriodTimer()

          guard let title = response.getWarningTitle(),
            let warningMessage = response.getWarningMessage(),
            title.count > 0 && warningMessage.count > 0 else {
              self.delegate?.dismissTracker()
              return nil
          }

          self.delegate?.fullLayoutRefresh()
          let message = warningMessage.replacingOccurrences(of: "%s", with: kMonitoringServiceNumber)

          self.delegate?.showClearingPopup(title, message: message)
          return nil
        }).swiftCatch({
          error in

          // Error
          if let error = error as? NSError, error.userInfo["code"] as? String == "UnknownDevice" {

            let title = NSLocalizedString("HUB LOST CONNECTION", comment: "")
            var subtext = ""

            if let settings = RxCornea.shared.settings, settings.isProMonitoredAccount() == true {
              subtext = NSLocalizedString(
                "Arcus cannot stop sounds in the home until you reconnect the hub.\n\nFor your safety, the " +
                "Monitoring Station will call to assist & attempt to dispatch authorities if left " +
                "unanswered. To cancel dispatch, call 1-0",
                comment: "")
            } else {
              subtext = NSLocalizedString(
                "Arcus cannot stop sounds in the home until you reconnect the hub.",
                comment: "")
            }

            self.delegate?.showClearingPopup(title, message: subtext)
          }
          
          return nil
        })
      }
    }
  }

  // MARK: Configuration Functions.

  func incidentButtonState() -> IncidentTrackerButtonState {
    if isActiveIncident() == false {
      return .hidden
    }

    switch serviceLevel {
    case .basic:
      return .cancel
    case .premium:
      return .cancel
    case .proMonitored:
      if isMonitored == true {
        return .cancelConfirm
      }
      return .cancel
    }
  }

  func isActiveIncident() -> Bool {
    if let currentIncidentAddress = currentIncident(subsystemModel) {
      if let address = alarmIncident?.address as String? {
        return address == currentIncidentAddress
      }
    }
    return false
  }

  func cancelButtonEnabled() -> Bool {
    if let incident: AlarmIncidentModel = alarmIncident {
      return !getCancelled(incident)
    }
    return false
  }

  func confirmButtonEnabled() -> Bool {
    if let incident: AlarmIncidentModel = alarmIncident {
      return !getConfirmed(incident)
    }
    return false
  }

  func trackerScrollingEnabled() -> Bool {
    return serviceLevel != .basic
  }

  // MARK: Private Functions: Notification Handling

  @objc fileprivate func alarmStateChanged(_ notification: Notification) {
    DispatchQueue.global(qos: .background).async {
      guard self.isActiveIncident() != false else { return }
      if let incident = self.fetchIncident(self.incidentId) {
        if self.getAlertState(incident) == IncidentAlertState.cancelling.rawValue ||
          self.getAlertState(incident) == IncidentAlertState.complete.rawValue {
          if self.cancelButtonPressed == false {
            DispatchQueue.main.async {
              ArcusAnalytics.tag(named: AnalyticsTags.AlarmsTrackerAutoDismissed)
              self.delegate?.dismissTracker()
            }
          }
        }
      }
    }
  }

  @objc fileprivate func alarmIncidentUpdated(_ notification: Notification) {
    setUp(fetchIncident(incidentId))
  }

  @objc private func subsystemUpdated(_ notification: NSNotification) {
    if let subsystem = SubsystemCache.sharedInstance.subsystem(subsystemName) {
        subsystemModel = subsystem
        setUp(fetchIncident(incidentId))
    }
  }

  @objc private func subsystemModelCleared(_ notification: Notification) {
    DispatchQueue.main.async {
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsTrackerAutoDismissed)
      self.delegate?.dismissTracker()
    }
  }

  @objc private func handleHubChange() {
    DispatchQueue.main.async {
      self.setUpOffline()
      self.delegate?.updateLayout()
    }
  }

  // MARK: Private Functions: Data Fetching

  fileprivate func fetchData() {
    DispatchQueue.global(qos: .background).async {
      _ = self.refreshIncident(self.incidentId)
        .swiftThen({ refreshedIncident in
          if let incident = refreshedIncident as? AlarmIncidentModel {
            if incident.address as String == self.incidentId {
              self.setUp(incident)
              return nil
            }
          }
          // If setup isn't called, then dismiss the tracker.
          DispatchQueue.main.async {
            ArcusAnalytics.tag(named: AnalyticsTags.AlarmsTrackerAutoDismissed)
            self.delegate?.dismissTracker()
          }
          return nil
        })
        .swiftCatch({ _ in
          // If fetching incident ends in error, then dismiss the tracker.
          DispatchQueue.main.async {
            ArcusAnalytics.tag(named: AnalyticsTags.AlarmsTrackerAutoDismissed)
            self.delegate?.dismissTracker()
          }
          return nil
        })
    }
  }

  fileprivate func fetchIncident(_ incidentAddress: String) -> AlarmIncidentModel? {
    return RxCornea.shared.modelCache?
      .fetchModel(incidentAddress) as? AlarmIncidentModel
  }

  // MARK: Private Functions: SetUp Handling

  func setUpAlarmTitle(_ incident: AlarmIncidentModel) {
    let alertType = getAlert(incident)
    var alarmSuffix = " EVENT"
    if isActiveIncident() == true {
      alarmSuffix = " ALARM"
    }

    if alertType == kEnumAlarmIncidentAlertWATER {
      alarmTitle = alertType + " LEAK" + alarmSuffix
    } else {
      alarmTitle = alertType + alarmSuffix
    }
  }

  func setUpPlaceName(_ incident: AlarmIncidentModel) {
    let placeId = self.getPlaceId(incident)

    if let placeModel = RxCornea.shared.modelCache?
      .fetchModel(PlaceModel.addressForId(placeId)) as? PlaceModel {
      self.placeName = placeModel.name as String
    }
  }

  func setUpTrackerEvents(_ incident: AlarmIncidentModel) {
    if let tracker: [[String : AnyObject]] = self.getTracker(incident) as? [[String : AnyObject]] {
      DispatchQueue.main.async {
        self.alarmEvents = self.updateEventTrackerSegments(self.trackerEventViewModels(tracker))
        self.delegate?.updateTracker()
      }
    }
  }

  func setUpTrackerHistory(_ incident: AlarmIncidentModel) {
    _ = self.listHistoryEntries(100, token: "", model: self.alarmIncident!).swiftThen({ response in
      guard let response = response as? AlarmIncidentListHistoryEntriesResponse else { return nil }
      if let historyItems: [[String : AnyObject]] = response
        .getResults() as? [[String : AnyObject]] {
        DispatchQueue.main.async {
          self.alarmHistory = self.trackerHistoryViewModels(historyItems)
          self.delegate?.updateHistory()
        }
      }
      return nil
    })
  }
  
  func setUpOffline() {
    guard let hub = RxCornea.shared.settings?.currentHub,
      let lastChangeDate = hub.lastChange,
      hub.isDown else {
        isHubDown = false
        offlineBannerText = ""
        return
    }
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    timeFormatter.calendar = Calendar(identifier: .gregorian)
    let formattedTime = timeFormatter.string(from: lastChangeDate)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E MMM d"
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    let formattedDate = dateFormatter.string(from: lastChangeDate)
    
    var dateText = "\(formattedTime) on \(formattedDate)"
    if Calendar.current.isDateInToday(lastChangeDate) {
      dateText = formattedTime
    }
    
    isHubDown = true
    offlineBannerText = NSLocalizedString("Hub Lost Connection at \(dateText)", comment: "")
  }

  func updateEventTrackerSegments(_ events: [AlarmTrackerStateViewModel]) -> [AlarmTrackerStateViewModel] {
    var updatedEvents: [AlarmTrackerStateViewModel] = [AlarmTrackerStateViewModel]()
    for (index, event) in events.enumerated() {
      if index == 0 || index == events.count - 1 {
        updatedEvents.append(event)
        continue
      }

      if let eventVM = event as? AlarmEventViewModel {
        if index != 0 && index != events.count - 1 {
          let adjustedIndex = index - 1
          let adjustedCount = events.count - 2
          let updatedEvent = configureTrackerStateSegments(eventVM,
                                                           serviceLevel: serviceLevel,
                                                           isActive: isActiveIncident(),
                                                           index: adjustedIndex,
                                                           eventCount:adjustedCount)
          updatedEvents.append(updatedEvent)
        } else {
          updatedEvents.append(eventVM)
        }
      }
    }

    return updatedEvents
  }

  // MARK: Private Functions: ViewModel Helpers.

  fileprivate func trackerEventViewModels(_ tracker: [[String : AnyObject]]) -> [AlarmTrackerStateViewModel] {
    var eventModels: [AlarmTrackerStateViewModel] = [AlarmTrackerStateViewModel]()

    // Add Empty ViewModel to pad Tracker
    eventModels.append(AlarmEventViewModel())

    for (index, event) in tracker.enumerated() {
      let trackerEvent = trackerEventViewModel(event,
                                               serviceLevel: serviceLevel,
                                               index: index,
                                               eventCount: tracker.count)
      eventModels.append(trackerEvent)
    }

    // Add Empty ViewModel to pad Tracker
    eventModels.append(AlarmEventViewModel())

    return eventModels
  }

  // swiftlint:disable:next line_length
  fileprivate func trackerHistoryViewModels(_ history: [[String : AnyObject]]) -> [AlarmTrackerHistoryViewModel] {
    var historyModels: [AlarmTrackerHistoryViewModel] = [AlarmTrackerHistoryViewModel]()

    for historyItem in history {
      historyModels.append(trackerHistoryViewModel(historyItem))
    }

    return historyModels
  }

  fileprivate func trackerEventViewModel(_ tracker: [String : AnyObject],
                                         serviceLevel: IncidentTrackerServiceLevel,
                                         index: Int,
                                         eventCount: Int) -> AlarmEventViewModel {
    let eventViewModel: AlarmEventViewModel = AlarmEventViewModel()

    let isActive: Bool = isActiveIncident()
    let isLast: Bool = (index == eventCount - 1)

    eventViewModel.beginHidden = isLast && isActive
    eventViewModel.activeColor = trackerIconColor()
    eventViewModel.inactiveColor = kTrackerInactiveColor

    if let message = tracker["message"] as? String {
      eventViewModel.name = message
    }

    if let state = tracker["state"] as? String {
      if let eventState: IncidentTrackerState = IncidentTrackerState(rawValue: state) {
        eventViewModel.iconName = imageName(eventState)
        if eventViewModel.iconName == "time" {
          eventViewModel.isCountdownState = true
          eventViewModel.countdownEnd = getPrealertEndtime(alarmIncident!)
          if let countdownEnd: Date = eventViewModel.countdownEnd as Date? {
            self.prealertPeriodCountDown = abs(Int(Date().timeIntervalSince(countdownEnd)))
          }
        }

        eventViewModel.ringStateActive = activeRingState(eventState)
        eventViewModel.ringStateInactive = inactiveRingState(eventState, serviceLevel: serviceLevel)
      }
    }

    return configureTrackerStateSegments(eventViewModel,
                                         serviceLevel: serviceLevel,
                                         isActive: isActive,
                                         index: index,
                                         eventCount: eventCount)
  }

  fileprivate func trackerHistoryViewModel(_ historyItem: [String : AnyObject]) -> AlarmHistoryViewModel {
    let historyViewModel: AlarmHistoryViewModel = AlarmHistoryViewModel()

    if let subjectName: String = historyItem["subjectName"] as? String {
      historyViewModel.name = subjectName
    }

    //    if let subjectAddress: String = historyItem["subjectAddress"] as? String {
    //      print("subjectAddress: \(subjectAddress)")
    //    }

    if let longMessage: String = historyItem["longMessage"] as? String {
      historyViewModel.description = longMessage
    }

    //    if let shortMessage: String = historyItem["shortMessage"] as? String {
    //      print("shortMessage: \(shortMessage)")
    //    }
    //
    //    if let key: String = historyItem["key"] as? String {
    //      print("key: \(key)")
    //    }

    if let timestamp: Double = historyItem["timestamp"] as? Double {
      let datetime: Date = Date(timeIntervalSince1970: timestamp / 1000)
      historyViewModel.timestamp = (datetime as NSDate).formatTimeStamp()
    }

    return historyViewModel
  }

  private func trackerIconColor() -> UIColor {
    if alarmIncident != nil {
      let alertType = getAlert(alarmIncident!)
      switch alertType {
      case kEnumAlarmIncidentAlertSECURITY:
        if alertState == .prealert {
          return kTrackerInactiveColor
        }
        return Appearance.securityBlue
      case kEnumAlarmIncidentAlertSMOKE, kEnumAlarmIncidentAlertCO:
        return Appearance.smokeAndCORed
      case kEnumAlarmIncidentAlertPANIC:
        return Appearance.panicGrey
      case kEnumAlarmIncidentAlertWATER:
        return Appearance.waterLeakTeal
      default: break
      }
    }
    return kTrackerInactiveColor
  }

  fileprivate func imageName(_ state: IncidentTrackerState) -> String? {
    switch state {
    case .prealert:
      return "time"
    case .alert:
      return "alarm"
    case .cancelled:
      return "cancel_alarm"
    case .dispatching:
      return "headset"
    case .dispatched:
      return "badge"
    case .dispatchFailed:
      return "response_waiting"
    case .dispatchCancelled, .dispatchRefused:
      return "cancel_badge"
    }
  }

  fileprivate func activeRingState(_ state: IncidentTrackerState) -> AlarmTrackerIconState {
    return .activeIcon
  }

  fileprivate func inactiveRingState(_ state: IncidentTrackerState,
                                     serviceLevel: IncidentTrackerServiceLevel) -> AlarmTrackerIconState {
    if serviceLevel == .basic {
      return .hidden
    }
    return .inactiveIcon
  }

  fileprivate func configureTrackerStateSegments(_ eventViewModel: AlarmEventViewModel,
                                                 serviceLevel: IncidentTrackerServiceLevel,
                                                 isActive: Bool,
                                                 index: Int,
                                                 eventCount: Int) -> AlarmEventViewModel {
    let updatedModel = eventViewModel
    if serviceLevel == .basic {
      updatedModel.leftSegmentActiveType = .noSegment
      updatedModel.leftSegmentInactiveType = .noSegment
      if isActive == false {
        updatedModel.activeColor = kTrackerInactiveColor
      }
      updatedModel.rightSegmentActiveType = .noSegment
      updatedModel.rightSegmentInactiveType = .noSegment
    } else {
      if index == 0 {
        if eventCount > 1 {
          updatedModel.rightSegmentActiveType = .inactive
          updatedModel.activeColor = UIColor.clear
        } else {
          if isActive == true {
            updatedModel.rightSegmentActiveType = .activeNone
          } else {
            updatedModel.rightSegmentActiveType = .inactive
            updatedModel.activeColor = UIColor.clear
          }
        }
        updatedModel.leftSegmentActiveType = .noSegment
        updatedModel.leftSegmentInactiveType = .noSegment
        updatedModel.rightSegmentInactiveType = .inactive

      } else if index != eventCount - 1 {
        updatedModel.leftSegmentActiveType = . inactive
        updatedModel.leftSegmentInactiveType = . inactive
        updatedModel.activeColor = UIColor.clear
        updatedModel.inactiveColor = kTrackerInactiveColor
        updatedModel.rightSegmentActiveType = . inactive
        updatedModel.rightSegmentInactiveType = . inactive
      } else {
        if isActive == true {
          updatedModel.leftSegmentActiveType = .inactiveActive
          updatedModel.leftSegmentInactiveType = .inactive
          updatedModel.rightSegmentActiveType = .activeNone
          updatedModel.rightSegmentInactiveType = .inactive
        } else {
          updatedModel.leftSegmentActiveType = . inactive
          updatedModel.leftSegmentInactiveType = . inactive
          updatedModel.activeColor = UIColor.clear
          updatedModel.inactiveColor = kTrackerInactiveColor
          updatedModel.rightSegmentActiveType = . noSegment
          updatedModel.rightSegmentInactiveType = . noSegment
        }
      }
    }

    return updatedModel
  }

  // MARK: Private Functions: Timer Handling

  @objc fileprivate func updatePrealertGracePeriod() {
    DispatchQueue.global(qos: .background).async {
      self.prealertPeriodCountDown -= 1

      if self.prealertPeriodCountDown < 1 {
        self.removePrealertPeriodTimer()
      } else {
        DispatchQueue.main.async {
          self.delegate?.updateCountdown()
        }
      }
    }
  }

  fileprivate func addPrealertPeriodTimer() {
    DispatchQueue.main.async {
      guard self.prealertPeriodTimer == nil else {
        return
      }

      self.prealertPeriodTimer = Timer.scheduledTimer(
        timeInterval: TimeInterval(1.0),
        target: self,
        selector: #selector(self.updatePrealertGracePeriod),
        userInfo: nil,
        repeats: true)
    }
  }

  fileprivate func removePrealertPeriodTimer() {
    DispatchQueue.main.async {
      guard self.prealertPeriodTimer != nil else {
        return
      }

      self.prealertPeriodTimer?.invalidate()
      self.prealertPeriodTimer = nil
      self.prealertPeriodCountDown = 0
    }
  }

  // MARK: Private Functions: Convenience Methods

  fileprivate func subsystemUpdatedNotifications() -> [Notification.Name] {
    return [Notification.Name.subsystemCacheInitialized,
            Notification.Name.subsystemCacheUpdated]
  }

  fileprivate func subsystemClearedNotifications() -> [Notification.Name] {
    return [Notification.Name.subsystemCacheCleared]
  }

  fileprivate func alertStateNotifications() -> [Notification.Name] {
    return [Model.attributeChangedNotificationName(kAttrAlarmIncidentAlertState)]
  }

  fileprivate func incidentNotifications() -> [Notification.Name] {
    return[Model.attributeChangedNotificationName(kAttrAlarmSubsystemAlarmState),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentPlaceId),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentStartTime),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentPrealertEndtime),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentEndTime),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentMonitoringState),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentAlert),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentAdditionalAlerts),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentTracker),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentCancelled),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentCancelledBy),
           Model.attributeChangedNotificationName(kAttrAlarmIncidentMonitored),
           Notification.Name( kEvtAlarmIncidentCOAlert),
           Notification.Name(kEvtAlarmIncidentPanicAlert),
           Notification.Name(kEvtAlarmIncidentSecurityAlert),
           Notification.Name(kEvtAlarmIncidentSmokeAlert),
           Notification.Name(kEvtAlarmIncidentWaterAlert),
           Notification.Name(kEvtAlarmIncidentCompleted),
           Notification.Name.activeAlarmIncidentChanged,
           Notification.Name(kEvtAlarmIncidentHistoryAdded)]
  }
}
