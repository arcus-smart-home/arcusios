//
//  HubPairingInstructionViewController.swift
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
/// in the HubPairingStepsParentViewController's view pager.
///
/// - seealso: HubPairingStepsParentViewController, HubPairingStepsPagerViewController,
///            PairingInstructionViewController
internal class HubPairingInstructionViewController: UIViewController {

  /// needed for OffsetScrollViewKeyboardAnimatable
  var keyboardAnimatableShowObserver: Any?
  /// needed for OffsetScrollViewKeyboardAnimatable
  var keyboardAnimatableHideObserver: Any?
  /// needed for OffsetScrollViewKeyboardAnimatable
  @IBOutlet weak var scrollView: UIScrollView!

  @IBOutlet weak var illustration: UIImageView!
  @IBOutlet weak var instruction: UILabel!
  @IBOutlet weak var inputContainer: UIView!
  @IBOutlet weak var hubIDInput: ScleraTextField?

  fileprivate var step: HubPairingStepViewModel?
  fileprivate var formViews: [String:UIView] = [:]

  /// This class uses the Hub Pairing Step Presenter to help with Hub Id input validation
  /// and communication to the view controller that contains this one that segues should occur
  ///
  /// - warning: delegate set in the required factory function below
  ///
  weak var presenter: HubPairingStepsPresenterProtocol?

  static func createfromPairingStep(step: HubPairingStepViewModel,
                                    presenter: HubPairingStepsPresenterProtocol) -> UIViewController {
    let storyboard = UIStoryboard(name: "HubPairing", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "HubPairingInstructionViewController")
    if let vc = vc as? HubPairingInstructionViewController {
      vc.step = step
      vc.presenter = presenter
    }
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }

  fileprivate func configureViews() {

    hubIDInput?.delegate = self
    hubIDInput?.autocorrectionType = .no

    guard let step = step else {
      DDLogError("Config Error in HubPairingInstructionViewController")
      return
    }

    // Populate step illustration
    illustration.image = UIImage(named: step.imageName)

    // Populate one or more lines of instructional text
    instruction.text = step.info

    // Set Title
    self.navigationItem.title = step.title
    addScleraStyleToNavigationTitle()

    // Handle Hub ID input
    if step.isHubIdForm {
      // Display Input
      keyboardAnimationView.isScrollEnabled = true
      inputContainer.isHidden = false
      if self.viewIfLoaded?.window != nil {
        presenter?.onCheckSetProceedEnabled(hubId: hubIDInput?.text)
      }
    } else {
      // Hide Input
      keyboardAnimationView.isScrollEnabled = false
      inputContainer.isHidden = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardScrolling()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    cleanUpKeyboardScrollingObservers()
  }

}

extension HubPairingInstructionViewController: HubIDGettable {
  var hubId: String? {
    return hubIDInput?.text
  }
}

extension HubPairingInstructionViewController: OffsetScrollViewKeyboardAnimatable {
  var keyboardAnimationView: UIScrollView! {
    return self.scrollView
  }

  func activeViewForKeyboardScroll() -> UIView? {
    if let current = UIResponder.current as? UIView {
      return current
    }
    return nil
  }
}

extension HubPairingInstructionViewController: EnhancedHubIDTextFieldDelegateProtocol {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // After resigning the text field Will also call textFieldDidEndEditing and that
    // function will validate the text field and handle the next button logic
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    validateForm(showErrors: true)
    presenter?.onCheckSetProceedEnabled(hubId: textField.text)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    hubIDInput?.removeError()
    return true
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool { // return NO to not change text

    let returnVal = hubIdTextField(textField,
                                   shouldChangeCharactersIn: range,
                                   replacementString: string)
    if let current = textField.text?.uppercased() {
      let newString = NSString(string: current).replacingCharacters(in: range, with: string)
      presenter?.onCheckSetProceedEnabled(hubId: newString)
    }
    textField.text = textField.text?.uppercased()
    return returnVal
  }

  fileprivate func validateForm(showErrors: Bool) {
    guard let presenter = presenter else {
      return
    }
    do {
      _ = try presenter.validateHubId(hubIDInput?.text)
    } catch {
      if showErrors,
        let error = error as? HubIdValidationError {
        hubIDInput?.showError(errorText: error.errorMessage)
      }
    }
  }
}
