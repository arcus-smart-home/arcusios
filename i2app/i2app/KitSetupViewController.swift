//
//  KitSetupViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/16/18.
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

import RxSwift
import RxCocoa

class KitSetupViewController: UIViewController,
  KitSetupPresenter,
PairingCustomizationPresenter {
  
  // MARK: Properties
  
  var disposeBag = DisposeBag()
  
  // MARK: Required by KitSetupPresenter
  
  var kitSetupViewModel = KitSetupViewModel()
  
  // MARK: IBOutlets
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var tutorialBanner: UIView!
  @IBOutlet weak var confettiView: AccountCreationConfettiView!
  @IBOutlet weak var devicesCollectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var tutorialBannerHeight: NSLayoutConstraint!
  
  // MARK: Private Properties
  
  private let segueToCustomizationPopup = "KitSetupCustomizationPopup"
  private let segueToActivationPopup = "KitSetupActivationPopup"
  private var hasShownAllReadyAnimation = false
  
  // MARK: Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.hidesBackButton = true
    addScleraStyleToNavigationTitle()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    kitSetupViewModel = KitSetupViewModel()
    disposeBag = DisposeBag()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIApplication.shared.isIdleTimerDisabled = true
    configureViews()
    observeApplicationDidBecomeActive()
    kitSetupFetchDevices()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let destination = segue.destination as? KitSetupActivationPopup {
      destination.delegate = self
    }
    if let destination = segue.destination as? KitSetupCustomizationPopup {
      destination.delegate = self
    }
  }
  
  // MARK: IBActions
  
  @IBAction func exitButtonPressed(_ sender: AnyObject) {
    handleExitDisposition()
  }
  
  @IBAction func needHelpButtonPressed(_ sender: AnyObject) {
    handleNeedHelpTap()
  }
  
  // MARK: Required by KitSetypPresenter
  
  func kitSetupDevicesDismissed() {
    goToDashboard()
  }
  
  // MARK: Private Functions
  
  private func observeApplicationDidBecomeActive() {
    ApplicationServiceEventPublisher.shared.getApplicationEvents()
      .subscribe(onNext: { [weak self] event in
        if event.type == .didBecomeActive {
          self?.handleApplicationDidBecomeActive()
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  private func handleApplicationDidBecomeActive() {
    devicesCollectionView.reloadData()
  }
  
  private func configureViews() {
    makeTutorialBannerTappable()
    makeCollectionViewHeightDynamic()
    observeViewModel()
    bindCollectionView()
    bindCollectionViewSelection()
  }
  
  private func makeTutorialBannerTappable() {
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTutorialBannerTap))
    tutorialBanner.addGestureRecognizer(recognizer)
  }
  
  private func makeCollectionViewHeightDynamic() {
    devicesCollectionView.rx.observe(UICollectionView.self, "contentSize")
      .subscribeOn(MainScheduler.instance)
      .subscribe({ [weak self] _ in
        self?.collectionViewHeight.constant = self?.devicesCollectionView.contentSize.height ?? 0
      })
      .disposed(by: disposeBag)
  }
  
  private func observeViewModel() {
    kitSetupViewModel.kitDevices.asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        if self?.kitSetupViewModel.hasAllDevicesReady ?? false {
          self?.showAllReadyAnimation()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func handlePairingCustomization(customizationViewModel: PairingCustomizationViewModel?,
                                          deviceAddress: String) {
    // Ensure that all the data needed to present the steps is present
    guard let viewModel = customizationViewModel,
      let firstStep = viewModel.steps.first,
      let stepType = firstStep.stepType,
      let viewController =
      PairingCustomizationViewControllerFactory.viewController(forStepType: stepType) else {
        return
    }
    
    // Configure the data for the first step
    viewController.deviceAddress = deviceAddress
    viewController.stepIndex = 0
    viewController.pairingCustomizationViewModel = viewModel
    
    // Create a navigation controller for the customization workflow and present it modally
    let navigation = UINavigationController(rootViewController: viewController)
    self.present(navigation, animated: true, completion: nil)
  }
  
  private func bindCollectionView() {
    kitSetupViewModel.kitDevices.asObservable()
      .bind(to: devicesCollectionView.rx
        .items(cellIdentifier: "KitSetupDeviceCell",
               cellType: KitSetupDeviceCell.self)) {
                [weak self] (_, model: KitSetupDeviceViewModel, cell: KitSetupDeviceCell) in
                cell.deviceImage.image = UIImage(named: model.imageName)
                cell.titleLabel.text = model.title
                cell.subtitleLabel.text = model.subtitle
                cell.checkImage.isHidden = model.state != .activatedAndCustomized
                
                switch model.state {
                case .inactive:
                  cell.titleLabel.textColor = ScleraColor.disabled
                  cell.subtitleLabel.textColor = ScleraColor.text
                  cell.subtitleLabel.font = UIFont(name: ScleraFontFamily.italic, size: 14)
                  cell.subtitleLabel.isHidden = false
                case .activated:
                  cell.titleLabel.textColor = ScleraColor.text
                  cell.subtitleLabel.textColor = ScleraColor.teal
                  cell.subtitleLabel.font = UIFont(name: ScleraFontFamily.demiBold, size: 14)
                  cell.subtitleLabel.isHidden = false
                case .improperlyPaired, .missing:
                  cell.titleLabel.textColor = ScleraColor.disabled
                  cell.subtitleLabel.textColor = ScleraColor.alert
                  cell.subtitleLabel.font = UIFont(name: ScleraFontFamily.demiBold, size: 14)
                  cell.subtitleLabel.isHidden = false
                default:
                  cell.titleLabel.textColor = ScleraColor.text
                  cell.subtitleLabel.isHidden = true
                }
                
                if model.type == .hub && self?.kitSetupViewModel.hasInactiveDevices ?? false {
                  cell.animateImage()
                } else {
                  cell.stopAnimation()
                }
                
      }.disposed(by: disposeBag)
  }
  
  private func bindCollectionViewSelection() {
    devicesCollectionView.rx.itemSelected.subscribe({ [weak self] value in
      guard let indexPath = value.element,
        let kitDevices = self?.kitSetupViewModel.kitDevices.value,
        indexPath.row < kitDevices.count else {
          return
      }
      
      let state = kitDevices[indexPath.row].state
      if state == .activated {
        let device = kitDevices[indexPath.row]
        self?.pairingCustomizationPresenterFetchSteps(deviceAddress: device.deviceAddress,
                                                      completion: { (pairingCustomizationViewModel) in
                                                        self?.handlePairingCustomization(customizationViewModel: pairingCustomizationViewModel,
                                                                                         deviceAddress: device.deviceAddress)
        })
      } else if state == .improperlyPaired || state == .missing {
        if let url = self?.kitSetupViewModel.needHelpURL {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
      
    }).disposed(by: disposeBag)
  }
  
  private func showAllReadyAnimation() {
    if !hasShownAllReadyAnimation {
      hasShownAllReadyAnimation = true
      titleLabel.text = "Congrats! You've successfully completed kit setup!"
      subtitleLabel.text = nil
      
      
      confettiView.startConfetti()
      
      UIView.animate(withDuration: 0.4) { [weak self] in
        self?.tutorialBannerHeight.constant = 0
      }
    }
  }
  
  private func handleExitDisposition() {
    switch kitSetupViewModel.exitDisposition {
    case .ready:
      dismissPairedDevicesBeforeExit()
    case .activationIncomplete:
      performSegue(withIdentifier: segueToActivationPopup, sender: self)
    case .customizationIncomplete:
      performSegue(withIdentifier: segueToCustomizationPopup, sender: self)
    }
  }
  
  private func handleNeedHelpTap() {
    UIApplication.shared.open(kitSetupViewModel.needHelpURL, options: [:], completionHandler: nil)
  }
  
  fileprivate func dismissPairedDevicesBeforeExit() {
    kitSetupDismissPairedDevices()
  }
  
  fileprivate func goToDashboard() {
    ApplicationRoutingService.defaultService.showDashboard()
  }
  
  @objc private func handleTutorialBannerTap() {
    UIApplication.shared.open(kitSetupViewModel.tutorialVideoURL, options: [:], completionHandler: nil)
  }
  
}

// MARK: KitSetupActivationPopupDelegate

extension KitSetupViewController: KitSetupActivationPopupDelegate {
  func activationPopupDashboardButtonPressed() {
    dismissPairedDevicesBeforeExit()
  }
}

// MARK: KitSetupCustomizationPopupDelegate

extension KitSetupViewController: KitSetupCustomizationPopupDelegate {
  func customizationPopupDashboarButtonPressed() {
    dismissPairedDevicesBeforeExit()
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension KitSetupViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let halfCollectionViewWidth = devicesCollectionView.frame.width/2
    return CGSize(width: halfCollectionViewWidth , height: 180)
  }
  
}

