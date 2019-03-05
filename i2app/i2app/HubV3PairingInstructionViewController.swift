//
//  HubV3PairingInstructionViewController.swift
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

/// Renders a pairing instruction "page" as part of a sequence of steps embedded
/// in the HubV3PairingStepsParentViewController's view pager.
///
/// - seealso: HubV3PairingInstructionViewController
internal class HubV3PairingInstructionViewController: UIViewController {

  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var illustration: UIImageView!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var instruction: UILabel!
  @IBOutlet weak var linkButton: UIButton!

  var step: HubV3PairingStepViewModel!
  var presenter: HubV3PairingStepsPresenterProtocol!

  static func createfromPairingStep(step: HubV3PairingStepViewModel,
                                    presenter: HubV3PairingStepsPresenterProtocol)
    -> HubV3PairingInstructionViewController? {
    let storyboard = UIStoryboard(name: "HubPairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "HubV3PairingInstructionViewController") as? HubV3PairingInstructionViewController {
      vc.setup(step: step, presenter: presenter)
      return vc
    }

    return nil
  }

  /// must be called before viewDidLoad()
  func setup(step: HubV3PairingStepViewModel,
             presenter: HubV3PairingStepsPresenterProtocol) {
    self.step = step
    self.presenter = presenter
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }

  fileprivate func configureViews() {

    guard let step = step else {
      DDLogError("Config Error in HubV3PairingInstructionViewController")
      return
    }

    // Resize iPhone 5
    if UIDevice.isIPhone5() {
      stackView.spacing = 16
    }

    // Populate step illustration
    if let img = UIImage(named: step.imageName) {
      illustration.image = img
      view.setNeedsLayout()
    }

    // Populate one or more lines of instructional text
    instruction.text = step.info

    // Populate the subtitle or hide it
    if let subtitleText = step.subtitle {
      subtitle.text = subtitleText
      subtitle.isHidden = false
    } else {
      subtitle.isHidden = true
    }

    if let linkText = step.linkText,
      step.linkDestination != nil {
      linkButton.setAttributedTitle(linkText, for: .normal)
      linkButton.isHidden = false
    } else {
      linkButton.isHidden = true
    }

    // Set Title
    self.navigationItem.title = step.title
    addScleraStyleToNavigationTitle()
  }

  @IBAction func linkButtonPressed() {
    if let url = step?.linkDestination {
      UIApplication.shared.open(url)
    }
  }

}
