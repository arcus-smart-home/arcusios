//
//  RuleListViewController.swift
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

import UIKit
import Cornea

class RuleListViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
RuleListPresenterDelegate {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var messageView: UIView!
  @IBOutlet var tableHeaterView: UIView!
  @IBOutlet var headerLabel: UILabel!

  var ruleListPresenter: RuleListPresenter?
  var groupedRules: OrderedDictionary? = [:]

  var selectedRule: RuleModel?

  var popupWindow: PopupSelectionWindow!

  var scheduleController: ScheduleController! = RuleScheduleController()

  // MARK: - View LifeCycle
  class func create() -> RuleListViewController {
    let viewController: RuleListViewController? = UIStoryboard(name: "Rules", bundle: nil)
      .instantiateViewController(withIdentifier: String(describing: RuleListViewController.self))
      as? RuleListViewController
    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    createGif()

    if let currentPlace =  RxCornea.shared.settings?.currentPlace {
      ruleListPresenter = RuleListPresenter(place: currentPlace,
                                            delegate: self)
    }

    headerLabel.isHidden = true
    configureNavigationBar()
    configureBackground()
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if !isMovingToParentViewController {
      createGif()
      ruleListPresenter?.fetchRuleList()
    }
  }

  deinit {
    ruleListPresenter = nil
  }

  // MARK: UIConfiguration
  func configureNavigationBar() {
    navBar(withBackButtonAndTitle: navigationItem.title)

    if let count = ruleListPresenter?.ruleGroupsList.count, count > 0 {
      if tableView.isEditing == false {
        navBar(withTitle: navigationItem.title,
                    andRightButtonText: NSLocalizedString("Edit", comment: ""),
                    with: #selector(editButtonPressed(_:)))
      } else {
        navBar(withTitle: navigationItem.title,
                    andRightButtonText: NSLocalizedString("Done", comment: ""),
                    with: #selector(editButtonPressed(_:)))
      }
    }
  }

  func configureBackground() {
    addDarkOverlay(BackgroupOverlayLightLevel)

    if parent?.isKind(of: UINavigationController.self) == true {
      setBackgroundColorToDashboardColor()
    } else {
      setBackgroundColorToParentColor()
    }
  }

  func configureTableView() {
    tableView.backgroundColor = UIColor.clear
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120.0

    let nib: UINib = UINib(nibName: String(describing: ArcusTwoLabelTableViewSectionHeader.self),
                           bundle: nil)
    tableView.register(nib,
                            forHeaderFooterViewReuseIdentifier: kArcusTwoLabelTableSectionHeader)
  }

  func configureHeaderView() {
    if ruleListPresenter?.ruleGroupsList.count == 0 {
      messageView.isHidden = false
      tableView.isHidden = true
    } else {
      messageView.isHidden = true
      tableView.isHidden = false
    }
    headerLabel.isHidden = false
  }

  // MARK: IBActions
  @IBAction func editButtonPressed(_ sender: AnyObject) {
    if tableView.isEditing == true {
      navBar(withTitle: navigationItem.title,
                  andRightButtonText: NSLocalizedString("Edit", comment: ""),
                  with: #selector(editButtonPressed(_:)))
    } else {
      navBar(withTitle: navigationItem.title,
                  andRightButtonText: NSLocalizedString("Done", comment: ""),
                  with: #selector(editButtonPressed(_:)))

    }
    tableView.isEditing = !tableView.isEditing
    tableView.reloadData()
  }

  // MARK: UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    if let sections: Int? = ruleListPresenter?.ruleGroupsList.count {
      return sections!
    }

    return 0
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if let group: RuleListGroup? = ruleListPresenter?.ruleGroupsList[section] {
      return group!.rules.count
    }

    return 0
  }

  func tableView(_ tableView: UITableView,
                 estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170.0
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    let sectionHeader: ArcusTwoLabelTableViewSectionHeader? =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: kArcusTwoLabelTableSectionHeader)
        as? ArcusTwoLabelTableViewSectionHeader

    if let group: RuleListGroup? = ruleListPresenter?.ruleGroupsList[section] {
      sectionHeader?.mainTextLabel.text = group!.groupName
      sectionHeader?.accessoryTextLabel.text = String(group!.groupCount)
      sectionHeader?.hasBlurEffect = true
      sectionHeader?.backingView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }

    return sectionHeader!
  }

  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    if ruleListPresenter?.ruleGroupsList.count == 0 {
      return 0
    }
    return 30
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: "RuleCell")
        as? ArcusSelectOptionTableViewCell

    cell?.backgroundColor = UIColor.clear
    cell?.setEditing(tableView.isEditing, animated: true)
    cell?.selectionStyle = .none
    cell?.managesSelectionState = false

    cell?.selectionImageWidth = 20
    cell?.selectionImageLeadingSpace = 16
    cell?.selectionImageTrailingSpace = 15

    cell?.selectionImageEditWidth = 0
    cell?.selectionImageEditLeadingSpace = 0
    cell?.selectionImageEditTrailingSpace = 13

    if let group: RuleListGroup? = ruleListPresenter?.ruleGroupsList[indexPath.section] {
      let rule: RuleModel = group!.rules[indexPath.row]

      cell?.titleLabel.text = RuleCapability.getNameFrom(rule)
      cell?.descriptionLabel.text = RuleCapability.getDescriptionFrom(rule)

      cell?.selectionImage.isHighlighted = RuleListPresenter.ruleIsEnabled(rule)
      cell?.detailImage.isHidden = !scheduleController
        .hasScheduledEventsForModel(withAddress: rule.address as String!)

      cell?.configureSelectionOverlay()
      cell?.selectImageTappedCompletion = {
        Void in
        if RuleListPresenter.ruleIsEnabled(rule) == true {
          self.ruleListPresenter?.disableRule(rule.modelId as String)
        } else {
          self.ruleListPresenter?.enableRule(rule.modelId as String)
        }
      }
    }
    return cell!
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if let group: RuleListGroup? = ruleListPresenter?.ruleGroupsList[indexPath.section] {
        let rule: RuleModel = group!.rules[indexPath.row]
        ruleListPresenter?.deleteRule(rule.modelId as String)
      }
    }
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let group: RuleListGroup? = ruleListPresenter?.ruleGroupsList[indexPath.section] {
      selectedRule = group!.rules[indexPath.row]

      let templateId: String? = selectedRule!.getAttribute(kAttrRuleTemplate) as? String
      if let count = templateId?.count, count > 0 {
        performSegue(withIdentifier: "EditRuleTemplateSegue", sender: self)
      } else {
        if let buttonView =
          PopupSelectionButtonsView
            .create(withTitle: RuleCapability.getNameFrom(selectedRule),
                    subtitle: "Lost template, please re-create the rule",
                    buttons: nil) {
          buttonView.owner = self
          popupWindow = PopupSelectionWindow.popup(view,
                                                   subview: buttonView,
                                                   owner: self,
                                                   displyCloseButton: true)
        }
      }
    }
  }

  // MARK: RuleListPresenterDelegate
  func ruleGroupsListUpdated(_ ruleGroupsList: [RuleListGroup],
                             presenter: RuleListPresenter) {
    DispatchQueue.main.async {
      self.hideGif()
      self.configureNavigationBar()
      self.configureHeaderView()

      self.tableView.reloadData()
      self.tableView.layoutIfNeeded()
    }
  }

  func failedToEnableRule(_ rule: RuleModel?) {
    displayErrorMessage("This rule cannot be enabled, one or more of the "
      + "devices it controls are no longer available.")
  }

  // MARK: - PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "EditRuleTemplateSegue" {
      if let ruleSettingViewController =
        segue.destination as? RuleSettingViewController {
        if selectedRule != nil {
          ruleSettingViewController.configureView(toEdit: selectedRule!)
        }
      }
    }
  }

}
