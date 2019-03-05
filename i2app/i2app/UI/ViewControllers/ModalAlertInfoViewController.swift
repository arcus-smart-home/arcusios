//
//  ModalAlertInfoViewController.swift
//  i2app
//
//  Created by Arcus Team on 11/18/16.
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
import Cornea

class ModalAlertInfoViewController: UIViewController {
  @IBOutlet weak var doneButton: ArcusButton!
  @IBOutlet weak var titleLabel: ArcusLabel!
  @IBOutlet weak var descriptionLabel: ArcusLabel!
  @IBOutlet weak var optionLabel: ArcusLabel!
  @IBOutlet weak var optionImage: UIImageView!
  @IBOutlet weak var optionSelectionOverlay: UIView!
  @IBOutlet weak var optionSelectionTapRecognizer: UITapGestureRecognizer!

  internal var modalAlertInfoPresenter: ModalAlertInfoPresenter?

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if modalAlertInfoPresenter != nil {
      configureLayout(modalAlertInfoPresenter!)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: UI Configuration

  func configureLayout(_ infoPresenter: ModalAlertInfoPresenter) {
    configureTitleLabel(infoPresenter)
    configureDescriptionLabel(infoPresenter)
    configureOptionLabel(infoPresenter)
    configureOptionImage(infoPresenter)
  }

  func configureTitleLabel(_ infoPresenter: ModalAlertInfoPresenter) {
    titleLabel.text = infoPresenter.titleLabelText()
  }

  func configureDescriptionLabel(_ infoPresenter: ModalAlertInfoPresenter) {
    descriptionLabel.text = infoPresenter.descriptionLabelText()
  }

  func configureOptionLabel(_ infoPresenter: ModalAlertInfoPresenter) {
    optionLabel.text = infoPresenter.optionLabelText()
  }

  func configureOptionImage(_ infoPresenter: ModalAlertInfoPresenter) {
    optionImage.isHighlighted = infoPresenter.optionEnabled()
  }

  // MARK: IBActions

  @IBAction func optionOverlayTapped(_ sender: AnyObject) {
    if modalAlertInfoPresenter != nil {
      optionAction(modalAlertInfoPresenter!)
    }
  }

  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    if modalAlertInfoPresenter != nil {
      doneAction(modalAlertInfoPresenter!)
    }
  }

  // MARK: Action Methods

  func optionAction(_ infoPresenter: ModalAlertInfoPresenter) {
    optionImage.isHighlighted = !optionImage.isHighlighted
    infoPresenter.optionAction(optionImage.isHighlighted)
  }

  func doneAction(_ infoPresenter: ModalAlertInfoPresenter) {
    infoPresenter.doneAction()
  }
}
