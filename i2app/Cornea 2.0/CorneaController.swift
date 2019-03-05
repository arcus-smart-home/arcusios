//
//  CorneaController.swift
//  i2app
//
//  Created by Arcus Team on 12/18/17.
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
import CocoaLumberjack
import RxSwift
import Cornea

// TODO: Remove these Bio Auth constants
extension Constants {
  static let kOldInstall: String = "OldInstall"
  static let BiometricAuthenticationTimeoutInterval: TimeInterval = 30 // 30 seconds
  static let kGateKeeperViewTag: Int = 4283 // G-A-T-E on the keypad, keep this unique
}

typealias BackgroundHandler = () -> Void

class CorneaController: ArcusApplicationServiceProtocol, BiometricAuthenticationMixin {

  var disposeBag = DisposeBag()
  var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
  var backgroundHandler: BackgroundHandler?
  var suspendRouting: Bool = false
  var suspendCacheLoadRouting: Bool = false

  private static var shared: CorneaController?

  // MARK: Initialization

  required init(eventPublisher: ArcusApplicationServiceEventPublisher) {
    observeApplicationEvents(eventPublisher)

    // Observe session events
    if let session = RxCornea.shared.session as? RxSwiftSession {
      observeSessionState(session)
    }

    // Observe cacheLoader events
    if let cacheLoader = RxCornea.shared.cacheLoader as? RxSwiftModelCacheLoader {
      observeCacheLoaderStatus(cacheLoader)
    }

    CorneaController.shared = self
  }

  // MARK: ArcusApplicationServiceProtocol Conformance

  func serviceDidFinishLaunching(_ event: ArcusApplicationServiceEvent) {
    DDLogInfo("CorneaController.serviceDidFinishLaunching()")

    // Display Loading View
    presentLogoLoading()

    // Disabled Biometric Authentication on reinstall.
    _ = disableOnReinstall()

    // Remove the token and logout the user on reinstall.
    _ = removeTokenOnReinstall()

    // Attempt to proceed into the app normally.
    resumeActivity()
  }

  typealias BiometricAuthenticationCompletion = () -> Void
  var biometricCompletion: BiometricAuthenticationCompletion?

  func serviceDidBecomeActive(_ event: ArcusApplicationServiceEvent) {
    DDLogInfo("CorneaController.serviceDidBecomeActive()")

    // Nilling out backgroundHandler as soon as app resumes to prevent accidental execution of block.
    backgroundHandler = nil
  }

  func serviceWillEnterForeground(_ event: ArcusApplicationServiceEvent) {
    DDLogInfo("CorneaController.serviceWillEnterForeground()")

    // If backgroundTask is not UIBackgroundTaskInvalid, then application has returned within
    // 30 seconds of backgrounding.
    if backgroundTask != UIBackgroundTaskInvalid {
      DDLogInfo("CorneaController resumed within 30 seconds.  Ending Backround Task.")
      endBackgroundTask()
    } else {
      DDLogInfo("CorneaController resumed after 30 seconds.  Resuming normally.")
      resumeActivity()
    }
  }

  func serviceWillResignActive(_ event: ArcusApplicationServiceEvent) {
    DDLogInfo("CorneaController.serviceWillResignActive()")
  }

  func serviceDidEnterBackground(_ event: ArcusApplicationServiceEvent) {
    DDLogInfo("CorneaController.serviceDidEnterBackground()")
    registerBackgroundTask()
  }

  // MARK: Routing Suspension

  /**
   * Prevents the next cache load from performing any view routing (i.e., taking user to
   * the dashboard). Provides one-shot behavior; flag resets to false upon next cache
   * loaded event.
   */
  static func suspendCacheLoadRouting(_ suspend: Bool) {
    CorneaController.shared?.suspendCacheLoadRouting = suspend
  }

  static func suspendRouting(_ suspend: Bool) {
    CorneaController.shared?.suspendRouting = suspend
  }

  // MARK: Private Methods

  // MARK: Resume From Background

  private func resumeActivity() {
    biometricAuthenticator = BiometricAuthenticator()

    // Ensure we are not locked out or unenrolled
    evaluateBiometricSettings(lockoutHandler: { [weak self] _ in
      self?.biometricAuthenticationLogout(.lockout)
      }, notEnrolledHandler: { [weak self] in
        self?.biometricAuthenticationLogout(.notEnrolled)
    })

    isTouchAuthenticationEnabled().subscribe(
      onSuccess: { [weak self] _ in
        self?.requestLoginAuthentication()
      },
      onError: { _ in
        // Attempt to connect normally.  If no token is found, app will route to login.
        RxCornea.shared.session?.connect()
    }).disposed(by: disposeBag)

    isBiometricAuthUnavailable().subscribe(
      onSuccess: { _ in
        // Attempt to connect normally.  If no token is found, app will route to login.
        RxCornea.shared.session?.connect()
    }).disposed(by: disposeBag)
  }

  // MARK: Reinstall Handling

  /// Return true if logic was needed
  private func removeTokenOnReinstall() -> Bool {
    DDLogInfo("RxArcusSession.removeTokenOnReinstall()")
    let defaults: UserDefaults = UserDefaults.standard
    let previousInstallExists: Bool = defaults.bool(forKey: Constants.kOldInstall)
    if !previousInstallExists {
      DDLogInfo("No key found, removing token")
      defaults.set(true, forKey: Constants.kOldInstall)
      defaults.synchronize()
      RxCornea.shared.session?.logout()
      return true
    }
    return false
  }

  // MARK: BackgroundTask Handling

  private func registerBackgroundTask() {
    DDLogInfo("CorneaController.registerBackgroundTask() called.")

    guard backgroundTask == UIBackgroundTaskInvalid else {
      DDLogError("CorneaController.registerBackgroundTask() aborted: BackgroundTask already exists.")
      return
    }

    // Begin Background Tasks.
    backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
      DDLogInfo("CorneaController Ended UIApplication BackgroundTask.")

      self?.endBackgroundTask()
    }

    // Set Handler.
    backgroundHandler = { [weak self] in
      DDLogInfo("CorneaController.backgroundHandler executed.")
      RxCornea.shared.session?.disconnect()
      self?.endBackgroundTask()
    }

    // Schedule execution of handler in 30 seconds.
    DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 30) { [weak self] in
      DDLogInfo("CorneaController.registerBackgroundTask() executed background handler after delay.")
      self?.backgroundHandler?()
    }
  }

  private func endBackgroundTask() {
    DDLogInfo("CorneaController.endBackgroundTask() executed.")

    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTask = UIBackgroundTaskInvalid
    backgroundHandler = nil
  }

  // MARK: Event Observation

  private func observeSessionState(_ session: RxSwiftSession) {
    session.getState()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] state in
          self?.processSessionState(sessionState: state)
      })
      .addDisposableTo(disposeBag)
  }

  private func observeCacheLoaderStatus(_ cacheLoader: RxSwiftModelCacheLoader) {
    cacheLoader.getStatus()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(
        onNext: { [weak self] status in
          if status.contains(CacheLoadingStatus.dashboardReady) {
            // TODO: upgrade this to a Swift implementation
            FavoriteController.getAllFavoriteModels()

            self?.modelCacheFetched()
          }
      })
      .addDisposableTo(disposeBag)
  }

  // MARK: Routing
  
  private func modelCacheFetched() {
    guard suspendCacheLoadRouting == false else {
      if let cache = RxCornea.shared.cacheLoader, cache.isLoading == false {
        suspendCacheLoadRouting = false
      }
      return
    }
  
    let config = CreateAccountViewController.needsAccountNavController()
    if config.needsConfig == false {
      self.presentDashboard()
    }
  }

  private func processSessionState(sessionState: ArcusSessionStatus) {
    switch sessionState {
    case .initialized, .loading, .inactive:
      self.presentLogoLoading()
    case .unreachable:
      self.showNoConnection()
    case .ended:
      self.presentLogin()
    default:
      return
    }
  }

  private func presentDashboard() {
    guard suspendRouting == false else {
      return
    }

    ApplicationRoutingService.defaultService.showDashboard(popToRoot: false)
  }

  private func presentLogin() {
    guard suspendRouting == false else { return }
    ApplicationRoutingService.defaultService.showLogin(completion: nil)
  }

  private func presentLogoLoading() {
    guard suspendRouting == false else { return }
    ApplicationRoutingService.defaultService.showLoading()
  }

  private func showNoConnection() {
    guard suspendRouting == false else { return }
    ApplicationRoutingService.defaultService.showNoConnection()
  }

  // MARK: Biometric Authentication (TouchID/FaceID)

  func biometricAuthenticationLogout(_ message: BiometricAuthenticationMessage) {
    if message == .notEnrolled {
      self.disableTouchAuthentication()
    }

    // Will display message once app has routed to login.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        ApplicationRoutingService.defaultService.displayMessage(message)
    }
    biometricAuthenticator = BiometricAuthenticator()
    RxCornea.shared.session?.logout()
  }
}
