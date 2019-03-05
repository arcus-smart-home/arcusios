//
//  ZWRebuildProgressViewController.swift
//  i2app
//
//  Arcus Team on 4/17/18.
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

class ZWRebuildProgressViewController: ZWRebuildBaseViewController {

  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var percentLabelView: UILabel!

  let presenter = ZWRebuildPresenter()
  var startHealing: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter.delegate = self
    if startHealing {
      presenter.startRebuilding()
    } else {
      presenter.continueRebuilding()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == ZWRebuildSegues.confirmRebuildLaterPopup.rawValue,
      let vc = segue.destination as? ZWRebuildConfirmCancelPopup {
      vc.delegate = self
    }
  }

  @IBAction func onConfirmCancel(_ sender: Any) {
    performSegue(withIdentifier: ZWRebuildSegues.confirmRebuildLaterPopup.rawValue, sender: nil)
  }

  @IBAction func onAbortCancel(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
}

extension ZWRebuildProgressViewController: ZWRebuildConfirmCancelPopupDelegate {
  /// Calls to say that the user wants to cancel, delegate should dismiss the popup
  func onConfirmCancelDidPressYes() {
    presenter.cancelRebuilding()
    dismiss(animated: true) {
      self.performSegue(withIdentifier: ZWRebuildSegues.rebuildLater.rawValue, sender: nil)
    }
  }

  /// Called to say that the user *does not want to cancel*, delegate should dismiss the popup
  func onConfirmCancelDidPressNo() {
    dismiss(animated: true) { _ in }
  }
}

extension ZWRebuildProgressViewController: ZWRebuildDelegate {
  
  func onRebuildProgressUpdate(_ percentComplete: Float) {
    progressView.setProgress(percentComplete, animated: true)    
    percentLabelView.text = "\(Int(percentComplete * 100))%"
  }
  
  func onRebuildSuccessful() {
    if self.presentedViewController != nil {
      self.dismiss(animated: true) {
        self.performSegue(withIdentifier: ZWRebuildSegues.segueToSuccess.rawValue, sender: nil)
      }
    } else {
      self.performSegue(withIdentifier: ZWRebuildSegues.segueToSuccess.rawValue, sender: nil)
    }
  }
  
  func onError(_ status: String) {
    DDLogError(status)
    self.displayGenericErrorMessage()
  }
}
