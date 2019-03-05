//
//  ApplicationRoutingService.swift
//  i2app
//
//  Created by Arcus Team on 10/24/17.
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

import Foundation
import Cornea
import RxSwift
import CocoaLumberjack
import SWRevealViewController

extension Constants {
  static let loginIdentifier: String = "LoginNavigationController"
  static let createAcountIdentifier: String = "CompleteAccountNavigationController"
  static let checkYourEmailIdentifier: String = "CheckYourEmailNavigationController"
  static let accountAlmostReadyIdentifier: String = "AccountAlmostReadyNavigationController"
  static let getStartedIdentifier: String = "GetStartedNavigationController"

  /// To ensure one Account Create Stack gets created at a time
  static let accountCreateNavTag = 628 // NAV
}

final class ApplicationRoutingService: NSObject, ArcusApplicationServiceProtocol {
  static let defaultService: ApplicationRoutingService = ApplicationRoutingService()
  var disposeBag: DisposeBag = DisposeBag()

  var drivers: [ArcusRoutingDriver] = [AlarmIncidentRoutingDriver(),
                                      ModalAlertRoutingDriver(),
                                      AccountCreationRoutingDriver()]

  var window: UIWindow? {
    return UIApplication.shared.delegate?.window as? UIWindow
  }

  private var _dashboardViewController: DashboardTwoViewController?
  private var dashboardViewController: DashboardTwoViewController? {
    if _dashboardViewController == nil {
      guard let dashboardViewController =
        UIStoryboard(name: "Dashboard", bundle: nil)
          .instantiateViewController(withIdentifier: "Dashboard")
          as? DashboardTwoViewController else {
            return nil
      }

      guard let rearViewController = SlideMenuViewController.create() else {
        DDLogError("SlideMenu unavailable")
        return nil
      }
      
      let frontNavigationController = UINavigationController(rootViewController:dashboardViewController)
      let revealController = SWRevealViewController(rearViewController: rearViewController,
                                                    frontViewController: frontNavigationController)
      dashboardViewController.revealController = revealController
      _dashboardViewController = dashboardViewController
    }
    return _dashboardViewController
  }

  // MARK: Initialization

  required override init() {
    super.init()
    showLoading()
    _ = self.dashboardViewController
  }

  // MARK: Routing Methods

  func displayMessage(_ message: BiometricAuthenticationMessage) {
    let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                  style: .`default`,
                                  handler: { _ in

    }))
    if let root = window?.rootViewController {
      root.present(alert, animated: true, completion: nil)
    }
  }

  /**
   Display Application Loading Screen as RootViewController.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showLoading(completion: (() -> Void)? = nil) {
    // Do not show loading view if already visible.
    guard !(window?.rootViewController is LogoLoadingViewController) else {
      return
    }

    // Do not show loading view as a result of login in AccountCreationViewController.
    guard !(displayingViewController() is AccountCreationViewController) else {
      return
    }

    // Do not show loading view as a result of reconnecting during WSS Pairing.
    guard isInWSSPairing() == false else {
      return
    }

    // Get Dashboard; if already set at the RootViewController then return.
    guard let dashboard: SWRevealViewController = dashboardViewController?.revealController,
      window?.rootViewController != dashboard else {
        if isDisplayingAlarm() == false && isInWSSPairing() == false {
          showLoadingModal(completion: completion)
        }
        return
    }

    // Get Loading Storyboard
    let storyboard: UIStoryboard = UIStoryboard(name: "Loading", bundle: nil)

    // Get Loading View Controller
    guard let viewController = storyboard
      .instantiateViewController(withIdentifier: "LogoLoading") as? LogoLoadingViewController else {
        return
    }

    // Set Loading as RootViewController
    setRootViewController(viewController, animated: false, completion: completion)
  }

  /**
   Display Application Loading Screen Modally.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showLoadingModal(completion: (() -> Void)? = nil) {
    // Do not show loadingModal if already presented.
    guard (getCurrentModal() is LogoLoadingViewController) == false else { return }

    // Get Loading Storyboard
    let storyboard: UIStoryboard = UIStoryboard(name: "Loading", bundle: nil)

    // Get Loading View Controller
    guard let viewController = storyboard
      .instantiateViewController(withIdentifier: "LogoLoading") as? LogoLoadingViewController else {
        return
    }

    // Display Loading Modal
    displayModal(viewController, completion: completion)
  }

  /**
   Display Dashboard as RootViewController.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showDashboard(animated: Bool = true, popToRoot: Bool = true, completion: (() -> Void)? = nil) {
    // Get Dashboard; if already set at the RootViewController then return.
    guard let dashboard: SWRevealViewController = dashboardViewController?.revealController,
      window?.rootViewController != dashboard else {
        if isDisplayingAlarm() == false
          && isInWSSPairing() == false
          && isDisplayingPriorityModal() == false {

          if popToRoot {
            dashboardViewController?.navigationController?.popToRootViewController(animated: animated)
          }

          if getCurrentModal() is LogoLoadingViewController {
            dismissModals(animated: animated, completion: nil)
          }

          completion?()
        }
        return
    }

    // Set Dashboard as RootViewController
    setRootViewController(dashboard, animated: animated, completion: completion)
  }

  /**
   Display Login as RootViewController.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showLogin(completion: (() -> Void)? = nil) {
    // Do not show Login if already visible.
    if let nav = window?.rootViewController as? UINavigationController,
      nav.topViewController is LoginViewController {
      if !(displayingViewController() is LetsGetAcquaintedViewController)
        && !(displayingViewController() is AccountCreationViewController) {
        dismissModals()
      }
      return
    }

    // Need to make sure the dashboard doesn't hold previous navigation stack.
    dashboardViewController?.navigationController?.popToRootViewController(animated: false)

    // Get the Login Storyboard.
    let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)

    // Get Login Navigation Controller
    let login = storyboard
      .instantiateViewController(withIdentifier: Constants.loginIdentifier)

    // Set Login as RootViewController.
    setRootViewController(login, completion: completion)
  }

  /**
   Display No Connection View Modally.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showNoConnection(completion: (() -> Void)? = nil) {
    // TODO: Check Alert View Type and only return if they match?
    // If current modal is Alert View, then don't show Alert View.
    guard !(getCurrentModal() is AlertActionSheetViewController) else { return }

    // Get the No Connection ViewController.
    let noConnectionViewController: AlertActionSheetViewController =
      AlertActionSheetViewController.create(.internetERROR)

    // Display the No Connection modal.
    displayModal(noConnectionViewController, completion: completion)
  }

  /**
   Display AccountCreation User Flow as RootViewController.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showCompleteAccoutCreation(completion: (() -> Void)? = nil) {
    let storyboard: UIStoryboard = UIStoryboard(name: "CreateAnAccount", bundle: nil)
    let completeAccount = storyboard
      .instantiateViewController(withIdentifier: Constants.createAcountIdentifier)

    setRootViewController(completeAccount, completion: completion)
  }

  /**
   Display CheckYourEmailViewController as RootViewController.
   */
  func showCheckYourEmail() {
    // Do not show check your email view if result of AccountCreationViewController.
    // AccountCreationViewController will segue to CheckYourEmailViewController.
    // This is intended to be used when the user enters the app with account creation state == SIGNUP1.
    guard !(displayingViewController() is AccountCreationViewController) else {
      return
    }

    // Do not show if already visible
    guard !(displayingViewController() is CheckYourEmailViewController) else {
      return
    }

    // Get NavigationController, CheckEmailViewController, and CurrentPerson.
    let storyboard: UIStoryboard = UIStoryboard(name: "AccountCreation", bundle: nil)
    guard let navigationController =
      storyboard.instantiateViewController(withIdentifier: Constants.checkYourEmailIdentifier)
        as? UINavigationController,
      let checkEmailViewController = navigationController
      .viewControllers.first as? ArcusResendEmailPresenter,
      let currentPerson = RxCornea.shared.settings?.currentPerson else {
      return
    }

    // Inject Current Person.
    checkEmailViewController.personModel = currentPerson

    setRootViewController(navigationController)
  }

  /**
   Display AccountCreationGetStartedViewController as RootViewController.
   */
  func showGetStarted() {
    // Prevent double push
    guard !(displayingViewController() is AccountCreationGetStartedViewController) else { return }

    let storyboardAccountCreation = UIStoryboard(name: "CreateAnAccount", bundle: nil)
    let getStarted = storyboardAccountCreation
      .instantiateViewController(withIdentifier: Constants.getStartedIdentifier)

    setRootViewController(getStarted)
  }

  /**
   Display AccountAlmostReadyViewController as RootViewController.
   */
  func showAccountAlmostReady() {
    // Get NavigationController, AccountAlmostReadyViewController, and CurrentPerson.
    let storyboard: UIStoryboard = UIStoryboard(name: "AccountCreation", bundle: nil)
    guard let navigationController =
      storyboard.instantiateViewController(withIdentifier: Constants.accountAlmostReadyIdentifier)
        as? UINavigationController,
      let accountAlmostReadyViewController = navigationController
        .viewControllers.first as? ArcusPersonNameEmailPresenter,
      let currentPerson = RxCornea.shared.settings?.currentPerson else {
        return
    }

    // Inject Current Person.
    accountAlmostReadyViewController.personModel = currentPerson

    setRootViewController(navigationController)
  }

  /**
   Display AccountCreation as RootViewController.
   */
  func showAccountCreation() {
    // Guard against displaying twice
    if let currentRoot = window?.rootViewController as? UINavigationController,
      currentRoot.view.tag == Constants.accountCreateNavTag {
      DDLogError("Attempt to show account creation, but already in Account creation")
      return
    }
    guard let navigation: UINavigationController =
      CreateAccountViewController.getAccountNavController() else {
      DDLogError("Attempt to show account creation, but failed to get next view controller")
      return
    }
    setRootViewController(navigation, animated: false, closeModals: false)
    navigation.view.tag = Constants.accountCreateNavTag
  }

  /**
   Push HubPairing View onto RootViewController.
   */
  func showHubPairing() {
    showDashboard(animated: false, completion: {
      let hubPairing = HubPairingBuilder.buildHubOrKit()
      if let dashboardNavController = self.dashboardViewController?.navigationController {
        dashboardNavController.pushViewController(hubPairing, animated: false)
      } else {
        DDLogError("Attempt to show hub product catalog, but no dashboard navigation controller with which to present it.")
      }
    })
  }
  
  /**
   Push Product Catalog View onto RootViewController.
   */
  func showPairingCatalog(_ showOnlyWifiDevices: Bool) {
    showDashboard(animated: false, completion: {
      DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        if let vc = CatalogBrandListViewController.create(),
        let dashboardNavController = self.dashboardViewController?.navigationController {
          if showOnlyWifiDevices {
            vc.selectedFilter = .noHubRequired
          }
          
          dashboardNavController.pushViewController(vc, animated: false)
        } else {
          DDLogError("Attempt to show product catalog, but no dashboard navigation controller with which to present it.")
        }
      })
    })
  }

  /**
   Display TermsAndConditions View Modally.
   */
  func showTermsAndConditions() {
    let tnc: TermsConditionsViewController = TermsConditionsViewController.create()
    let navigationController: UINavigationController = UINavigationController(rootViewController: tnc)

    displayModal(navigationController)
  }

  /**
   Displays the alarm offline warning popup if needed. This warning should only be displayed when the user is
   within the alarms workflow, with the exception of the alarm tracker.
   */
  func showAlarmOfflineWarning() {
    showDashboard(animated: false) {
      guard let dashboardNavController = self.dashboardViewController?.navigationController else { return }
      if self.shouldPresentAlarmOfflineWarning() {
        let storyboard = UIStoryboard(name: "AlarmOfflineWarning", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AlarmOfflineWarning")
        dashboardNavController.present(viewController, animated: true, completion: nil)
      }
    }
  }

  /**
    Display the Care Incident immediately without an animation the view stack looks like so
    view heirarchy: [Dashboard:Nav, Care, Status:Tab:1] presented alert view
    view heirarchy is actually handled by the Care VC's themselves using knowledge of
    the Nav stack they probabaly shouldn't have.
   */
  func showCareIncident() {
    // Stop pairing process before routing
    DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()

    CareAlarmViewController.create { vc in
      self.showDashboard(animated: false) {
        DispatchQueue.main.async {
          guard let dashboardNavController = self.dashboardViewController?.navigationController else { return }
          _ = dashboardNavController.popToRootViewController(animated: false)
          dashboardNavController.pushViewController(vc!, animated:false)
        }
      }
    }
  }

  /// view heirarchy: [Dashboard, Alarms, Status:Tab, Security]
  func showAlarmIncident(_ alarmSubsystem: SubsystemModel, incidentId: String) {
    // Do not show Tracker if already visible.
    if window?.rootViewController?.navigationController?.topViewController is AlarmTrackerViewController {
      return
    }

    guard incidentId.count > 0 else {
      return
    }

    // Stop pairing process before routing
    DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()

    DispatchQueue.main.async {
      // Make sure that dashboard is the root.
      self.showDashboard(animated: false) {
        DispatchQueue.main.async {
          guard let dashboardNavController = self.dashboardViewController?.navigationController else { return }
          self.dismissModals()
          self.dashboardViewController?.hideLoadingOverlay()

          // Create ViewController Stack: AlarmTab -> AlarmTracker
          var viewControllers: [UIViewController] = dashboardNavController.viewControllers

          let alarmStatusTabBarController = AlarmsTabBarViewController.create()!
          alarmStatusTabBarController.selectedIndex = 0
          viewControllers.append(alarmStatusTabBarController)

          let trackerStoryboard = UIStoryboard(name: "AlarmTracker", bundle: nil)
          if let alarmTrackerViewController =
            trackerStoryboard.instantiateInitialViewController() as? AlarmTrackerViewController {
            alarmTrackerViewController
              .incidentPresenter = AlarmTrackerPresenter(delegate: alarmTrackerViewController,
                                                         subsystemModel: alarmSubsystem,
                                                         incidentId: incidentId)
            viewControllers.append(alarmTrackerViewController)
            dashboardNavController.setViewControllers(viewControllers, animated: false)
          }
        }
      }
    }
  }

  /**
   Future: Display ModalAlert.
   */
  func showModalAlert(_ presenter: ModalAlertPresenter) {
    guard let modalAlertViewController: ModalAlertViewController =
      ModalAlertViewController.create(presenter) else {
        return
    }

    let navigationController: UINavigationController =
      UINavigationController(rootViewController: modalAlertViewController)

    displayModal(navigationController)
  }

  /**
   Future: Display What's New Modal.
   */
  func showWhatsNew() {}

  /**
   Display Application DebugMenu Modally.

   - Parameters:
   - completion: closure to be executed on completion of routing.
   */
  func showDebugMenu() {
    // If the bundle identifier matches the beta bundle, allow the debug menu to display
    if BuildConfigure.clientBundleIdentifier() == i2AppConstants.AppConfig.devClientBundleIdentifier {
      let storyboard = UIStoryboard(name: "DebugMenu", bundle: nil)
      if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
        let viewController = navigationController.viewControllers.first as? DebugMenuViewController {
        viewController.presenter = DebugMenuPresenter(delegate: viewController)

        displayModal(navigationController)
      }
    }
  }

  func showZWRebuild() {
    let storyboard = UIStoryboard(name: "ZWRebuild", bundle: nil)
    if let vc = storyboard.instantiateInitialViewController() {
      dashboardViewController?.navigationController?.popToRootViewController(animated: true)
      displayModal(vc)
    }
  }

  /**
   Route Application to Universal Link.

   - Parameters:
   - url: Univeral link used to route the app to it's appropriate view.
   */
  func route(toUniversalURL url: URL) {
    // TODO: Fix when adding new universal URL handling.
//    // The check for the universal URL mapping to a view controller.
//    guard let viewControllerForURL = UniversalLinkHandler.viewController(forUniversalURL: url) else {
//      DDLogError("Attempt to route to URL, but no view controller available to handle it.")
//      return
//    }
//
//    // Set VC as RootViewController.
//    setRootViewController(viewControllerForURL)
  }

  /**
   Dismiss currently visible Modal.

   - Parameters:
   - completion: Closure to be executed on completion of dismissal.
   */
  func dismissModals(animated: Bool = true, completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      if self.isDisplayingModal() {
        self.window?.rootViewController?.dismiss(animated: animated, completion: completion)
      }
    }
  }

  /**
   Convenience method for classes that do not have direct access to the dashboard's navigation stack,
   and have a need to push a viewController to it.

   - Parameters:
   - viewController: UIViewController to push
   - animated: Bool indicating whether or not the push should be animated.  Defaults to true.
   */
  func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
    DispatchQueue.main.async {
      self.dashboardViewController?.navigationController?.pushViewController(viewController,
                                                                              animated: animated)
    }
  }

  // MARK: Private Methods

  /**
   Set Application Window's RootViewController.

   - Parameters:
   - viewController: UIViewController/UINavigationController to set as the RootViewController.
   - animated: Bool indicating if setting of RootViewController should be animated.
   - closeModals: Bool indicating if setting of RootViewController should close modals first.
   - completion: Completion handler to execute once the rootViewController has been set.
   */
  private func setRootViewController(_ viewController: UIViewController,
                                     animated: Bool = true,
                                     closeModals: Bool = true,
                                     completion: (() -> Void)? = nil) {
    guard let window = self.window else {
      DDLogError("Attempt to set root view controller, but no window to attach it to.")
      return
    }

    // Set display handler.
    let displayHandler: () -> Void = {
      // Animate set rootViewController w/ completion.
      if animated {
        self.animateTransition(window, viewController: viewController, completion: completion)
      } else {
        window.rootViewController = viewController
        completion?()
      }
    }

    // If modal is visible, then dismiss
    if self.isDisplayingModal() && closeModals {
      // Call dismiss with display handler.
      self.dismissModals(animated: animated, completion: displayHandler)
    } else {
      // Execute display handler.
      displayHandler()
    }
  }

  /**
   Display ViewController/UINavigationController Modally.

   - Parameters:
   - viewController: UIViewController/UINavigationController to display.
   - completion: Completion handler to execute once the modal has been presented.
   */
  private func displayModal(_ viewController: UIViewController,
                            animated: Bool = true,
                            completion: (() -> Void)? = nil) {
    // Always perform on the main thread.
    DispatchQueue.main.async {
      // Set display handler.
      let displayHandler: () -> Void = {
      
        if let rootViewController = self.window?.rootViewController {
          // Present Modal from RootViewController.
          rootViewController.present(viewController,
                                                 animated: animated,
                                                 completion: completion)
        } else {
          DDLogError("Attempt to display modal, but no root view controller from which to present it.")
        }
      }

      // If modal is visible, then dismiss
      if self.isDisplayingModal() {
        // Call dismiss with display handler.
        self.dismissModals(completion: displayHandler)
      } else {
        // Execute display handler.
        displayHandler()
      }
    }
  }

  /**
   Private Method to animate the transition of the RootViewController.

   - Parameters:
   - window: UIWindow containing the RootViewController.
   - viewController: UIViewController/UINavigationController to animate the transition of.
   - completion: Closure to execute on completion of animation.
   */
  private func animateTransition(_ window: UIWindow,
                                 viewController: UIViewController,
                                 completion: (() -> Void)? = nil) {
    guard let window = self.window else {
        return
    }

    viewController.view.frame = window.rootViewController!.view.frame
    viewController.view.layoutIfNeeded()

    let animation: () -> Void = {
      window.rootViewController = viewController
    }
    UIView.transition(with: window,
                      duration: 0.3,
                      options: .transitionCrossDissolve,
                      animations: animation,
                      completion: { _ in
                        completion?()
    })
  }

  /**
   Check is RoutingService is currently diplaying a Modal.

   - Return: Bool indicating if a Modal is currently displaying.
   */
  private func isDisplayingModal() -> Bool {
    return getCurrentModal() != nil
  }

  /**
   Get reference of the currently visible Modal ViewController.

   - Return: Optional UIViewController of the Modal that is currently displaying.
   */
  private func getCurrentModal() -> UIViewController? {
    return window?.rootViewController?.presentedViewController
  }

  private func isDisplayingAlarm() -> Bool {
    guard let viewControllers = dashboardViewController?.navigationController?.viewControllers else {
      return false
    }

    var result: Bool = false
    for viewController in viewControllers {
      if viewController is AlarmTrackerViewController
        || viewController is CareAlarmViewController {
        result = true
      }
    }

    return result
  }

  private func isInWSSPairing() -> Bool {
    guard let viewControllers = dashboardViewController?.navigationController?.viewControllers else {
      return false
    }

    var isInPairing = false

    for viewController in viewControllers
      where (viewController is WSSPairingExternalSettingsViewController
        || viewController is WSSExternalSettingsInfoViewController) {
        isInPairing = true
    }
    return isInPairing
  }

  private func isDisplayingPriorityModal() -> Bool {
    return getCurrentModal() is WhatsNewInVersionTwo
      || getCurrentModal() is PromptToEnableBiometricAuthenticationViewController
      || getCurrentModal() is TermsConditionsViewController
  }

  private func shouldPresentAlarmOfflineWarning() -> Bool {
    var isInAlarms = false
    var hasAlarmTracker = false
    if let viewControllers =  window?.rootViewController?.navigationController?.viewControllers {
      for viewController in viewControllers {
        if viewController is AlarmsTabBarViewController {
          isInAlarms = true
        } else if viewController is AlarmTrackerViewController {
          hasAlarmTracker = true
        }
      }
    }
    return isInAlarms && !hasAlarmTracker
  }

  // MARK: Static Methods

  // Use of this function from outside the ApplicationViewRouter should be discouraged. The access level
  // cannot be made private as this is needed externally from Objectice C legacy code.
  func displayingViewController(inViewController viewController: UIViewController? = nil)
    -> UIViewController? {
      var root = viewController

      if root == nil {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        root = delegate?.window?.rootViewController
      }

      if let revealController = root as? SWRevealViewController {
        return displayingViewController(inViewController: revealController.frontViewController)
      }
      if let navigationController = root as? UINavigationController {
        return displayingViewController(inViewController: navigationController.visibleViewController)
      }
      if let tabController = root as? UITabBarController,
        let selected = tabController.selectedViewController {
        return displayingViewController(inViewController: selected)
      }
      if let presented = root?.presentedViewController {
        return displayingViewController(inViewController: presented)
      }

      return root
  }
}
