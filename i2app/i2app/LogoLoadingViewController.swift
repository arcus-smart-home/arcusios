//
//  LogoLoadingViewController.swift
//  i2app
//
//  Created by Arcus Team on 11/15/17.
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
import RxSwift
import Cornea

extension Constants {
  static let kTroubleLoadingInterval: Double = 15.0
}

class LogoLoadingViewController: UIViewController, ArcusApplicationServiceProtocol {
  @IBOutlet var troubleLoadingView: UIView!
  @IBOutlet var troubleLoadingHeightConstraint: NSLayoutConstraint!

  var disposeBag: DisposeBag = DisposeBag()

  private var troubleLoadingTimer: Timer?

  deinit {
    troubleLoadingTimer?.invalidate()
    troubleLoadingTimer = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let appDelegate = UIApplication.shared.delegate,
      let eventPublisher = appDelegate as? ArcusApplicationServiceEventPublisher {
      observeApplicationEvents(eventPublisher)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    troubleLoadingView.alpha = 0

    schedulerTroubleLoading()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    invalidateTroubleLoading()
    hideTroubleLoadingView()
  }

  // MARK: IBActions

  @objc func appHasTroubleLoading(_ sender: AnyObject) {
    showTroubleLoadingView()
  }

  // MARK: Trouble Loading Timer

  func schedulerTroubleLoading() {
    invalidateTroubleLoading()
    troubleLoadingTimer = Timer.scheduledTimer(timeInterval: Constants.kTroubleLoadingInterval,
                                               target: self,
                                               selector: #selector(appHasTroubleLoading(_:)),
                                               userInfo: nil,
                                               repeats: false)
  }

  func invalidateTroubleLoading() {
    if let isValid = troubleLoadingTimer?.isValid, isValid == true {
      troubleLoadingTimer?.invalidate()
    }
  }

  // MARK: Trouble Loading Banner

  func showTroubleLoadingView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.troubleLoadingView.alpha = 1.0
      self.view.setNeedsLayout()
    })
  }

  func hideTroubleLoadingView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.troubleLoadingView.alpha = 0
      self.view.setNeedsLayout()
    }, completion: { _ in

    })
  }

  // MARK: ArcusApplicationServiceProtocol

  func serviceDidEnterBackground(_ event: ArcusApplicationServiceEvent) {
    invalidateTroubleLoading()
    hideTroubleLoadingView()
  }

  func serviceWillEnterForeground(_ event: ArcusApplicationServiceEvent) {
    hideTroubleLoadingView()
    schedulerTroubleLoading()
  }
}
