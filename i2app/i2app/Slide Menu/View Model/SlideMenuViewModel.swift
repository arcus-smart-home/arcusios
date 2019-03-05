//
//  SlideMenuViewModel.swift
//  i2app
//
//  Created by Arcus Team on 5/29/18.
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
import RxSwift
import Cornea

enum SlideMenuActionType {
  case push
  case present
  case dashboard
  case url
  case error
  case evaluate
}

enum SlideMenuError: Error {
  case unavailable
}

typealias SlideMenuEvaluation = (SlideMenuActionType?, UIViewController?)

class SlideMenuViewModel {
  var menuModels: Variable<[SlideMenuModel]>
  private var menuViewModels: [SlideMenuModel] {
    return [SlideMenuModel(title: NSLocalizedString("Dashboard", comment: ""),
                           subText: NSLocalizedString("Status of Your Home", comment: ""),
                           iconName: "DashboardIcon",
                           actionType: .dashboard),
            SlideMenuModel(title: NSLocalizedString("Scenes", comment: ""),
                           subText: NSLocalizedString("Control Several Devices at Once", comment: ""),
                           iconName: "ScenesIconNew",
                           actionType: .evaluate,
                           actionObject: SlideMenuViewModel.displayScenesList() as AnyObject),
            SlideMenuModel(title: NSLocalizedString("Rules", comment: ""),
                           subText: NSLocalizedString("Connect & Automate Devices", comment: ""),
                           iconName: "RulesIcon",
                           actionType: .evaluate,
                           actionObject: SlideMenuViewModel.displayRulesList() as AnyObject),
            SlideMenuModel(title: NSLocalizedString("Devices", comment: ""),
                           subText: NSLocalizedString("Manage & Control Devices", comment: ""),
                           iconName: "DevicesIconNew",
                           actionType: .push,
                           actionObject:  DeviceListViewController.create()),
            SlideMenuModel(title: NSLocalizedString("Settings", comment: ""),
                           subText: NSLocalizedString("Profile, People & Places", comment: ""),
                           iconName: "SettingsIconNew",
                           actionType: .push,
                           actionObject: SettingsViewController.create()),
            SlideMenuModel(title: NSLocalizedString("Support", comment: ""),
                           subText: NSLocalizedString("FAQs & Customer Support", comment: ""),
                           iconName: "SupportIcon",
                           actionType: .push,
                           actionObject: TutorialListViewController.create())]
  }

  init() {
    menuModels = Variable([])
    menuModels.value = menuViewModels
  }

  func refresh() {
    menuModels.value = menuViewModels
  }

  static func displayScenesList() -> SlideMenuEvaluation {
    if let displaySceneTutorial = RxCornea.shared.settings?.displayScenesTutorial(),
      displaySceneTutorial == true {
      let completion: TutorialCompletionBlock = {
        return ApplicationRoutingService.defaultService.pushViewController(SceneListViewController.create(),
                                                                           animated: false)
      }
      guard let tutorialVC = TutorialViewController.create(with: .scenes,
                                                           andCompletionBlock: completion) else {
        return (nil, nil)
      }
      return (.present, tutorialVC)
    } else {
      return (.push, SceneListViewController.create())
    }
  }
  
  static func displayRulesList() -> SlideMenuEvaluation {
    if let displayRulesTutorial = RxCornea.shared.settings?.displayRulesTutorial(),
      displayRulesTutorial == true {
      let completion: TutorialCompletionBlock = {
        return ApplicationRoutingService.defaultService.pushViewController(RuleListViewController.create(),
                                                                           animated: false)
      }
      guard let tutorialVC = TutorialViewController.create(with: .rules,
                                                           andCompletionBlock: completion) else {
        return (nil, nil)
      }
      return (.present, tutorialVC)
    } else {
      return (.push, RuleListViewController.create())
    }
  }
}

struct SlideMenuModel {
  let menuTitle: String
  let menuSubText: String
  let menuIconName: String
  let actionType: SlideMenuActionType?
  let actionObject: AnyObject?
  
  init(title: String,
       subText: String,
       iconName: String,
       actionType: SlideMenuActionType?,
       actionObject: AnyObject? = nil) {
    self.menuTitle = title
    self.menuSubText = subText
    self.menuIconName = iconName
    self.actionType = actionType
    self.actionObject = actionObject
  }
}
