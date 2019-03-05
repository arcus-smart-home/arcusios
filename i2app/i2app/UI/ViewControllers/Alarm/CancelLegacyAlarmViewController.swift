//
//  CancelLegacyAlarmViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/2/17.
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

class CancelLegacyAlarmViewController: UIViewController {
  @IBOutlet var alarmLabel: ArcusLabel!
  @IBOutlet var cancelContainer: UIView!

  fileprivate var cancelPresenter: CancelLegacyAlarmPresenter?
  fileprivate var popupWindow: PopupSelectionWindow?

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    cancelPresenter = CancelAlarmPresenter(delegate: self)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if cancelPresenter != nil {
      configureLayout(cancelPresenter!)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    UINavigationBar.appearance().barTintColor
      = NavigationBarAppearanceManager.sharedInstance.barTintColor
  }

  // MARK: UI Configuration

  func configureLayout(_ presenter: CancelLegacyAlarmPresenter) {
    alarmLabel.text = presenter.alarmTitle
    cancelContainer.backgroundColor = presenter.alarmColor
    navBarWithTitleImage()
    UINavigationBar.appearance().barTintColor = presenter.alarmColor
    setNeedsStatusBarAppearanceUpdate()
  }

  // MARK: IBActions

  @IBAction func cancelButtonPressed() {
    cancelPresenter?.cancel()
  }
}

extension CancelLegacyAlarmViewController: CancelLegacyAlarmDelegate {
  func alarmWasCancelled() {
    DispatchQueue.main.async(execute: {
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    })
  }

  func alarmCancellationFailed() {
    DispatchQueue.main.async(execute: {
      self.displayErrorMessage("Alarm could not be cancelled. Please try again.", withTitle: "Error")
    })
  }
}
