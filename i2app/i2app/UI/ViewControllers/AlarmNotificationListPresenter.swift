//
//  AlarmNotificationListPresenter.swift
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

struct AlarmNotificationListConstants {
  static let maxNotifiedCount = 6

  static let maxNotifiedWarningTitle = NSLocalizedString("TOO MANY PEOPLE SELECTED",
                                                         comment: "Max Notified Warning Title")

  static let maxNotifiedWarningMessage =
    NSLocalizedString("A Maximum of 6 people can be added to your Alarm Notification List",
                      comment: "Max Notified Warning Message")
}

enum NotificationPersonAddState {
  case selectedAndCannotBeChanged
  case selected
  case notSelected
}

// represents a user
public struct AlarmNotificationListModel {

  static var defaultImageName: String {
    return ""
  }

  var userName: String
  // Location of the Profile Imag eon Disk
  var userProfileImagePath: URL?
  // Defaults to true
  var canReorder: Bool
  // Defaults to true
  var canDelete: Bool
  // Defaults to .NotSelected
  var addState: NotificationPersonAddState

  var userId: String

  init(withCurrentPersonModel person: PersonModel) {
    self.userName = person.fullName
    self.canReorder = false
    canDelete = false
    addState = .selectedAndCannotBeChanged
    userId = person.address as String
  }

  init(withPersonModel person: PersonModel) {
    self.userName = person.fullName
    self.canReorder = true
    self.canDelete = true
    addState = .notSelected
    userId = person.address as String
  }

  init(_ userName: String) {
    self.userName = userName
    self.userProfileImagePath = nil
    canReorder = true
    canDelete = true
    userId = ""
    addState = .notSelected
  }
}

extension AlarmNotificationListModel: CustomDebugStringConvertible {
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
      return "\(userName): canReorder: \(canReorder) canDelete: \(canDelete) addState: \(addState)"
  }
}

public func == (lhs: AlarmNotificationListModel, rhs: AlarmNotificationListModel) -> Bool {
  return lhs.userName == rhs.userName &&
    lhs.canReorder == rhs.canReorder &&
    lhs.canDelete == rhs.canDelete &&
    lhs.addState == rhs.addState
}

extension AlarmNotificationListModel: Equatable {}

public enum AlarmNotificationTexts {
  case basic
  case premium
  case promod

  var titleText: String? {
    switch self {
    case .basic:
      return NSLocalizedString("A triggered alarm will notify you via push notification and a phone call.",
                               comment: "Alarm Notification List Title Basic")
    case .premium:
      return NSLocalizedString("A triggered alarm will notify the people below in the order they are listed.",
                               comment: "Alarm Notification List Title Premium")
    case .promod:
      return NSLocalizedString("A triggered alarm will result in a phone call from the Monitoring Station.",
                               comment: "Alarm Notification List Title Premium")
    }
  }

  var subtitleText: String? {
    switch self {
    case .basic:
      return nil//NSLocalizedString("", comment: "Alarm Notification List Subtitle Basic")
    case .premium:
      return nil//NSLocalizedString("", comment: "Alarm Notification List Subtitle Premium")
    case .promod:
      return NSLocalizedString("Triggered water leak alarms will result in a push notification and " +
        "automated phone call from Arcus.", comment: "Alarm Notification List Subtitle Premium")
    }
  }
}

public protocol AlarmNotificationListDelegate: class {
  func updateLayout()
  func displayListErrorNotification()
}

public protocol AlarmNotificationListPresenterProtocol: class {
  var delegate: AlarmNotificationListDelegate? { get set }
  init(delegate: AlarmNotificationListDelegate)

  /// True if People can be added to the data list
  var canEditPeopleList: Bool { get }

  /// People that will receive notifications
  var notifiedPeople: [AlarmNotificationListModel] { get set }
  /// People that can be selected to receive notifications
  var allPeople: [AlarmNotificationListModel] { get }
  /// The text that should display on the view, title and subtitle
  var text: AlarmNotificationTexts { get }

  /// views use this select and deselect people
  func toggleModelAtIndex(_ idx: Int)

  /// views use this to change the order of the list
  func movePersonAtRow(_ atRow: Int, toRow: Int)

  /// request new data view controllers may call this on viewWillAppear for example
  func fetch()

  /// Save the state to the platform, save is not called automatically
  func saveChanges()
}

/// Communications: parts that deal with I/O but the Delegate doesn't need to know about
/// Exposes internals for easier testing
protocol AlarmNotificationListPresenterProtocolCommunications: AlarmNotificationListPresenterProtocol {
  var allPeople: [AlarmNotificationListModel] { get set }
  func setViewModelsFromModels(models: [(PersonModel, Bool)],
                               accountOwner: PersonModel,
                               editEnabled: Bool)
  func viewModelsForSaving() -> [[String:AnyObject]]
}

/// Presenter to display a list of people who will be notified if an Alarm triggers
/// This list should have basic CRUD abilities
class AlarmNotificationListPresenter: AlarmNotificationListPresenterProtocol,
AlarmNotificationListPresenterProtocolCommunications, AlarmSubsystemController, AlarmModelController {

  weak var delegate: AlarmNotificationListDelegate?

  required init(delegate: AlarmNotificationListDelegate) {
    self.delegate = delegate
    if let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() {
      self.subsystemModel = alarmSubsystem
    }
    self.text = AlarmNotificationListPresenter.configuredTexts()
    self.observeChangeEvents()
  }

  fileprivate class func configuredTexts() -> AlarmNotificationTexts {
    guard let settings = RxCornea.shared.settings else { return .basic }
    if settings.isProMonitoredAccount() {
      return .promod
    } else if settings.isPremiumAccount() {
      return .premium
    }
    return .basic
  }

  // MARK: - AlarmSubsystemController

  fileprivate var subsystemModel: SubsystemModel = SubsystemModel()

  fileprivate func observeChangeEvents() {

    let changeSelector =  #selector(AlarmNotificationListPresenter.alarmSubsystemNotification(_:))

    NotificationCenter.default.addObserver(self,
                                           selector: changeSelector,
                                           name: Notification.Name.subsystemCacheInitialized,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: changeSelector,
                                           name: Notification.Name.subsystemCacheUpdated,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: changeSelector,
                                           name: Notification.Name.subsystemCacheCleared,
                                           object: nil)
    let accountLevelName = Model.attributeChangedNotificationName(kAttrPlaceServiceLevel)
    NotificationCenter.default.addObserver(self,
                                           selector:changeSelector,
                                           name: accountLevelName,
                                           object: nil)
    let callTreeEnabledName = Model.attributeChangedNotificationName(kAttrSecuritySubsystemCallTreeEnabled)
    NotificationCenter.default.addObserver(self,
                                           selector:changeSelector,
                                           name: callTreeEnabledName,
                                           object: nil)
    let callTreeChangedName = Model.attributeChangedNotificationName(kAttrAlarmSubsystemCallTree)
    NotificationCenter.default.addObserver(self,
                                           selector:changeSelector,
                                           name: callTreeChangedName,
                                           object: nil)
  }

  @objc func alarmSubsystemNotification(_ note: Notification) {
    guard let alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem() else {
      canEditPeopleList = false
      notifiedPeople = [AlarmNotificationListModel]()
      allPeople = [AlarmNotificationListModel]()
      self.delegate?.updateLayout()
      return
    }
    self.text = AlarmNotificationListPresenter.configuredTexts()
    self.subsystemModel = alarmSubsystem
    DispatchQueue.main.async {
      self.fetch()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func fetch() {
    get()
  }

  /// get data from the platform
  /// This function hides code that deals with the network in hopes that another class will handle
  /// this in the future
  fileprivate func get() {
    guard let acctOwner: PersonModel = AccountModel.accountOwner() else { return }

    let models = self.callTree(self.subsystemModel) as [AnyObject]
    var personModels = [PersonModel]()
    for m in models {
      if let personAddress = m.object(forKey: "person") as? String,
        let person = RxCornea.shared.modelCache?.fetchModel(personAddress) as? PersonModel {
        personModels.append(person)
      }
    }
    if personModels.count < models.count {
      return
    }

    let allPeople = models.map({ (m) -> (PersonModel, Bool) in
      let personID = m.object(forKey: "person") as? String
      let enabled = m.object(forKey: "enabled") as? NSNumber
      let person = personModels.filter({ p -> Bool in
        p.address as String == personID
      }).first!

      if enabled != nil {
        return (person, enabled!.boolValue)
      } else {
        return (person, false)
      }
    })
    self.canEditPeopleList = {
      if let subsystemController = SubsystemsController.sharedInstance().securityController {
        return subsystemController.isCallTreeEnabled
      }
      return false
    }()
    self.setViewModelsFromModels(models: allPeople,
                                 accountOwner: acctOwner,
                                 editEnabled: self.canEditPeopleList)
  }

  func saveChanges() {
    let viewModelsForSaving = self.viewModelsForSaving()
    let enabledVMs = viewModelsForSaving.filter { dict -> Bool in
      guard let enabled = dict["enabled"] as? NSNumber else {
        return false
      }
      return enabled.boolValue
    }
    guard enabledVMs.count <= AlarmNotificationListConstants.maxNotifiedCount else {
      delegate?.displayListErrorNotification()
      return
    }
    post()
  }

  fileprivate func post() {
    DispatchQueue.global(qos: .background).async {
      _ = self.configureCallTree(self.subsystemModel, tree: self.viewModelsForSaving() as [AnyObject])
    }
  }

  /// Please note that the currentUser is injected to this function in the hopes that in the future
  /// the global object will be removed
  func setViewModelsFromModels(models: [(PersonModel, Bool)],
                               accountOwner: PersonModel,
                               editEnabled: Bool) {
    guard editEnabled else {
      allPeople = [AlarmNotificationListModel(withCurrentPersonModel: accountOwner)]
      notifiedPeople = [AlarmNotificationListModel(withCurrentPersonModel: accountOwner)]
      delegate?.updateLayout()
      return
    }

    var vms = models.filter { (arg) -> Bool in
      let (m, _) = arg
      return !m.isAccountOwner
      }
      .map { (m, enabled) -> AlarmNotificationListModel in
        var vm = AlarmNotificationListModel(withPersonModel: m)
        if enabled {
          vm.addState = .selected
        } else {
          vm.addState = .notSelected
        }
        return vm
    }
    vms.insert(AlarmNotificationListModel(withCurrentPersonModel: accountOwner), at: 0)
    allPeople = vms
    notifiedPeople = vms.filter({
      return $0.addState == .selected || $0.addState == .selectedAndCannotBeChanged
    })
    sortNotifiedToAll()
    delegate?.updateLayout()
  }

  func viewModelsForSaving() -> [[String:AnyObject]] {
    return self.allPeople.map({ (vm) -> [String:AnyObject] in
      var built = [String: AnyObject]()
      built["person"] = vm.userId as AnyObject?
      if vm.addState != .notSelected {
        built["enabled"] = NSNumber(value: true)
      } else {
        built["enabled"] = NSNumber(value: false)
      }
      return built
    })
  }

  func toggleModelAtIndex(_ idx: Int) {
    var model = allPeople[idx]
    switch model.addState {
    case .selectedAndCannotBeChanged:
      return
    case .selected:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsNotificationRemoved)
      notifiedPeople = notifiedPeople.filter({$0.userName != model.userName})
      model.addState = .notSelected
    case .notSelected:
      ArcusAnalytics.tag(named: AnalyticsTags.AlarmsNotificationAdded)
      model.addState = .selected
      notifiedPeople.append(model)
    }
    allPeople[idx] = model
    sortNotifiedToAll()
    if trimNotified() > 0 {
      delegate?.displayListErrorNotification()
    }
    delegate?.updateLayout()
  }

  /// True if People can be reordered or selected in the people list
  /// If Premium or Professional then an edit button is visible. In Basic the Alarm list cannot be editable
  var canEditPeopleList: Bool = false

  /// People that the user has added to their home
  var notifiedPeople: [AlarmNotificationListModel] = [AlarmNotificationListModel]()

  /// People that the user has added to their home
  var allPeople: [AlarmNotificationListModel] = [AlarmNotificationListModel]()

  /// Move People in the All People List
  /// Note this does not call `delegate.updateLayout()`
  func movePersonAtRow(_ atRow: Int, toRow: Int) {
    let person = allPeople[atRow]
    allPeople.remove(at: atRow)
    allPeople.insert(person, at: toRow)
    sortNotifiedToAll()
  }

  // MARK: - Helpers

  fileprivate func sortNotifiedToAll() {
    notifiedPeople = notifiedPeople.sorted { (lhs, rhs) -> Bool in
      let lhsIdx = allPeople.index(of: lhs)!
      let rhsIdx = allPeople.index(of: rhs)!
      print("\(lhsIdx) < \(rhsIdx) = \(lhsIdx < rhsIdx)")
      return lhsIdx < rhsIdx
    }
  }

  func trimNotified() -> Int {
    var count = 0
    while notifiedPeople.count > AlarmNotificationListConstants.maxNotifiedCount + 1 {
      count += 1
      notifiedPeople.removeLast()
    }
    return count
  }

  var text: AlarmNotificationTexts {
    didSet {
      delegate?.updateLayout()
    }
  }
}
