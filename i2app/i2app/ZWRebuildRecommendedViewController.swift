//
//  ZWRebuildRecommendedViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/18/18.
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

class ZWRebuildRecommendedViewController: ZWRebuildBaseViewController,
  ZWRebuildConfirmCancelPopupDelegate {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ZWRebuildSegues.confirmRebuildLaterPopup.rawValue,
      let vc = segue.destination as? ZWRebuildConfirmCancelPopup {
      vc.delegate = self
    }
  }

  @IBAction func onRebuildLaterPressed(_ sender: Any) {
    performSegue(withIdentifier: ZWRebuildSegues.confirmRebuildLaterPopup.rawValue, sender: nil)
  }

  /// Calls to say that the user wants to cancel, delegate should dismiss the popup
  func onConfirmCancelDidPressYes() {
    dismiss(animated: true) {
      self.performSegue(withIdentifier: ZWRebuildSegues.rebuildLater.rawValue, sender: nil)
    }
  }

  /// Called to say that the user *does not want to cancel*, delegate should dismiss the popup
  func onConfirmCancelDidPressNo() {
    dismiss(animated: true) { _ in }
  }
}
