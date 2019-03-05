//
//  WSSConfigureNetworkViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/2/18.
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
import RxCocoa

class WSSConfigureNetworkViewController: UIViewController, WSSNetworkConfigurator {
  @IBOutlet weak var ssidTextField: ScleraTextField!
  @IBOutlet weak var keyTextField: ScleraTextField!
  @IBOutlet weak var showKeySwitch: UISwitch!

  // MARK - OffsetScrollViewKeyboardAnimatable
  @IBOutlet weak var keyboardAnimationView: UIScrollView!
  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  // MARK: - WSSNetworkConfigurator Properties
  var config: ArcusWiFiNetworkConfig = WSSNetworkConfig()
  var disposeBag: DisposeBag = DisposeBag()

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK: - PairingStepsPresenter
  fileprivate var step: ArcusPairingStepViewModel?
  fileprivate var presenter: PairingStepsPresenter?

  private var pagingDisposable: Disposable?

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: PairingStepsPresenter) -> WSSConfigureNetworkViewController? {
    let storyboard = UIStoryboard(name: "WifiSmartSwitchPairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "WSSConfigureNetworkViewController")
      as? WSSConfigureNetworkViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let config = step.config as? ArcusWiFiNetworkConfig {
        vc.config = config
      }

      return vc
    }
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let presenterDelegate = presenter?.delegate as? PairingStepsCustomStepDelegate {
      customStepDelegate = presenterDelegate
    }

    configureBindings()

    ssidTextField.text = nil

    customStepDelegate?.pagingEnabled.value = true

    // Configure scrolling for keyboard show/hide.
    addKeyboardScrolling()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if ssidTextField.text == nil {
      ssidTextField.removeError()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    // Enable/Disabled Paging Binding
    customStepDelegate?.pagingEnabled.value = config.getValid()

    super.viewDidAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    customStepDelegate?.pagingEnabled.value = true

    cleanUpKeyboardScrollingObservers()
  }

  // MARK: - WSSNetworkConfigurator Methods
  func configureBindings() {
    // TextField Input Binding
    bindSSidTextField()
    bindKeyTextField()

    // TextField Return Key Binding
    bindBecomeNextResponder()
    // Attempt Submit on `keyTextField` return.
    bindSubmit()

    // TextField Error Handling Binding
    configureTextFieldErrorHandling(ssidTextField, errorMessage: "Missing Wi-Fi Network")

    // Show/Hide Secure Text Binding
    bindShowPasswordSwitch()

    // Enable/Disabled Paging Binding
    bindPagingEnabled()
  }

  /**
   Private method used to bind `config.ssid` to `ssidTextField`.
   */
  private func bindSSidTextField() {
    ssidTextField.rx.text
      .orEmpty
      .bind(to: config.ssid)
      .disposed(by: disposeBag)
  }

  /**
   Private method used to bind `config.key` to `keyTextField`.
   */
  private func bindKeyTextField() {
    keyTextField.rx.text
      .orEmpty
      .bind(to: config.key)
      .disposed(by: disposeBag)
  }

  /**
   Private method used to assign firstResponder to `keyTextField` on `ssidTextField` return.
   */
  private func bindBecomeNextResponder() {
    ssidTextField.rx.controlEvent(
      .editingDidEndOnExit)
      .subscribe(
        onNext: { [keyTextField] _ in
          keyTextField?.becomeFirstResponder()
      }).disposed(by: disposeBag)
  }

  /**
   Private method used to attempt submitting form on `keyTextField` return.
   */
  private func bindSubmit() {
    keyTextField.rx.controlEvent(
      .editingDidEndOnExit)
      .subscribe(
        onNext: { [customStepDelegate] _ in
          customStepDelegate?.attemptAdvanceToNextStep()
      }).disposed(by: disposeBag)
  }

  /**
   Private method used to configure textField error messages.
   */
  private func configureTextFieldErrorHandling(_ textField: ScleraTextField, errorMessage: String) {
    textField.rx.controlEvent(
      .editingDidEnd)
      .subscribe(
        onNext: { [textField, errorMessage] _ in
          if (textField.text?.count ?? 0) > 0 {
            textField.removeError()
          } else {
            textField.showError(errorText: errorMessage)
          }
      }).disposed(by: disposeBag)
  }

  /**
   Private method used to bind the inverse `showKeySwitch.value` to the `keyTextField.isSecureTextEntry`
   property.
   */
  private func bindShowPasswordSwitch() {
    showKeySwitch.rx.value
      .shareReplay(1)
      .map {
        !$0
      }
      .bind(to: keyTextField.rx.isSecureTextEntry)
      .disposed(by: disposeBag)
  }

  /**
   Private method used to bind `config.isValid` to `delegate.pagingEnabled`.
   */
  private func bindPagingEnabled() {
    if let delegate = customStepDelegate {
      config.isValid
        .shareReplay(1)
        .bind(to: delegate.pagingEnabled)
        .disposed(by: disposeBag)
    }
  }
}

extension WSSConfigureNetworkViewController: OffsetScrollViewKeyboardAnimatable {
  func activeViewForKeyboardScroll() -> UIView? {
    if let current = UIResponder.current as? UIView {
      return current
    }
    return nil
  }
}
