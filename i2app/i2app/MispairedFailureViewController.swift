//
//  MispairedFailureViewController.swift
//  i2app
//
//  Arcus Team on 4/20/18.
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

public class MispairedFailureViewController: MispairedBaseViewController,
                                             VerticalAutoScrollable {

  let presenter = MispairedPresenter()

  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    makeVerticallyScrolling()
    
    presenter.delegate = self
  }

  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == MispairedSegues.segueToForceConfirmation.rawValue,
       let confirmVc = segue.destination as? MispairedConfirmationViewController {
      
      confirmVc.delegate = self
    }
  }

  @IBAction func onCallSupport(_ sender: Any?) {
    if let url = URL(string: "tel://18554694747") {
      UIApplication.shared.openURL(url)
    }
  }
}

extension MispairedFailureViewController: ConfirmationDelegate {

  // User confirmed that they wish to force-remove device
  func onConfirmed() {
    presenter.remove(mispairedDev, force: true)
  }
  
  // User rejected request to force-remove device
  func onRejected() {
    // Nothing to do
  }
}

extension MispairedFailureViewController: MispairedDelegate {

  func onShowRemovalSteps(_ steps: [FactoryResetStepModel]) {
    // Not possible in this context
  }
  
  func onRemoved() {
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingForceRemove)
    self.performSegue(withIdentifier: MispairedSegues.segueToForceSuccess.rawValue, sender: nil)
  }
  
  func onRemoveFailed(forced: Bool) {
    // Should not be possible
    displayGenericErrorMessage()
  }
  
  func onError(_ message: String) {
    displayGenericErrorMessage()
  }
  
}
