//
//  PairingStepsPageViewController.swift
//  i2app
//
//  Arcus Team on 2/14/18.
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
import RxSwift
import RxCocoa

/**
 View controller responsible for displaying the pairing steps. Architected as a vertical
 stack view with three elements:

 1) The "Watch tutorial" video banner (hidden for products without a video available)
 2) The view pager displaying swipable pairing steps (including page ctrl dots)
 3) The "NEXT" button footer

 *See Also*
 PairingStepsPagerViewController

*/
class PairingStepsParentViewController: UIViewController,
  PairingStepsDelegate,
  PairingStepsPagerDelegate,
  C2CNavigationDelegate,
  BackButtonDelegate,
  AdvancedPairingMessageBoxViewable,
  PairingStepsStepViewControllerFactory,
  PairingStepsCustomStepDelegate {

  // MARK: needed for AdvancedPairingMessageBoxViewable
  @IBOutlet weak var messageBox: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var messageBoxTopConstraint: NSLayoutConstraint!

  @IBOutlet weak var pagerView: UIView!
  @IBOutlet weak var nextButton: ScleraButton!
  @IBOutlet weak var videoBanner: UIView!
  
  @IBOutlet weak var secondaryActionContainer: UIView!
  @IBOutlet weak var secondaryActionButton: UIButton!

  var disposeBag = DisposeBag()

  var productAddress: String?

  // MARK: PairingStepsCustomStepDelegate
  var loadingTitle: Variable<String> = Variable<String>("")
  var loadingStatus: Variable<String> = Variable<String>("")
  var pagingEnabled: Variable<Bool> = Variable<Bool>(true)
  var shouldAttemptPairing: Variable<Bool> = Variable<Bool>(false)
  var stepsMovedBackSubject: PublishSubject<Int> = PublishSubject<Int>()

  var deviceName: String?
  var deviceShortName: String?
  var ipcdDeviceType: String?

  /// Default Presenter is an instance of `PairingStepsPresenter` and created on init
  var presenter = PairingStepsPresenter()

  private var viewModel: PairingStepsViewModel?
  private var stepViewControllers: [UIViewController] = []
  private var pagerController: PairingStepsPagerViewController?
  private var videoView: UIWebView?
  private var secondaryAction = {}

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  
    if let title = deviceName {
      navigationItem.title = title
    }

    presenter.delegate = self
    if let product = productAddress {
      presenter.startPairing(productAddress: product)
    }

    if let pageController = pagerController {
      addChildViewController(pageController)
    }

    // Configure Video
    videoBanner.isHidden = true

    addScleraBackButton(delegate: self)
    addScleraStyleToNavigationTitle()

    pagingEnabled
      .asObservable()
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: disposeBag)

    pagingEnabled
      .asObservable()
      .subscribe(
        onNext: { [pagerController] enabled in
          if enabled {
            pagerController?.enablePaging()
          } else {
            pagerController?.disablePaging()
          }
      }).disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIApplication.shared.isIdleTimerDisabled = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Hide the banner if the user quickly clicks back from the pairing cart
    shouldHideAdvancedPairingBanner(false)
  }

  // MARK: Presenter Delegate

  func onLoadedPairingSteps(viewModel: PairingStepsViewModel) {
    self.viewModel = viewModel

    if !viewModel.isBLEPairing {
      // Configure Banner
      startMonitoringPairing()
    }

    stepViewControllers = []
    for step in viewModel.steps {
      if let stepVC = pairingStepsStepViewController(step, presenter: presenter) {
        stepViewControllers.append(stepVC)
      } else {
        DDLogError("Bug! Unable to instantiate view controller.")
      }
    }
    
    pagerController?.setPages(stepViewControllers)
    if let isEmpty = viewModel.videoUrl?.isEmpty {
      videoBanner.isHidden = isEmpty
    } else {
      videoBanner.isHidden = true
    }
  }

  func onPairingError(_ reason: String) {
    self.displayGenericErrorMessage()
    DDLogError(reason)
  }
  
  func onSetProceedEnabled(_ enable: Bool) {
    self.nextButton.isEnabled = enable
  }
  
  func onSearchTimeout(_ disposition: CartDisposition) {
    let isBLE = presenter.viewModel?.isBLEPairing ?? false
    if viewIfLoaded?.window != nil && !isBLE {
      performSegue(withIdentifier: PairingStepSegues.segueToTimeoutPopover.rawValue,
                   sender: disposition)
    } else {
      DDLogInfo("Ignoring request to show timeout because pairing cart is not visible.")
    }
  }

  func onPairingComplete(zwRebuild: Bool) {
    if zwRebuild {
      ApplicationRoutingService.defaultService.showZWRebuild()
    }
  }
  
  private func newStepViewController(step: ArcusPairingStepViewModel) -> UIViewController? {
    return PairingInstructionViewController.fromPairingStep(step: step, presenter: presenter)
  }
  
  func onSegueToSearching(formInput: [String:String]) {
    performSegue(withIdentifier: PairingStepSegues.segueToPairingCart.rawValue, sender: formInput)
  }

  func onSegueToCloudToCloud(c2cStyle: CloudToCloudStyle, c2cUrl: URL) {
    performSegue(withIdentifier: PairingStepSegues.segueToCloudToCloudConnect.rawValue, sender: nil)
  }

  func completeCustomPairing() {
    shouldAttemptPairing.value = true
  }

  func onCompletedPairing() {
    // dismiss to dashboard
    navigationController?.popToRootViewController(animated: true)
  }
  
  // MARK: PairingStepsPagerDelegate

  func onPageChanged(isLastPage: Bool,
                     stepViewModel: ArcusPairingStepViewModel?) {
    let isC2C = viewModel?.isCloudToCloudConnected() ?? false
    let isWSS = viewModel?.isWiFiPairing ?? false
    let isBLE = viewModel?.isBLEPairing ?? false
    let isCustom = isWSS || isBLE
    let isVoiceAssistant = viewModel?.isVoiceAssistant ?? false
    
    if !isLastPage || (isLastPage && isC2C) {
      nextButton.setTitle("NEXT", for: UIControlState.normal)
    } else if isLastPage && isVoiceAssistant {
       nextButton.setTitle("I'M DONE PAIRING", for: UIControlState.normal)
    } else if isLastPage && isBLE {
      nextButton.setTitle("CONNECT", for: UIControlState.normal)
    } else {
      nextButton.setTitle("START SEARCHING", for: UIControlState.normal)
    }
    
    if let step = stepViewModel as? PairingStepsStepViewModel,
      let secondaryText = step.secondaryActionText {
      secondaryActionContainer.isHidden = false
      secondaryActionButton.setTitle(secondaryText, for: UIControlState.normal)
      secondaryAction = { [step] in
        if let url = step.secondaryActionURL {
          UIApplication.shared.open(url)
        }
      }
    } else {
      secondaryActionContainer.isHidden = true
      secondaryAction = {}
    }

    let enabled  = !isLastPage || presenter.hasCompletedForm()
    if !isCustom {
      pagingEnabled.value = enabled
    }
  }
  
  func pageDidChange(_ index: Int, direction: UIPageViewControllerNavigationDirection) {
    let isCustom = viewModel?.isWiFiPairing ?? false || viewModel?.isBLEPairing ?? false

    if isCustom == true && direction == .reverse {
      stepsMovedBackSubject.onNext(index)

      // Ensure correct the Next button title.
      nextButton.setTitle("NEXT", for: UIControlState.normal)
    }
  }
  
  // MARK: Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == PairingStepSegues.segueToPager.rawValue {
      if let pagerController = segue.destination as? PairingStepsPagerViewController {
        self.pagerController = pagerController
        self.pagerController?.stepsDelegate = self
        pagerController.setPages(stepViewControllers)
      }
    } else if segue.identifier == PairingStepSegues.segueToYouTube.rawValue {
      if let youTubePlayer = segue.destination as? YouTubePlayerViewController,
        let url = sender as? String {
        youTubePlayer.videoId = parseVideoIdFromUrl(url: url)
      }
    } else if segue.identifier == PairingStepSegues.segueToCloudToCloudConnect.rawValue {
      if let navigationController = segue.destination as? UINavigationController,
        let c2cController = navigationController.topViewController as? C2CPairingViewController,
        let c2cStyle = viewModel?.c2cStyle,
        let c2cUrl = viewModel?.c2cUrl {

        c2cController.presenter.navigationDelegate = self
        c2cController.presenter.cancelDelegate = c2cController
        c2cController.c2cUrl = c2cUrl
        c2cController.c2cStyle = c2cStyle
      }
    } else if segue.identifier == PairingStepSegues.segueToPairingCart.rawValue {
      if let cartController = segue.destination as? PairingCartViewController,
        let formInput = sender as? [String:String] {
        cartController.productAddress = self.productAddress
        cartController.formInput = formInput
      }
      if let cartController = segue.destination as? PairingCartViewController,
        let searchingOnLoad = sender as? Bool {
        cartController.startSearchingOnLoad = searchingOnLoad
      }
    } else if segue.identifier == PairingStepSegues.segueToTimeoutPopover.rawValue,
      let vc = segue.destination as? PairingTimeoutViewController,
      let disposition = sender as? CartDisposition {
      vc.delegate = self
      vc.topButtonSender = disposition
      vc.bottomButtonSender = disposition
      if disposition == .timeoutNoDevices {
        vc.titleText = "Pairing Has Timed Out"
        vc.subtitleText = "Do you want to keep searching for new devices?"
        vc.topButtonTitle = "YES, KEEP SEARCHING"
        vc.bottomButtonTitle = "NO, GO TO DASHBOARD"
      } else if disposition == .timeoutWithDevices {
        vc.titleText = "Pairing Has Timed Out"
        vc.subtitleText = "Do you want to keep searching for new devices?"
        vc.topButtonTitle = "YES, KEEP SEARCHING"
        vc.bottomButtonTitle = "NO, VIEW MY DEVICES"
      }
    } else if let bleErrorPopup = segue.destination as? BLEPairingDeviceNotFoundErrorViewController {
      bleErrorPopup.shortName = deviceShortName
      bleErrorPopup.ipcdDeviceType = ipcdDeviceType
      bleErrorPopup.tryAgainHandler = { [unowned self] _ in
        self.pagerController?.goToPageIndex(2, completion: nil)
        self.dismissPopup(nil)
      }
    } else if let bleErrorPopup = segue.destination as? BLEPairingUnableToSendInfoErrorViewController {
      bleErrorPopup.shortName = deviceShortName
      bleErrorPopup.ipcdDeviceType = ipcdDeviceType
      bleErrorPopup.tryAgainHandler = { [unowned self] _ in
        self.dismissPopup(nil)
      }
    } else if let bleErrorPopup = segue.destination as? BLEPairingErrorViewController {
      if segue.identifier == PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.pagerController?.goToPageIndex(1, completion: nil)
          self.dismissPopup(nil)
        }
      } else if segue.identifier == PairingStepSegues.segueToBLEConnectionLostErrorPopOver.rawValue {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.pagerController?.goToPageIndex(2, completion: nil)
          self.dismissPopup(nil)
        }
      } else {
        bleErrorPopup.tryAgainHandler = { [unowned self] _ in
          self.dismissPopup(nil)
        }
      }
    } else if let bleConnectingPopup = segue.destination as? BLEPairingLoadingPopUpViewController {
      bleConnectingPopup.loadingTitle = loadingTitle
      bleConnectingPopup.loadingStatus = loadingStatus
    }
  }
  
  private func parseVideoIdFromUrl(url: String) -> String? {
    return url.components(separatedBy: "/").last
  }
  
  // MARK: BackButtonDelegate
  
  func onBackButtonPressed() {
    // Attempt to navigate to previous page; if that fails, pop the nav stack
    if !(pagerController?.goPreviousPage() ?? false) {
      stepsMovedBackSubject.onNext(0)
      presenter.abortPairing()
      navigationController?.popViewController(animated: true)
    }
  }

  // MARK: Cloud-to-Cloud Delegate
  
  func onCloudToCloudConnectionSucceeded() {
    performSegue(withIdentifier: CloudToCloudSegues.segueToPairingCart.rawValue, sender: nil)
  }
  
  func onCloudToCloudConnectionFailed() {
    dismiss(animated: true, completion: nil)
  }
  
  func onCloudToCloundCanceled() {
    performSegue(withIdentifier: CloudToCloudSegues.unwindToBrandList.rawValue, sender: nil)
  }
  
  // MARK: - IBActions
  
  @IBAction func onNextPressed(_ sender: Any) {
    if !(pagerController?.goNextPage() ?? false) {
      presenter.completePairingSteps()
    }
  }
  
  @IBAction func onSecondaryActionPressed(_ sender: Any) {
    secondaryAction()
  }
  
  @IBAction func onVideoBannerTapped(_ sender: UITapGestureRecognizer) {
    if let url = viewModel?.videoUrl {
      performSegue(withIdentifier: PairingStepSegues.segueToYouTube.rawValue, sender: url)
    }
  }

  @IBAction func onAdvancedPairingBannerTapped(_ sender: UITapGestureRecognizer) {
    performSegue(withIdentifier: PairingStepSegues.segueToPairingCart.rawValue, sender: nil)
  }

  // MARK: - PairingStepsCustomStepDelegate

  func attemptAdvanceToNextStep() {
    onNextPressed(self)
  }

  func customPairingCompleted() {
    dismissPopup {
      self.performSegue(withIdentifier: PairingStepSegues.segueToPairingCart.rawValue, sender: false)
    }
  }

  func showPopupWithSegue(_ indentifier: String) {
    if let presentedViewController = presentedViewController {
      presentedViewController.dismiss(animated: true, completion: {
        self.performSegue(withIdentifier: indentifier, sender: self)
      })
    } else {
      performSegue(withIdentifier: indentifier, sender: self)
    }
  }

  func dismissPopup(_ completion: (() -> Void)? = nil) {
    presentedViewController?.dismiss(animated: true, completion: completion)
  }
}

extension PairingStepsParentViewController: PairingTimeoutDelegate {

  // User clicked the "CUSTOMIZE DEVICE(S)" or "KEEP SEARCHING" button
  func onTimeoutTopButtonTapped(_ sender: Any?) {
    if let disposition = sender as? CartDisposition {
      switch disposition {
      case .clean, .timeoutWithDevices, .timeoutNoDevices:
        if let product = productAddress {
          presenter.startPairing(productAddress: product)
        }
      case .noDevices, .uncustomizedDevices, .mispairedDevices:
        break
      }
    }
  }

  // User clicked the "GO TO DASHBOARD" or "NO, VIEW MY DEVICES" button
  func onTimeoutBottomButtonTapped(_ sender: Any?) {
    if let disposition = sender as? CartDisposition {
      switch disposition {
      case .clean, .noDevices, .uncustomizedDevices, .mispairedDevices, .timeoutNoDevices:
        presenter.dismissAll()
        navigationController?.popToRootViewController(animated: true)
      case .timeoutWithDevices:
        performSegue(withIdentifier: PairingStepSegues.segueToPairingCart.rawValue,
                     //sender as false will prevent the cart from restarting pairing mode
                     sender: false)
        break
      }
    }
  }
}

enum PairingStepSegues: String {
  case segueToPager = "PairingStepsPagerSegue"
  case segueToYouTube = "YouTubeSegue"
  case segueToTimeoutPopover = "PairingTimeoutSegue"
  case segueToZwRebuild = "ZwRebuildSegue"
  case segueToCloudToCloudConnect = "C2CConnectSegue"
  case segueToWifiSmartSwitchConfig = "WSSPairingSegue"
  case segueToPairingCart = "PairingCartSegue"

  // WSS Pairing
  case segueToWSSConnectingPopover = "WSSPairingShowConnectingPopupSegue"
  case segueToWSSConnectionErrorPopover = "WSSPairingShowConnectionErrorPopupSegue"
  case segueToWSSDeviceClaimedErrorPopover = "WSSPairingShowDeviceClaimedErrorPopupSegue"
  case segueToWSSCheckWifiErrorPopover = "WSSPairingShowCheckWiFiErrorPopupSegue"

  // BLE Pairing
  case segueToBLENotEnabledErrorPopOver = "BLENotEnabledErrorPopOverSegue"
  case segueToBLEConnectionLostErrorPopOver = "BLEConnectionLostErrorPopOverSegue"
  case segueToBLEConfigFailedErrorPopOver = "BLEConfigFailedErrorPopOverSegue"
  case segueToBLEDeviceClaimedErrorPopover = "BLEPairingShowDeviceClaimedErrorPopupSegue"
  case segueToBLEDeviceNotFoundErrorPopover = "BLEPairingShowDeviceNotFoundErrorPopupSegue"
  case segueToBLECheckWifiErrorPopover = "BLEPairingShowCheckWiFiErrorPopupSegue"
  case segueToBLELoadingPopOver = "BLELoadingPopOverSegue"
}

/// View Controllers conforming to Advanced Pairing Banner Presenter can have the banner
/// managed by this protocol as a trait
protocol AdvancedPairingMessageBoxViewable: PairingMessageBoxPresenter, ArcusMessageBoxViewable { }

/// A Viewable Message Box when a UIViewController
/// - seealso: PairingStepsParentViewController which conforms to this protocol
extension AdvancedPairingMessageBoxViewable where Self: UIViewController {

  func shouldPresentAdvancedPairingBanner(withText text: String) {
    shouldPresentBanner(withText: text)
  }

  func shouldHideAdvancedPairingBanner(_ animated: Bool = true) {
    shouldHideBanner(animated)
  }
}
