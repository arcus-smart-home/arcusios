//
//  HubPairingViewController.swift
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

class HubPairingViewController: UIViewController, HubPairingNode,
  OffsetScrollViewKeyboardAnimatable, HubPairingExitStrategyProtocol {

  var presenter: HubPairingPresenterProtocol?

  /// required for Pairing Node
  var config: [String : Any] = [:]

  /// needed for OffsetScrollViewKeyboardAnimatable
  var keyboardAnimatableShowObserver: Any?
  /// needed for OffsetScrollViewKeyboardAnimatable
  var keyboardAnimatableHideObserver: Any?
  /// needed for OffsetScrollViewKeyboardAnimatable
  var keyboardAnimationView: UIScrollView! {
    return scrollView
  }

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var progressContainer: UIView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var progressIndicator: UIProgressView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var needHelpButton: UIButton!
  @IBOutlet weak var factoryResetButton: UIButton!
  @IBOutlet weak var exitPairingButton: UIButton!
  @IBOutlet weak var hubIdInputContainer: UIView!
  @IBOutlet weak var textFieldPromptLabel: UILabel!
  @IBOutlet weak var textField: ScleraTextField!
  @IBOutlet weak var nextButton: UIButton!

  // Warning Banner
  @IBOutlet weak var warningBanner: UIView!
  @IBOutlet weak var warningLabel: UILabel!

  // Error Banner
  @IBOutlet weak var errorBanner: UIView!
  @IBOutlet weak var errorLabel: UILabel!

  /// Helper state to determine what segue is being performed. If the segue is a popup we don't cancel
  /// the process.
  var isPresentingOverlaySegue = false

  /// Helper state only used be the didFinishPairing function and is only flipped to true once
  /// in this VCs lifecycle
  var hasFinishPairing = false

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(self.onHideKeyboard)))
    addScleraStyleToNavigationTitle()
    addScleraBackButton()
    textField.autocorrectionType = .no
    clearViews()
    if presenter == nil {
      presenter = HubPairingPresenter(delegate: self)
    }
    textField.text = presenter?.hubId
    setNavState(state: .backChevron)

    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(HubPairingViewController.didBecomeActive(_:)),
                   name: .UIApplicationWillEnterForeground,
                   object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isPresentingOverlaySegue = false
    presenter?.startProcess()
    addKeyboardScrolling()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    textField.resignFirstResponder()
    if !isPresentingOverlaySegue {
      self.presenter?.stopProcess()
    }
    cleanUpKeyboardScrollingObservers()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let toVC = segue.destination as? HubPairingNode {
      toVC.config = config
    }
    if let identifier = segue.identifier,
      let segue = HubPairingSegues(rawValue: identifier) {
      switch segue {
      case .downloadInProgressExitPopup, .downloadFailedExitPopup,
           .applyInProgressExitPopup, .installFailedExitPopup:
        isPresentingOverlaySegue = true
      default:
        break
      }
    }

    if let popup = segue.destination as? ExitHubPairingDownloadPopupViewController {
      popup.delegate = self
    }
  }

  @IBAction func nextButtonPressed(_ sender: Any) {
    presenter?.buttonPressed()
    self.textField.resignFirstResponder()
  }

  @IBAction func needHelpButtonPressed(_ sender: Any) {
    UIApplication.shared.open(NSURL.SupportHub)
    presenter?.stopProcess()
    self.textField.resignFirstResponder()
  }
  
  @IBAction func factoryResetPressed(_ sender: Any) {
    UIApplication.shared.open(NSURL.SupportHubFactoryReset)
    presenter?.stopProcess()
    self.textField.resignFirstResponder()
  }

  @IBAction func exitPressed(_ sender: Any) {
    self.textField.resignFirstResponder()
    if let popupSegue: HubPairingSegues = presenter?.exitPopupSegue() {
      self.performSegue(withIdentifier: popupSegue.rawValue, sender: nil)
    } else {
      shouldDismissToDashboard()
    }
  }

  // Nav State Helpers
  fileprivate enum NavState {
    case backChevron
    case cancelButton
  }

  fileprivate func setNavState(state: NavState) {
    switch state {
    case .backChevron:
      addScleraBackButton()
      exitPairingButton.isHidden = true
      break
    case .cancelButton:
      removeScleraBackButton()
      exitPairingButton.isHidden = false
      break
    }
  }

  fileprivate func clearViews() {
    activityIndicator.isHidden = true
    progressContainer.isHidden = true
    progressIndicator.isHidden = true
    progressLabel.isHidden = true
    titleLabel.isHidden = true
    subtitleLabel.isHidden = true
    needHelpButton.isHidden = true
    factoryResetButton.isHidden = true
    hubIdInputContainer.isHidden = true
    nextButton.isHidden = true
    warningBanner.isHidden = true
    errorBanner.isHidden = true
    exitPairingButton.isHidden = true
  }
}

extension HubPairingViewController: HubPairingDelegate {

  var textFieldText: String! {
    if let text = textField.text {
      return text
    }
    return ""
  }

  func displayTextErrorMessage(_ errorMessageKey: String) {
    textField.showError(errorText: errorMessageKey)
  }

  func update(viewModel: HubPairingViewModel?) {
    DispatchQueue.main.async {
      guard let vm = viewModel else {
        self.clearViews()
        return
      }
      self.bind(viewModel: vm)
      self.view.layoutIfNeeded()
    }
  }

  func bind(viewModel vm: HubPairingViewModel) {

    if vm.hasBackButton {
      setNavState(state: .backChevron)
    } else {
      setNavState(state: .cancelButton)
    }

    exitPairingButton.isHidden = vm.exitPairingDisabled
    factoryResetButton.isHidden = !vm.hasFactoryResetButton
    
    if let title = vm.title {
      titleLabel.text = title
      titleLabel.isHidden = false
    } else {
      titleLabel.isHidden = true
    }

    if let subtitle = vm.subtitle {
      subtitleLabel.text = subtitle
      subtitleLabel.isHidden = false
    } else {
      subtitleLabel.isHidden = true
    }

    if let textFieldPrompt = vm.textFieldPrompt {
      hubIdInputContainer.isHidden = false
      needHelpButton.isHidden = false
      textFieldPromptLabel.text = textFieldPrompt
    } else {
      hubIdInputContainer.isHidden = true
      needHelpButton.isHidden = true
    }

    if let navTitle = vm.navTitle {
      self.navigationItem.title = navTitle
      addScleraStyleToNavigationTitle()
    } else {
      self.navigationItem.title = ""
      addScleraStyleToNavigationTitle()
    }

    if let buttonTitle = vm.buttonTitle {
      nextButton.setTitle(buttonTitle, for: .normal)
      nextButton.isHidden = false
      nextButton.isEnabled = vm.buttonEnabled
    } else {
      nextButton.isHidden = true
    }

    if let warningText = vm.warningText {
      warningBanner.isHidden = false
      warningLabel.text = warningText
    } else {
      warningBanner.isHidden = true
    }

    if let errorText = vm.errorText {
      errorBanner.isHidden = false
      errorLabel.text = errorText
    } else {
      errorBanner.isHidden = true
    }

  }

  func update(progress: Float?) {
    guard let progress = progress else {
      self.activityIndicator.isHidden = true
      self.progressContainer.isHidden = true
      self.progressIndicator.isHidden = true
      self.progressLabel.isHidden = true
      return
    }
    self.progressContainer.isHidden = false
    if progress == 0.0 {
      self.activityIndicator.isHidden = false
      self.progressIndicator.isHidden = true
      self.progressLabel.isHidden = true
      self.progressIndicator.setProgress(progress, animated: false)
    } else {
      self.activityIndicator.isHidden = true
      self.progressContainer.isHidden = false
      self.progressIndicator.setProgress(progress, animated: true)
      UIView.animate(withDuration: 0.25) {
        self.progressLabel.isHidden = false
        self.progressIndicator.isHidden = false
      }
    }
    progressLabel.text = String.localizedStringWithFormat("%.0f%%", progress * 100)
    self.view.layoutIfNeeded()
  }

  private func completeProgressAnimations() {
    self.progressIndicator.setProgress(1, animated: true)
  }

  func completeProgress() {
    ArcusAnalytics.tag(named: AnalyticsTags.HubPairingComplete)
    
    self.progressIndicator.setProgress(1, animated: true)
    UIView.animate(withDuration:  1.0) { _ in
      self.progressLabel.text = "100%"
    }
  }

  func didFinishPairing() {
    guard hasFinishPairing == false else {
      return
    }

    /// private function called immediately or after a popup is finished
    func completeAnimationToSegue() {
      self.progressIndicator.setProgress(1, animated: true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.performSegue(withIdentifier: HubPairingSegues.name.rawValue,
                          sender: nil)
      }
      UIView.animate(withDuration: 0.25,
                     delay: 0.0,
                     options: .transitionCrossDissolve,
                     animations: {
                      self.progressLabel.text = "100%"
      }, completion:nil)
    }

    hasFinishPairing = true
    removeScleraBackButton()
    if self.presentedViewController != nil {
      self.dismiss(animated: true) {
        completeAnimationToSegue()
      }
    }
    completeAnimationToSegue()
  }

  func didFailPairing() {
    // use the shared HubPairingExitStrategyProtocol method
    shouldDismissToDashboard()
  }

  func callSupport() {
    let supportNumber = "telprompt://" + NSLocalizedString("Customer support phone", comment:"")
    if let url = URL(string: supportNumber) {
      UIApplication.shared.openURL(url)
    }
  }

  @objc func didBecomeActive(_ note: Notification) {
    presenter?.startProcess()
  }

  func onHideKeyboard() {
    textField.resignFirstResponder()
  }
  
}

extension HubPairingViewController: EnhancedHubIDTextFieldDelegateProtocol {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // After resigning the text field Will also call textFieldDidEndEditing and that
    // function will validate the text field and handle the next button logic
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    validateForm(showErrors: true)
    //presenter?.onCheckSetProceedEnabled(hubId: textField.text)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.textField.removeError()
    return true
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool { // return NO to not change text

    let returnVal = hubIdTextField(textField,
                                   shouldChangeCharactersIn: range,
                                   replacementString: string)
    if let current = textField.text {
      let newString = NSString(string: current).replacingCharacters(in: range,
                                                                    with: string)
      //presenter?.onCheckSetProceedEnabled(hubId: newString)
    }
    return returnVal
  }

  fileprivate func validateForm(showErrors: Bool) {
    guard let presenter = presenter else {
      return
    }
    do {
      _ = try presenter.validateHubId(textField?.text)
    } catch {
      if showErrors,
        let error = error as? HubIdValidationError {
        textField.showError(errorText: error.errorMessage)
      }
    }
  }
}

extension HubPairingViewController: ExitHubPairingPopupDelegate {
  /// Get rid of the popup, don't go back though
  func dismissExitPairingPopup() {
    dismiss(animated: true, completion: nil)
  }

  /// the user wants to leave hub pairing, display the dashboard
  func shouldExitPairing() {
    dismiss(animated: true) {
      self.shouldDismissToDashboard()
    }
  }
}
