//
//  HubPairingStepsParentViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

/// Protocol to allow contained view controller to communicate to the parent view controller
/// the next button state
internal protocol HubPairingParentProtocol {
  /// Invoked to indicate that the user has completed whatever entry (if any) is required
  /// on this screen and they are free to proceed to the next step.
  /// -enable: When true, user can proceed to next screen in sequence
  func onSetProceedEnabled(_ enable: Bool)
}

internal class HubPairingStepsParentViewController: UIViewController,
  BackButtonDelegate, HubPairingStepsPresenterDelegate {

  fileprivate var pagerController: HubPairingStepsPagerViewController?

  @IBOutlet weak var nextButton: ScleraButton!

  private var stepViewControllers: [UIViewController] = []

  var presenter: HubPairingStepsPresenterProtocol?
  public var hubVersion: HubVersion = .version2

  override func viewDidLoad() {
    super.viewDidLoad()

    let pres = hubVersion.createStepPresenter()
    pres.delegate = self
    presenter = pres
    addScleraBackButton(delegate: self)
    navigationItem.title = "Add a Hub"
    addScleraStyleToNavigationTitle()

    let pages: [UIViewController] = pres.steps.map({
      return HubPairingInstructionViewController
        .createfromPairingStep(step: $0, presenter: pres)
    })
    pagerController?.setPages(pages)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIApplication.shared.isIdleTimerDisabled = true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == HubPairingSegues.search.rawValue {
      if let hubId = sender as? String,
        let searchVC = segue.destination as? HubPairingNode {
        let config = [HubPairingNodeKey.HubId: hubId]
        searchVC.config = config
      }
    } else if segue.identifier == HubPairingSegues.pager.rawValue {
      if let pagerController = segue.destination as? HubPairingStepsPagerViewController {
        self.pagerController = pagerController
        self.pagerController?.stepsDelegate = self
        pagerController.setPages(stepViewControllers)
      }
    } else if segue.identifier == HubPairingSegues.youtube.rawValue {
      if let youTubePlayer = segue.destination as? YouTubePlayerViewController {
        youTubePlayer.videoId = kHubPairingYoutubeLink
      }
    }
  }

  // MARK: BackButtonDelegate

  func onBackButtonPressed() {
    // Attempt to navigate to previous page; if that fails, pop the nav stack
    if !(pagerController?.goPreviousPage() ?? false) {
      navigationController?.popViewController(animated: true)
    }
  }

  func onSetProceedEnabled(_ enable: Bool) {
    self.nextButton.isEnabled = enable
  }

  func onSegueToSearching(hubId: String) {
    performSegue(withIdentifier: HubPairingSegues.search.rawValue, sender: hubId)
  }

  // MARK: IBActions

  @IBAction func onNextPressed(_ sender: Any) {
    if !(pagerController?.goNextPage() ?? false) {
      if let hubId = pagerController?.hubId {
        presenter?.onSegueToSearching(hubId: hubId)
      }
    }
  }

  @IBAction func onVideoBannerTapped(_ sender: UITapGestureRecognizer) {
    performSegue(withIdentifier: HubPairingSegues.youtube.rawValue,
                 sender: kHubPairingYoutubeLink)
  }
}

extension HubPairingStepsParentViewController: HubPairingStepsPagerDelegate {
  func onPageChanged(isLastPage: Bool) {
    nextButton.isEnabled = !isLastPage
    if isLastPage,
      let hubId = pagerController?.hubId {
      presenter?.onCheckSetProceedEnabled(hubId: hubId)
    }
  }
}
