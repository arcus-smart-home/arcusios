//
//  AlarmActivityPresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/17/17.
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
import PromiseKit

// MARK: - AlarmActivityPresenterProtocol
protocol AlarmActivityPresenterProtocol {
  weak var delegate: GenericPresenterDelegate? { get set }
  init(delegate: GenericPresenterDelegate)
  var data: [AlarmActivitySectionViewModel] { get }
  var isFinishedLoadingSection: Bool { get }
  var selectedFilter: AlarmActivityFilter { get set }
  func fetch()
  func fetchNext()
}

// MARK: - AlarmActivityPresenterCommunications
/// AlarmActivityPresenterCommunications is used for testing and has `internal` functions
protocol AlarmActivityPresenterCommunications : class {
  func setViewModelsFromModels()

  var securityController: SecuritySubsystemAlertController? { get set }
  var safetyController: SafetySubsystemAlertController? { get set }
  var waterController: WaterSubsystemController? { get set }

  var securitySectionData: [AlarmActivitySectionViewModel] { get set }
  var smokeAndCOSectionData: [AlarmActivitySectionViewModel] { get set }
  var waterLeakSectionData: [AlarmActivitySectionViewModel] { get set }
}

// MARK: - AlarmActivityFilter
/// The Three visible sections to this presenter
public enum AlarmActivityFilter: Int {
  case securityAndPanic
  case smokeAndCO
  case waterLeak

  var title: String {
    switch self {
    case .securityAndPanic:
      return "Security & Panic"
    case .smokeAndCO:
      return "Smoke & CO"
    case .waterLeak:
      return "Water Leak"
    }
  }
  static let orderedValues = [securityAndPanic, smokeAndCO, waterLeak]
}

// MARK: - AlarmActivitySectionViewModel
/// Alarm Activity ViewModel of a Section for a Tableview or Collection View
struct AlarmActivitySectionViewModel {
  var title: String!
  var cells: [AlarmActivityCellViewModel]?

  init (title: String, cells: [AlarmActivityCellViewModel]?) {
    self.title = title
    self.cells = cells
  }
}

// MARK: - AlarmActivityCellType
/// Types of Cells in The Alarm Activity Section
enum AlarmActivityCellType {
  /// Simple Cell
  case generic
  /// Data in this cell has an activity history feed clicking it should go to a special screen
  /// provides a summary of alarm incident information.
  case expandable
}

// MARK: - AlarmActivitySegueIdentifier
/// Segues originating from the AlarmActivityViewController.
/// These Strings must match with Storyboard Segue Identifiers
enum AlarmActivitySegueIdentifier: String {
  case AlarmIncidentInformation = "AlarmIncidentInformation"
  case None = "This is an Error"
}

// MARK: - AlarmActivityCellViewModel
/// ViewModel of Alarm Activity Cell
struct AlarmActivityCellViewModel {

  var cellType: AlarmActivityCellType
  var title: String
  var subtitle: String
  ///Expects a well formatted String
  var time: String
  var date: Date
  var incidentAddress: String?
  var incidentType: String?

  var destination: AlarmActivitySegueIdentifier

  init(cellType: AlarmActivityCellType,
       title: String,
       subtitle: String,
       time: String,
       date: Date,
       destination: AlarmActivitySegueIdentifier) {
    self.cellType = cellType
    self.title = title
    self.subtitle = subtitle
    self.time = time
    self.date = date
    self.destination = destination
  }
}

// MARK: - AlarmActivityPresenter
/**
 - seealso: `AlarmActivityViewController` for the View Controller that displays this Presenter
 */
class AlarmActivityPresenter: AlarmActivityPresenterProtocol,
  AlarmActivityPresenterCommunications,
AlarmIncidentController {

  weak var delegate: GenericPresenterDelegate?

  required init(delegate: GenericPresenterDelegate) {
    self.delegate = delegate
    selectedFilter = .securityAndPanic
    self.observeChangeEvents()
  }

  var selectedFilter: AlarmActivityFilter {
    didSet {
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivityFilter)

      switch selectedFilter {
      case .securityAndPanic:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivityFilterSecurityPanic)
        data = securitySectionData
      case .smokeAndCO:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivityFilterSmokeCo)
        data = smokeAndCOSectionData
      case .waterLeak:
        ArcusAnalytics.tag(named: AnalyticsTags.AlarmsActivityFilterWater)
        data = waterLeakSectionData
      }
      currentNextToken = ""
      _isFinishedLoadingSection = true
      self.fetch()
    }
  }

  fileprivate var _isFinishedLoadingSection = false
  var isFinishedLoadingSection: Bool {
    return _isFinishedLoadingSection
  }

  var data: [AlarmActivitySectionViewModel] = [AlarmActivitySectionViewModel]() {
    didSet {
      delegate?.updateLayout()
    }
  }

  var securitySectionData: [AlarmActivitySectionViewModel] = Stubs.emptySecurityData {
    didSet {
      if selectedFilter == .securityAndPanic {
        data = securitySectionData
      }
    }
  }

  var smokeAndCOSectionData: [AlarmActivitySectionViewModel] = Stubs.emptySmokeAndCOData {
    didSet {
      if selectedFilter == .smokeAndCO {
        data = smokeAndCOSectionData
      }
    }
  }

  var waterLeakSectionData: [AlarmActivitySectionViewModel] = Stubs.emptyWaterLeakData {
    didSet {
      if selectedFilter == .waterLeak {
        data = waterLeakSectionData
      }
    }
  }

  var currentNextToken: String = ""
  var selectedHistoryModels: [NewHistoryModel] = [NewHistoryModel]()
  var allIncidents: [AlarmIncidentModel] = [AlarmIncidentModel]()

  func currentSubsystemModel() -> SubsystemModel? {
    var subsystemModel: SubsystemModel?
    switch self.selectedFilter {
    case .securityAndPanic:
      subsystemModel = self.securityController?.subsystemModel
    case .smokeAndCO:
      subsystemModel = self.safetyController?.subsystemModel
    case .waterLeak:
      subsystemModel = self.waterController?.subsystemModel
    }
    return subsystemModel
  }

  var basicFilterDate: Date = (Date() as NSDate).addingDays(-1)

  let entriesToLoadCount: Int32 = 20

  func historyResponseHandler(_ historyResponse: Any?) -> PMKPromise? {
    guard let securityHistoryResponse = historyResponse as? SubsystemListHistoryEntriesResponse else {
      return nil
    }
    let returnedHistoryModels =
      securityHistoryResponse.getResults()! // TODO: Avoid explicitly unwrapping here.

        // Convert entries data to history models
        .map({ (obj) in
          if let dict = obj as? [NSObject : AnyObject] {
            return NewHistoryModel(dictionary: dict)!
          }
          return NewHistoryModel(dictionary: [:])!
        })

        // Drop entries not visible to the user's subscription level
        .filter({ (model: NewHistoryModel) -> Bool in
          var isPremium: Bool = false
          if let premium = RxCornea.shared.settings?.isPremiumAccount() {
            isPremium = premium
          }
          if isPremium == true {
            return true
          }
          return basicFilterDate.compare(model.date as Date) != .orderedDescending
        })

    if self.currentNextToken != "" {
      self.selectedHistoryModels.append(contentsOf: returnedHistoryModels)
    } else {
      self.selectedHistoryModels = returnedHistoryModels
    }

    if let nextToken = securityHistoryResponse.getNextToken() {
      self.currentNextToken = nextToken
    } else {
      self.currentNextToken = ""
    }
    self._isFinishedLoadingSection = true
    return nil
  }

  func fetchNext() {
    guard isFinishedLoadingSection && !self.currentNextToken.isEmpty else {
      // We need to wait for the last request to finish
      return
    }

    self._isFinishedLoadingSection = false
    DispatchQueue.global(qos: .background).async {
      guard let subsystemModel = self.currentSubsystemModel()  else { return }
      _ = SubsystemsController.getSubsystemHistory(subsystemModel,
                                                   withToken: self.currentNextToken,
                                                   entriesLimit: self.entriesToLoadCount,
                                                   includeIncidents: true)
        .swiftThenInBackground(self.historyResponseHandler)
        .swiftThenInBackground({ _ in
          self.setViewModelsFromModels()
          return nil
        })
    }
  }

  func fetch() {
    self._isFinishedLoadingSection = false
    DispatchQueue.global(qos: .background).async {
      guard let subsystemModel = self.currentSubsystemModel()  else { return }
      _ = SubsystemsController.getSubsystemHistory(subsystemModel,
                                                   withToken: self.currentNextToken,
                                                   entriesLimit: self.entriesToLoadCount,
                                                   includeIncidents: true)
        .swiftThenInBackground(self.historyResponseHandler)
        .swiftThenInBackground({ _ in
          self.setViewModelsFromModels()
          return nil
        })
    }
  }

  /// Main entry points for the conversion of Models to View Models
  /// There are Three Steps broken into functions in the see also section
  /// In short, First divide the incidents by their types, second divid the incidents into days with
  /// at least the most recent 3 days, Thirdly the Incidents are transformed into ViewModels and
  /// placed into their sections. Lastly the History Items are added to the list into the correct
  /// sections
  func setViewModelsFromModels() {

    switch selectedFilter {
    case .securityAndPanic:
      self.securitySectionData = dividedByDaysLocalTime(selectedHistoryModels)
      break
    case .smokeAndCO:
      self.smokeAndCOSectionData = dividedByDaysLocalTime(selectedHistoryModels)
      break
    case .waterLeak:
      self.waterLeakSectionData = dividedByDaysLocalTime(selectedHistoryModels)
      break
    }
  }

  /// Sections are created from Incidents, sections are divided by day, and each section's
  /// history items are merged into sections
  /// sections are sorted by decending time (most recent at the top)
  func dividedByDaysLocalTime(_ history: [NewHistoryModel]) -> [AlarmActivitySectionViewModel] {

    class DateSection {
      var date: NSDate
      var section: AlarmActivitySectionViewModel
      init(date: NSDate, section: AlarmActivitySectionViewModel) {
        self.date = date
        self.section = section
      }
    }

    let dayInMin: TimeInterval = 60 * 60 * 24
    let topOfTheMorning: NSDate! = NSDate().toDay() as NSDate! // 🎩🌅
    let topOfYesterdayMorning: NSDate! = topOfTheMorning
      .addingTimeInterval(-dayInMin).toDay() as NSDate! // 🎩🌅
    let topOfDayBeforeYesterdayMorning: NSDate! = topOfTheMorning
      .addingTimeInterval(-2 * dayInMin).toDay() as NSDate! // 🎩🌅
    var newestHistoryDate: NSDate! = (topOfTheMorning as NSDate)
    var oldestHistoryDate: NSDate! = (topOfTheMorning as NSDate)

    let morningNSDate = topOfTheMorning as NSDate
    let yesterdayNSDate = topOfYesterdayMorning as NSDate

    var mostRecentDays: [DateSection] = [
      DateSection(date: topOfTheMorning,
                  section: AlarmActivitySectionViewModel(title: morningNSDate.formatDateByDay(),
                                                         cells: [AlarmActivityCellViewModel]())),
      DateSection(date: topOfYesterdayMorning,
                  section: AlarmActivitySectionViewModel(title: yesterdayNSDate.formatDateByDay(),
                                                         cells: [AlarmActivityCellViewModel]()))
    ]

    //Helper function to add to correct section
    func addVMToSectionsByDate(_ vm: AlarmActivityCellViewModel, date topOfThisMorning: NSDate ) {
      let dateToSection: DateSection? = mostRecentDays.filter({ ds -> Bool in
        return ds.date.isSameDay(with: topOfThisMorning as Date)
      }).first
      if dateToSection != nil {
        dateToSection!.section.cells?.append(vm)
      } else {
        //Create a New Section for the the incident
        mostRecentDays.append(DateSection(date: topOfThisMorning as NSDate,
                                          section: AlarmActivitySectionViewModel(
                                            title: (topOfThisMorning as NSDate).formatDateByDay(),
                                            cells: [vm] )))
      }
    }

    func hasSectionForDate(date: NSDate) -> Bool {
      for thisSection in mostRecentDays {
        if thisSection.date.toDay().compare(date.toDay()) == ComparisonResult.orderedSame {
          return true
        }
      }
      return false
    }

    // Calculate range of available history dates...
    history.forEach { history in
      let topOfThisMorning = (history.date as NSDate).toDay()

      if topOfThisMorning?.compare(oldestHistoryDate as Date) == ComparisonResult.orderedAscending {
        oldestHistoryDate = topOfThisMorning as NSDate!
      } else if topOfThisMorning?.compare(newestHistoryDate as Date) == ComparisonResult.orderedDescending {
        newestHistoryDate = topOfThisMorning as NSDate!
      }
    }

    // ... then generate empty ("You have no alarm activity") sections for each date
    var thisDate: NSDate! = oldestHistoryDate
    while thisDate.compare(newestHistoryDate as Date) == ComparisonResult.orderedAscending {
      if !hasSectionForDate(date: thisDate) {
        mostRecentDays
          .append(DateSection(date: thisDate,
                              section: AlarmActivitySectionViewModel(title: thisDate.formatDateByDay(),
                                                                     cells:[])))
      }
      thisDate = (thisDate!.addingDays(1) as NSDate).toDay() as NSDate
    }

    // ... finally, populate date sections with history entires
    history.forEach { history in
      var vm = viewModelForHistory(history)
      if history.isIncident() {
        vm = viewModelForIncident(history)
      }

      if let topOfThisMorning = (history.date as NSDate).toDay() as NSDate? {
        addVMToSectionsByDate(vm, date: topOfThisMorning)
      }
    }

    return mostRecentDays
      .map({ ds -> DateSection in
        var section = ds.section
        let sortedCells = section.cells?.sorted(by: { (c1, c2) -> Bool in
          c1.date.timeIntervalSince1970 > c2.date.timeIntervalSince1970
        })
        section.cells = sortedCells
        return DateSection(date: ds.date, section: section)
      })
      .sorted(by: { (ds1: DateSection, ds2: DateSection) -> Bool in
        return ds1.date.timeIntervalSince1970 > ds2.date.timeIntervalSince1970
      })
      .map { ds -> AlarmActivitySectionViewModel in
        return ds.section
    }
  }

  /// Helper function to turn an incident into a cell view model
  func viewModelForIncident(_ incident: NewHistoryModel) -> AlarmActivityCellViewModel {
    let title = incident.subjectName
    let subtitle = incident.longMessage
    let time = (incident.date as NSDate).formatTimeStamp()
    let destination = AlarmActivitySegueIdentifier.AlarmIncidentInformation

    var vm = AlarmActivityCellViewModel(cellType: .expandable, title: title, subtitle: subtitle, time: time!,
                                        date: incident.date as Date, destination: destination)
    vm.incidentAddress = incident.subjectAddress
    vm.incidentType = incident.subjectName
    return vm
  }

  /// Helper function to turn an incident into a cell view model
  func viewModelForHistory(_ history: NewHistoryModel) -> AlarmActivityCellViewModel {
    let cellType: AlarmActivityCellType = .generic
    let title = history.subjectName
    let subtitle = history.longMessage
    let time = (history.date as NSDate).formatTimeStamp()
    let destination = AlarmActivitySegueIdentifier.None
    return AlarmActivityCellViewModel(cellType: cellType, title: title, subtitle: subtitle,
                                      time: time!, date: history.date as Date, destination: destination)
  }

  // MARK: - Subsystems

  var securityController: SecuritySubsystemAlertController? =
    SubsystemsController.sharedInstance().securityController
  var safetyController: SafetySubsystemAlertController? =
    SubsystemsController.sharedInstance().safetyController
  var waterController: WaterSubsystemController? =
    SubsystemsController.sharedInstance().waterController

  func observeChangeEvents() {
    let controllerChanged = #selector(AlarmActivityPresenter.controllerChanged(_:))

    NotificationCenter.default.addObserver(self, selector: controllerChanged,
                                           name: Notification.Name.subsystemInitialized,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: controllerChanged,
                                           name: Notification.Name.subsystemUpdated,
                                           object: nil)
  }

  @objc func controllerChanged(_ note: Notification) {
    if let securitySubSystemController = SubsystemsController.sharedInstance().securityController {
      self.securityController = securitySubSystemController
    }
    if let safetyController = SubsystemsController.sharedInstance().safetyController {
      self.safetyController = safetyController
    }
    if let waterController = SubsystemsController.sharedInstance().waterController {
      self.waterController = waterController
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

private class Stubs {
  static let emptySecurityData: [AlarmActivitySectionViewModel] = [
    AlarmActivitySectionViewModel(title: "Today", cells:nil),
    AlarmActivitySectionViewModel(title: "Yesterday", cells:nil)
  ]

  static let emptySmokeAndCOData: [AlarmActivitySectionViewModel] = [
    AlarmActivitySectionViewModel(title: "Today", cells:nil),
    AlarmActivitySectionViewModel(title: "Yesterday", cells:nil)
  ]

  static let emptyWaterLeakData: [AlarmActivitySectionViewModel] = [
    AlarmActivitySectionViewModel(title: "Today", cells:nil),
    AlarmActivitySectionViewModel(title: "Yesterday", cells:nil)
  ]
}
