//
//  DeleteGuestPersonViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/25/16.
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
import PromiseKit

class DeleteGuestPersonViewController: ArcusBaseRemoveViewController {

  internal var guestPersonToDelete: PersonModel?

  // MARK: Required overrides
  override func removeButtonShouldBeEnabledString() -> String? {
    return "delete"
  }

  // MARK: RemovePersonAlertDelegate
  override func confirmButtonPressed(_ sender: ArcusButton, alertView: RemovePersonAlertView) {
    super.confirmButtonPressed(sender, alertView: alertView)
    if let personToDelete = guestPersonToDelete {
      createGif()
      DispatchQueue.global(qos: .background).async {
        _ = PersonController.deletePersonLogin(personToDelete).swiftThen { (_) -> (PMKPromise?) in
          ArcusAnalytics.tag(named: AnalyticsTags.AccountDelete)
          self.hideGif()
          return nil
        }
      }
    }
  }

}
