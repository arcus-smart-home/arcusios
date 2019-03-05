//
//  KeyFobRulesListViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/11/16.
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

// MARK: Constants

extension Constants {
  static let kKeyFobOrderArray = ["circle", "diamond", "square", "hexagon", "away", "home", "none", "a", "b"]

}

class KeyFobRulesListViewController: UIViewController {
  fileprivate var deviceModel: DeviceModel!
  fileprivate var buttons: [DeviceSettingFobButton]?
  fileprivate var selectedIndex: Int = NSNotFound

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleView: UILabel!

  var templateIds: [String]!
  var ruleTemplateNames: [String]!

  class func create(_ device: DeviceModel) -> KeyFobRulesListViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "DeviceDetails", bundle: nil)

    guard let viewController = storyboard
      .instantiateViewController(withIdentifier: "KeyFobRulesListViewController")
      as? KeyFobRulesListViewController else {
        return nil
    }

    viewController.deviceModel = device
    return viewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = UIColor.clear
    tableView.backgroundView = nil
    tableView.tableFooterView = UIView()

    self.title = self.deviceModel.name

    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    navBar(withBackButtonAndTitle: self.navigationItem.title)

    let productId: String = DeviceCapability.getProductId(from: self.deviceModel)
    if productId == kGen3FourButtonFob {
      self.ruleTemplateNames = DeviceModel.arcusGen3FourButtonFobRuleTemplateNames()
      self.templateIds = DeviceModel.arcusGen3FourButtonFobRuleTemplateIds()
    } else if productId == kGen2FourButtonFob {
      self.ruleTemplateNames = DeviceModel.arcusGen2FourButtonFobRuleTemplateNames()
      self.templateIds = DeviceModel.arcusGen2FourButtonFobRuleTemplateIds()
    } else if productId == kGen1TwoButtonFob {
      self.ruleTemplateNames = DeviceModel.arcusGen1TwoButtonFobRuleTemplateNames()
      self.templateIds = DeviceModel.arcusGen1TwoButtonFobRuleTemplateIds()
    } else if productId == kGen1SmartButton || productId == kGen2SmartButton {
      self.ruleTemplateNames = DeviceModel.arcusSmartButtonRuleTemplateNames()
      self.templateIds = DeviceModel.arcusSmartButtonRuleTemplateIds()
    }

    if let instances = self.deviceModel.getInstances() {
      let instanceKeys = Array(instances.keys)
      let mappedButtons = instanceKeys
        .map({ (instance: String) -> DeviceSettingFobButton in
          let buttonType: ButtonType = DeviceModel.arcusStringToButtonType(instance)

          let button: DeviceSettingFobButton = DeviceSettingFobButton(buttonType: buttonType,
                                                                      buttonName: instance,
                                                                      deviceModel: self.deviceModel)
          self.retrieveAssignedTemplateId(buttonType, button: button)

          return button
        })
      var sortedButtons: [DeviceSettingFobButton] = []
      for orderStr in Constants.kKeyFobOrderArray {
        let filteredButtons = mappedButtons.filter{ $0.buttonName == orderStr }
        if let button = filteredButtons.first {
          sortedButtons.append(button)
        }
      }
      self.buttons = sortedButtons
    }
  }

  fileprivate func retrieveAssignedTemplateId(_ type: ButtonType, button: DeviceSettingFobButton) {
    DispatchQueue.global(qos: .background).async {
      guard let currentPlace = RxCornea.shared.settings?.currentPlace else { return }
      var buttonType: String? = nil
      if type != ButtonTypeNone {
        buttonType = DeviceModel.arcusButtonTypeToString(type)
      }
      _ = RulesController
        .listRules(withPlaceId: currentPlace.modelId,
                   forDevice: self.deviceModel,
                   forButton: buttonType)
        .swiftThen ({ response  in
          if let rules: NSArray = response as? NSArray {
            if rules.count > 0 {
              let rule: RuleModel = (rules[0] as? RuleModel)!

              let ruleTemplateId: String! = RuleCapability.getTemplateFrom(rule)
              button.ruleTemplateId = ruleTemplateId
            } else {
              button.ruleTemplateId = nil
            }
          } else {
            button.ruleTemplateId = ""
          }

          DispatchQueue.main.async(execute: {() -> Void in
            self.tableView.reloadData()
          })
          return nil
        })
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if self.selectedIndex != NSNotFound {
      self.retrieveAssignedTemplateId(self.buttons![self.selectedIndex].buttonType,
                                      button: self.buttons![self.selectedIndex])
    }
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.templateIds == nil {
      return 0
    }
    return self.buttons!.count
  }

  func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "ArcusSingleRowWithImageAndChevronCell"
    let cell: ArcusSingleRowWithImageAndChevronCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSingleRowWithImageAndChevronCell

    cell?.backgroundColor = UIColor.clear

    cell?.titleLabel.text = self.buttons![indexPath.row].buttonName.uppercased()
    let ruleTemplateId: String? = self.buttons![indexPath.row].ruleTemplateId
    if ruleTemplateId != nil && indexPath.row < self.templateIds.count {
      if let index: Int = self.templateIds.index(of: ruleTemplateId!) {
        cell?.detailLabel.text = self.ruleTemplateNames[index]
      }
    } else {
      cell?.detailLabel.text = self.ruleTemplateNames[4]
    }
    let imgName = self.buttons![indexPath.row].imageName
    cell?.imageView?.image = UIImage(named: imgName)
    return cell!
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    self.selectedIndex = indexPath.row
    let buttonType: ButtonType = self.buttons![self.selectedIndex].buttonType
    let vc: KeyFobRuleSettingButtonController =
      KeyFobRuleSettingButtonController.create(buttonType, device: self.deviceModel)
    self.navigationController?.pushViewController(vc, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }


  fileprivate class DeviceSettingFobButton: NSObject {
    internal var buttonType: ButtonType!
    internal var buttonName: String!
    internal var productId: String!
    internal var ruleTemplateId: String!

    init(buttonType: ButtonType, buttonName: String, deviceModel: DeviceModel) {
      self.buttonType = buttonType
      self.buttonName = buttonName
      self.productId = deviceModel.productId as String!
    }

    // MARK: Private Methods
    var imageName: String {
      switch buttonType {
      case ButtonTypeCircle:
        return "circle"
      case ButtonTypeDiamond:
        return "diamond"
      case ButtonTypeSquare:
        return "square"
      case ButtonTypeHexagon:
        return "hexagon"
      case ButtonTypeAway:
        if productId == kGen3FourButtonFob {
          return "away_v3"
        }
        return "away"
      case ButtonTypeA:
        return "a_v3"
      case ButtonTypeB:
        return "b_v3"
      case ButtonTypeHome:
        if productId == kGen3FourButtonFob {
          return "home_v3"
        }
        return "home"
      default:
        return ""
      }
    }
  }
}
