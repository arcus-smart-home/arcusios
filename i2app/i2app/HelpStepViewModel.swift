//
//  TroubleshootingTipViewModel.swift
//  i2app
//
//  Arcus Team on 3/13/18.
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

struct HelpStepViewModel {

  var id: String?
  var order: Int?
  var action: String?
  var message: String?
  var linkText: String?
  var linkUrl: String?
 
  init (stepData: [String:AnyObject?]) {
    self.id = stepData["id"] as? String
    self.order = stepData["order"] as? Int
    self.action = stepData["action"] as? String
    self.message = stepData["message"] as? String
    self.linkText = stepData["linkText"] as? String
    self.linkUrl = stepData["linkUrl"] as? String
  }
 
  static func fromHelpSteps(_ stepsData: [Any]) -> [HelpStepViewModel] {
    var tips: [HelpStepViewModel] = []
    
    for thisStepData in stepsData {
      if let thisStep = thisStepData as? [String:AnyObject?] {
        tips.append(HelpStepViewModel(stepData: thisStep))
      }
    }
    
    return tips
  }
  
  /// Determines if this help step should be rendered as plain text without any clickable action.
  func isInfoAction() -> Bool {
    // Note that there are other actions, too, but we treat those as info
    return !isFactoryResetAction() && !isLinkAction()
  }
  
  /// Determines if this help step should be rendered as a link taking the user to the factory
  /// reset steps (in the app)
  func isFactoryResetAction() -> Bool {
    if let action = self.action, action == "FACTORY_RESET" {
      return true
    } else {
      return false
    }
  }
  
  /// Determines if this help step should be rendered as a link launching an external browser with
  /// the associated linkUrl
  func isLinkAction() -> Bool {
    if let action = self.action, action == "LINK" {
      return true
    } else {
      return false
    }
  }

}
