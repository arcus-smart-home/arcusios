//
//  PromptToEnableBiometricAuthenticationViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/17/17.
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

/// The Storyboard has this string in place of Face ID or Touch ID and the VC should replace it occording to
/// the presenter. We use caps because the sclera button changes the text to use all caps
fileprivate let ServiceTextReplaceString = "<AUTH>"

/// View Controller for prompt to Enable Biometric Authentication
/// - seealso: PromptToEnableBiometricAuthenticationPresenter
class PromptToEnableBiometricAuthenticationViewController: UIViewController {

  /// Presenter must be assigned in the create function
  var presenter: PromptToEnableBiometricAuthenticationPresenterProtocol!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var authIcon: UIImageView!
  @IBOutlet weak var successCheck: UIImageView!
  @IBOutlet weak var useButton: UIButton!
  @IBOutlet var allDisplayViews: [UIView]!
  @IBOutlet var successDisplayViews: [UIView]!
  @IBOutlet var promptDisplayViews: [UIView]!

  @IBAction func didPressUse(_ sender: UIButton) {
    presenter.shouldEnableBiometricAuthentication()
  }

  @IBAction func didPressNotNow(_ sender: UIButton) {
    dismiss()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureLabelsAndImages()
    presenter.enrollmentHasDisplayed()
    showPromptViews()
  }

  func configureNavigationBar() {
    if let image = UIImage(named: "DashLogo") {
      let imageView = UIImageView(image: image)
      navigationItem.titleView = imageView
    }
  }

  func configureLabelsAndImages() {
    titleLabel.text = titleLabel.text?.replacingOccurrences(of: ServiceTextReplaceString,
                                                            with: AuthProtocols.current.title)
    subtitleLabel.text = subtitleLabel.text?.replacingOccurrences(of: ServiceTextReplaceString,
                                                                  with: AuthProtocols.current.title)
    if let useButtonTitle = useButton.currentTitle {
      let newTitle = useButtonTitle.replacingOccurrences(of: ServiceTextReplaceString,
                                                         with: AuthProtocols.current.title)
      useButton.setTitle(newTitle, for: .normal)
    }
    switch AuthProtocols.current {
    /// These UIImages are tested in TestTouchIDPromptToEnableViewController
    case .touchID:
      authIcon.image = UIImage(named:"touchid_icon")!
    case .faceID:
      authIcon.image = UIImage(named:"faceid_icon")!
    case .none: // If none it is revoked, therefore its probabaly Face ID since you can't revoke Touch ID
      authIcon.image = UIImage(named:"faceid_icon")!
    }
  }

  func showPromptViews() {
    allDisplayViews
      .filter { return promptDisplayViews.contains($0) }
      .forEach { $0.isHidden = false }
    allDisplayViews
      .filter { return !promptDisplayViews.contains($0) }
      .forEach { $0.isHidden = true }
  }

  func animateSuccessViews() {
    allDisplayViews
      .filter { return successDisplayViews.contains($0) }
      .forEach { $0.isHidden = false }
    allDisplayViews
      .filter { return !successDisplayViews.contains($0) }
      .forEach { $0.isHidden = true }

    UIView.animate(withDuration: 0.25, animations: {
      let text = NSLocalizedString("<AUTH> is ready to go", comment: "<AUTH> is ready to go")
      self.titleLabel.text = text.replacingOccurrences(of: ServiceTextReplaceString,
                                                  with: AuthProtocols.current.title)
    })
    successCheck.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
    UIView.animate(withDuration: 1.0,
                   delay: 0,
                   usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 1,
                   options: [.allowUserInteraction, .curveEaseInOut],
                   animations: {
                    self.successCheck.transform = .identity
                   },
                   completion: nil)
  }

  func dismiss() {
    // This VC knows it must have a Navigation Controller, if this changes the dismiss function should change
    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }

  static func create(presenter: PromptToEnableBiometricAuthenticationPresenterProtocol) -> UIViewController? {
    let storyboard = UIStoryboard(name: "BiometricAuthentication", bundle: nil)
    if let nav = storyboard.instantiateInitialViewController() as? UINavigationController,
      let touch = nav.topViewController as? PromptToEnableBiometricAuthenticationViewController {
      presenter.delegate = touch
      touch.presenter = presenter
      return nav
    }
    return nil
  }
}

extension PromptToEnableBiometricAuthenticationViewController:
 PromptToEnableBiometricAuthenticationDelegateProtocol {
  func shouldShowSuccessAndExit() {
    animateSuccessViews()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.dismiss()
    }
  }
}
