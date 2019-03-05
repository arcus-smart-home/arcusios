//
//  HubV3PairingStepsParentViewController.swift
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
import Cornea

internal class HubV3PairingStepsParentViewController: UIViewController,
  BackButtonDelegate {

  fileprivate var pagerController: HubV3PairingStepsPagerViewController?
  var presenter: HubV3PairingStepsPresenterProtocol = HubV3PairingStepsPresenter()

  @IBOutlet weak var buttonStackView: UIStackView!
  @IBOutlet weak var nextButton: ScleraButton!
  @IBOutlet weak var wifiButton: ScleraButton!
  @IBOutlet weak var ethernetButton: ScleraButton!

  private var stepViewControllers: [UIViewController] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    addScleraBackButton(delegate: self)
    navigationItem.title = Constants.hubDeviceName
    addScleraStyleToNavigationTitle()

    // Resize iPhone 5
    if UIDevice.isIPhone5() {
      buttonStackView.spacing = 16
    }

    let pages: [UIViewController] = HubV3PairingStepsPresenter.steps.map({
      if let vc = HubV3PairingInstructionViewController.createfromPairingStep(step: $0, presenter: self.presenter) {
        return vc
      } else {
        DDLogError("Developer Error creating HubV3PairingInstructionViewController")
        return UIViewController()
      }
    })
    pagerController?.setPages(pages)
    onPageChanged(isLastPage: false, stepViewModel: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIApplication.shared.isIdleTimerDisabled = true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == HubPairingSegues.pager.rawValue {
      if let pagerController = segue.destination as? HubV3PairingStepsPagerViewController {
        self.pagerController = pagerController
        self.pagerController?.stepsDelegate = self
        pagerController.setPages(stepViewControllers)
      }
    } else if segue.identifier == KitSegues.v3Hub.rawValue {
      if let parent = segue.destination as? HubPairingStepsParentViewController {
        parent.hubVersion = .version3
      }
    } else if segue.identifier == HubPairingSegues.youtube.rawValue {
      if let youTubePlayer = segue.destination as? YouTubePlayerViewController {
        youTubePlayer.videoId = kHubV3PairingYoutubeLink
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

  // MARK: IBActions

  @IBAction func onNextPressed(_ sender: Any) {
    pagerController?.goNextPage()
  }
  
  @IBAction func onVideoBannerTapped(_ sender: UITapGestureRecognizer) {
    performSegue(withIdentifier: HubPairingSegues.youtube.rawValue,
                 sender: kHubPairingYoutubeLink)
  }

}

extension HubV3PairingStepsParentViewController: HubV3PairingStepsPagerDelegate {
  func onPageChanged(isLastPage: Bool, stepViewModel: HubV3PairingStepViewModel?) {
    nextButton.isEnabled = !isLastPage

    if let step = stepViewModel, step.isConnectionSelection {
      nextButton.isHidden = true
      wifiButton.isHidden = false
      ethernetButton.isHidden = false
    } else {
      nextButton.isHidden = false
      wifiButton.isHidden = true
      ethernetButton.isHidden = true
    }
  }
}
