//
//  PairingCustomizationStepViewModel.swift
//  i2app
//
//  Created by Arcus Team on 2/28/18.
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

fileprivate enum stepDictionaryKey {
  static let action = "action"
  static let header = "header"
  static let linkUrl = "linkUrl"
  static let linkText = "linkText"
  static let identifier = "id"
  static let title = "title"
  static let order = "order"
  static let choices = "choices"
  static let description = "description"
  static let info = "info"
}

struct PairingCustomizationStepViewModel {
  
  var stepType: PairingCustomizationStepType?
  var order: Int?
  var identifier: String?
  var title: String?
  var info: String?
  var header: String?
  var linkText: String?
  var linkURL: String?
  var imageURL: URL?
  var description: [String]?
  var choices: [String]?
  
  init(stepDictionary: [String: AnyObject], stepIndex: Int? = nil) {
    if let action = stepDictionary[stepDictionaryKey.action] as? String {
      stepType = PairingCustomizationStepType(rawValue: action)
    }
    if let order = stepDictionary[stepDictionaryKey.order] as? Int {
      self.order = order
    } else if let order = stepIndex {
      self.order = order
    }
    
    if let identifier  = stepDictionary[stepDictionaryKey.identifier] as? String {
      self.identifier = identifier
    }
    if let title = stepDictionary[stepDictionaryKey.title] as? String {
      self.title = title
    }
    if let info = stepDictionary[stepDictionaryKey.info] as? String {
      self.info = info
    }
    if let header  = stepDictionary[stepDictionaryKey.header] as? String {
      self.header = header
    }
    if let linkText = stepDictionary[stepDictionaryKey.linkText] as? String {
      self.linkText = linkText
    }
    if let linkURL = stepDictionary[stepDictionaryKey.linkUrl] as? String {
      self.linkURL = linkURL
    }
    if let description  = stepDictionary[stepDictionaryKey.description] as? [String] {
      self.description = description
    }
    if let choices = stepDictionary[stepDictionaryKey.choices] as? [String] {
      self.choices = choices
    }
  }
  
}
