//
//  RuleListPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/8/16.
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

import PromiseKit
import Cornea

class RuleListGroup: NSObject {
  let groupName: String
  let groupCount: Int
  let rules: [RuleModel]

  init(groupName: String, groupCount: Int, rules: [RuleModel]) {
    self.groupName = groupName
    self.groupCount = groupCount
    self.rules = rules
  }
}

protocol RuleListPresenterDelegate: class {
  func ruleGroupsListUpdated(_ ruleGroupsList: [RuleListGroup], presenter: RuleListPresenter)
  func failedToEnableRule(_ rule: RuleModel?)
}

class RuleListPresenter: NSObject {
  fileprivate let currentPlace: PlaceModel
  fileprivate weak var delegate: RuleListPresenterDelegate?

  internal var ruleGroupsList: [RuleListGroup] = [] {
    didSet {
      self.delegate?.ruleGroupsListUpdated(self.ruleGroupsList, presenter: self)
    }
  }

  var ruleList: [RuleModel]?
  var categoryList: [String]?
  var templateList: [RuleTemplateModel]?

  init(place: PlaceModel, delegate: RuleListPresenterDelegate) {
    self.currentPlace = place
    self.delegate = delegate

    super.init()

    self.observeRuleListChangeEvents()
    self.fetchRuleList()
  }

  deinit {
    self.removeRuleListChangeEventsObservation()
  }

  // MARK: Notification Observation & Handling
  func observeRuleListChangeEvents() {
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(ruleAddedNotificationReceived(_:)),
                   name: Notification.Name.modelAdded,
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(ruleDeletedNotificationReceived(_:)),
                   name: Notification.Name.modelDeleted,
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(ruleUpdatedNotificationReceived(_:)),
                   name: Model.attributeChangedNotificationName(kAttrRuleName),
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(ruleUpdatedNotificationReceived(_:)),
                   name: Model.attributeChangedNotificationName(kAttrRuleDescription),
                   object: nil)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(ruleUpdatedNotificationReceived(_:)),
                   name: Model.attributeChangedNotificationName(kAttrRuleState),
                   object: nil)
  }

  func removeRuleListChangeEventsObservation() {
    NotificationCenter.default.removeObserver(self)
  }

  func ruleAddedNotificationReceived(_ notification: Notification) {
    if notification.object is RuleModel {
      if let ruleModel = notification.object as? RuleModel {
        self.updateRulesListForAdded(ruleModel)
        self.delegate?.ruleGroupsListUpdated(self.ruleGroupsList, presenter: self)
      }
    }
  }

  func ruleDeletedNotificationReceived(_ notification: Notification) {
    if let rule = notification.object as? RuleModel {
      self.updateRulesListForDeletion(rule.address)
      self.delegate?.ruleGroupsListUpdated(self.ruleGroupsList, presenter: self)
    }
  }

  func ruleUpdatedNotificationReceived(_ notification: Notification) {
    let ruleInfo = notification.userInfo! as NSDictionary
    if let ruleModel = ruleInfo["Model"] as? RuleModel {
      self.updateRulesForRule(ruleModel)
      self.delegate?.ruleGroupsListUpdated(self.ruleGroupsList, presenter: self)
    }
  }

  // MARK: Data I/O
  func fetchRuleList() {
    let place = currentPlace
    _ = RulesController.listRules(withPlaceId:place.modelId as String?)
      .swiftThenInBackground({ rules in
        _ = RulesController.categoryNamesList(forPlace: place.modelId as String?)
          .swiftThenInBackground({ categories in
            _ = RulesController.listRulesTemlates(withPlaceId: place.modelId as String?)
              .swiftThenInBackground({ templates in

                if let templates = templates as? [NSDictionary] {
                  self.templateList = self.templateModelsForDictionary(templates)
                }

                var categories = categories as? [String]
                if categories != nil {
                  categories?.append("Misc")
                  self.categoryList = categories
                }

                if let rules = rules as? [NSDictionary] {
                  self.ruleList = self.ruleModelsForDictionary(rules)
                }

                self.ruleGroupsList = self.sortRuleList(self.ruleList!,
                                                        categories: self.categoryList!,
                                                        templates: self.templateList!)
                return nil
              })
            return nil
          })
        return nil
      })
  }

  func enableRule(_ ruleId: String) {
    DispatchQueue.global(qos: .background).async {
      if let rule = self.ruleForId(ruleId, rules: self.ruleList!) {
        _ = RuleCapability.enable(on: rule).swiftCatch { _ in
          self.delegate?.failedToEnableRule(rule)
          return nil
        }

      }
    }
  }

  func disableRule(_ ruleId: String) {
    DispatchQueue.global(qos: .background).async {
      if let rule = self.ruleForId(ruleId, rules: self.ruleList!) {
        RuleCapability.disable(on: rule)
      }
    }
  }

  func deleteRule(_ ruleId: String) {
    DispatchQueue.global(qos: .background).async {
      if let rule = self.ruleForId(ruleId, rules: self.ruleList!) {
        RuleCapability.delete(on: rule)
      }
    }
  }

  static func ruleIsEnabled(_ rule: RuleModel) -> Bool {
    return (RuleCapability.getStateFrom(rule) == kEnumRuleStateENABLED)
  }

  // MARK: Private Methods
  func sortRuleList(_ rules: [RuleModel],
                    categories: [String],
                    templates: [RuleTemplateModel]) -> [RuleListGroup] {
    let sortRules: [RuleModel] = rules.sorted { $0.name < $1.name }

    var ruleGroups: [RuleListGroup] = []

    for category in categories {
      let name: String = category
      var rules: [RuleModel] = []

      for rule in sortRules {
        if let templateId = rule.getAttribute(kAttrRuleTemplate) as? String {
          let count: Int? = templateId.count
          if count != nil {
            if count! > 0 {
              if let template: RuleTemplateModel = self.templateForId(templateId,
                                                                      templates: templates) {
                if let templateCategories =
                  template.getAttribute(kAttrRuleTemplateCategories) as? [String] {
                  for categoryName in templateCategories where category == categoryName {
                    rules.append(rule)
                    break
                  }
                }
              }
            }
          } else {
            // The last category in categories is of type Misc
            // We need to add the rule there
            if category == "Misc" {
              rules.append(rule)
            }
          }
        }
      }

      if rules.count > 0 {
        let sortedRules = rules.sorted {
          let lhs = $0.modelId as String
          let rhs = $1.modelId as String
          return lhs < rhs }
        let group: RuleListGroup = RuleListGroup(groupName: name,
                                                 groupCount: rules.count,
                                                 rules:sortedRules )

        ruleGroups.append(group)
      }
    }

    ruleGroups = ruleGroups.sorted { $0.groupName < $1.groupName }

    return ruleGroups
  }

  func ruleModelsForDictionary(_ ruleDictionaries: [NSDictionary]) -> [RuleModel] {
    var rules: [RuleModel] = []

    for ruleDictionary in ruleDictionaries {
      guard let ruleDictionary = ruleDictionary as? [String: AnyObject] else { continue }

      rules.append(RuleModel(attributes: ruleDictionary))
    }

    return rules
  }

  func ruleForId(_ id: String, rules: [RuleModel]) -> RuleModel? {
    var ruleModel: RuleModel?

    for rule in rules where id == rule.modelId as String {
      ruleModel = rule
      break
    }
    return ruleModel
  }

  func templateModelsForDictionary(_ templateDictionaries: [NSDictionary]) -> [RuleTemplateModel] {
    var templates: [RuleTemplateModel] = []

    for templateDictionary: NSDictionary in templateDictionaries {
      guard let templateDictionary = templateDictionary as? [String: AnyObject] else {
        continue
      }
      templates.append(RuleTemplateModel(attributes: templateDictionary))
    }

    return templates
  }

  func templateForId(_ id: String, templates: [RuleTemplateModel]) -> RuleTemplateModel? {
    var templateModel: RuleTemplateModel? = nil

    for template in templates where id == template.modelId as String {
      templateModel = template
      break
    }

    return templateModel
  }

  func updateRulesForRule(_ rule: RuleModel?) {
    if rule != nil {
      let index: Int? = self.indexForRuleWithId(rule!.modelId as String)
      if index != nil {
        self.ruleList?.remove(at: index!)
        self.ruleList?.append(rule!)
        self.ruleGroupsList = self.sortRuleList(self.ruleList!,
                                                categories: self.categoryList!,
                                                templates: self.templateList!)
      }
    }
  }

  func updateRulesListForDeletion(_ ruleAddress: String) {
    let index: Int? = self.indexForRuleWithAddress(ruleAddress)
    if index != nil {
      self.ruleList?.remove(at: index!)
      self.ruleGroupsList = self.sortRuleList(self.ruleList!,
                                              categories: self.categoryList!,
                                              templates: self.templateList!)
    }
  }

  func updateRulesListForAdded(_ rule: RuleModel?) {
    if rule != nil && self.ruleList != nil {
      let index: Int? = self.indexForRuleWithId(rule!.modelId as String)
      if index != nil {
        self.updateRulesForRule(rule)
      } else {
        self.ruleList?.append(rule!)
        self.ruleGroupsList = self.sortRuleList(self.ruleList!,
                                                categories: self.categoryList!,
                                                templates: self.templateList!)
      }
    }
  }

  func indexForRuleWithAddress(_ ruleAddress: String) -> Int? {
    if let count = self.ruleList?.count, count > 0 {
      for ruleModel: RuleModel in self.ruleList! where ruleAddress == ruleModel.address as String {
        return self.ruleList!.index(of: ruleModel)
      }
    }
    return nil
  }

  func indexForRuleWithId(_ ruleId: String) -> Int? {
    var index: Int?
    if let count = self.ruleList?.count, count > 0 {
      for ruleModel: RuleModel in self.ruleList! where ruleId == ruleModel.modelId as String {
        index = self.ruleList!.index(of: ruleModel)
        break
      }
    }
    return index
  }
}
