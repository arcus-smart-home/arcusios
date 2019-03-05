//
//  ContactTestViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/23/18.
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

import Cornea
import RxSwift

class ContactTestViewController: UIViewController,  PairingCustomizationStepPresenter,
ContactTestPresenter {
  
  /**
   Required by ContactTestPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by ContactTestPresenter
   */
  var contactTestViewModel = ContactTestViewModel()
  
  /**
   Required by ContactTestPresenter and PairingCustomizationStepPresenter
   */
  var deviceAddress = ""
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var actionButton: UIButton!
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var cancelButton: UIButton?
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  private var ignoreImageAnimation = true
  private var imageTimer: Timer?
  
  @IBOutlet weak var stepTitle: UILabel!
  @IBOutlet weak var stepInfo: UILabel!
  @IBOutlet weak var deviceImageView: UIImageView!
  @IBOutlet weak var helpButton: UIButton!
  
  static func create() -> ContactTestViewController {
    let storyboard = UIStoryboard(name: "ContactTest", bundle: nil)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "ContactTestViewController")
      as? ContactTestViewController {
      return viewController
    }
    
    return ContactTestViewController()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    ignoreImageAnimation = true
    disposeBag = DisposeBag()
    removeImageTimer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    fetchContactTestDeviceState()
    bindToDeviceState()
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    addCustomization(PairingCustomizationStepType.contactTest.rawValue)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func helpButtonPressed(_ sender: Any) {
    guard let url = URL(string: currentStepViewModel()?.linkURL ?? "") else {
      return
    }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  private func removeImageTimer() {
    imageTimer?.invalidate()
    imageTimer = nil
  }
  
  private func bindToDeviceState() {
    contactTestViewModel.isDeviceOpened.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.handleDeviceStateUpdate()
      })
      .disposed(by: disposeBag)
  }
  
  private func handleDeviceStateUpdate() {
    let isDeviceOpened = contactTestViewModel.isDeviceOpened.value
    
    // If the image is being set for the first time then do not animate.
    if ignoreImageAnimation {
      ignoreImageAnimation = false
      isDeviceOpened ? transitionToOpenImageOff() : transitionToCloseImageOff()
      return
    }
    
    guard let openOnURL = contactTestViewModel.imageOpenOnURL,
      let closeOnURL = contactTestViewModel.imageCloseOnURL else {
        return
    }
    
    if isDeviceOpened {
      deviceImageView.sd_setImage(with: openOnURL)
      
      imageTimer?.invalidate()
      imageTimer = Timer.scheduledTimer(timeInterval: 2,
                                        target: self,
                                        selector: #selector(transitionToOpenImageOff),
                                        userInfo: nil,
                                        repeats: false)
    } else {
      deviceImageView.sd_setImage(with: closeOnURL)
      
      imageTimer?.invalidate()
      imageTimer = Timer.scheduledTimer(timeInterval: 2,
                                        target: self,
                                        selector: #selector(transitionToCloseImageOff),
                                        userInfo: nil,
                                        repeats: false)
    }
  }
  
  @objc private func transitionToOpenImageOff() {
    guard let openOff = contactTestViewModel.imageOpenOffURL else {
      return
    }
    
    deviceImageView.sd_setImage(with: openOff)
  }
  
  @objc private func transitionToCloseImageOff() {
    guard let closeOff = contactTestViewModel.imageCloseOffURL else {
      return
    }
    
    deviceImageView.sd_setImage(with: closeOff)
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    showCancelIfNeeded()
    addCustomizationStepBackButtonIfNeeded()
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      stepTitle.text = title
    }
    if let description = currentStepViewModel()?.description, description.count > 0 {
      stepInfo.text = description.joined(separator: "\n\n")
    }
    if let linkText = currentStepViewModel()?.linkText {
      helpButton.setTitle(linkText, for: .normal)
    }
  }
  
}
