//
//  ModalAlertPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/20/16.
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

enum ModalAlertPriority: Int {
  case normal = 0
  case high = 1
}

protocol ModalAlertDelegate: class {
  func updateLayout()
  func executeSegue(_ identifier: String)
}

protocol ModalAlertPresenter {
  var alertIdentifier: String { get set }
  var placeModel: PlaceModel { get set }
  var alertPriority: ModalAlertPriority { get set }
  var alertedDeviceInfo: [[String : AnyObject]] { get set }
  var alertDate: Date { get set }
  var delegate: ModalAlertDelegate? { get set }

  func updatePresenterModels(_ place: PlaceModel,
                             deviceInfo: [[String : AnyObject]],
                             date: Date)

  func storyboardName() -> String
  func viewControllerIndentifier() -> String
  func navigationTitle() -> String
  func navigationBarColor() -> UIColor
  func navigationTextColor() -> UIColor
  func place() -> PlaceModel
  func iconName() -> String
  func description() -> String
  func cellIdentifier() -> String
  func showDoneButton() -> Bool
  func doneButtonTitle() -> String?
  func primaryActionTitle() -> String?
  func secondaryActionTitle() -> String?
  func primaryAction()
  func secondaryAction()

  func descriptionTextForDevice(_ deviceModel: DeviceModel) -> String?

  func modalAlertInfoPresenter() -> ModalAlertInfoPresenter?
}

extension ModalAlertPresenter {
  func storyboardName() -> String {
    return "Common"
  }

  func viewControllerIndentifier() -> String {
    return "ModalAlertViewController"
  }

  func navigationTextColor() -> UIColor {
    return UIColor.black
  }

  func cellIdentifier() -> String {
    return "titleDescCell"
  }

  func primaryActionTitle() -> String? {
    return nil
  }

  func secondaryActionTitle() -> String? {
    return nil
  }

  func primaryAction() {

  }

  func secondaryAction() {

  }

  func modalAlertInfoPresenter() -> ModalAlertInfoPresenter? {
    return nil
  }
}

protocol ModalAlertInfoPresenter {
  func titleLabelText() -> String
  func descriptionLabelText() -> String
  func optionLabelText() -> String
  func optionAction(_ selected: Bool)
  func optionEnabled() -> Bool
  func doneAction()
}

/**
 *  ModalAlert is a helper class used to provide the required properties and initializer
 *  to classes that also conform to the ModalAlertPresenter.  If a class is a subclass of
 *  ModalAlert and composed ModalAlertPresenter then it is not necessary to provide the required
 *  initializer.  ModalAlert does not conform to ModalAlertPresenter so that we do not
 *  have to provide an implementation of the presenter for this base class.
 **/
class ModalAlert {
  var placeModel: PlaceModel
  var alertPriority: ModalAlertPriority
  var alertedDeviceInfo: [[String : AnyObject]]
  var alertDate: Date
  weak var delegate: ModalAlertDelegate?

  required init(placeModel: PlaceModel,
                alertPriority: ModalAlertPriority,
                alertedDeviceInfo: [[String : AnyObject]],
                date: Date) {
    self.placeModel = placeModel
    self.alertPriority = alertPriority
    self.alertedDeviceInfo = alertedDeviceInfo
    self.alertDate = date
  }

  func updatePresenterModels(_ place: PlaceModel,
                             deviceInfo: [[String : AnyObject]],
                             date: Date) {
    placeModel = place
    alertedDeviceInfo = deviceInfo
    alertDate = date
    delegate?.updateLayout()
  }
}
