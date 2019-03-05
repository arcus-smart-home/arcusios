//
//  HubPairingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/8/17.
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
import PromiseKit

/// The States the UI can be in
enum HubPairingState {
  case notStarted
  case pairingHub
  case searchingForHub
  case hubError
  case updateAvailable
  case downloadFailed
  case applyingUpdate
  case installFailed
}

/// Static Constants from the Place Register Hub Pairing
struct PlaceRegisterHubV2ResponseConstants {
  static let Registered = "REGISTERED"
  static let Downloading = "DOWNLOADING"
  static let Applying = "APPLYING"
  static let ErrorRegisterAlreadyRegistered = "error.register.alreadyregistered"
  static let ErrorRegisterOrphandedHub = "error.register.orphanedhub"
  static let ErrorfwupgradeFailed = "error.fwupgrade.failed"
}

/// Static Constants for Hub Pairing
internal struct HubPairingConfig {
  static let pairingUpdateInterval: TimeInterval = 2 // 2 sec
  static let pairingTimeout: TimeInterval = 10 * 60 // 10 min
  static let applyingTimeout: TimeInterval = 5 * 60 // 5  min
  static let downloadTimeout: TimeInterval = 11 * 60 // 11  min
  static let maximumPercentage: Double = 0.9 // 90%
  static let progressPollInterval: TimeInterval = 1 // every second
  static let timeoutPollInterval: TimeInterval = 5 // every 5 seconds
}

/// All functions of this Delegate should be performed on the main thread, this is up the the 
/// Presenter to do not the Delegate itself.
protocol HubPairingDelegate: class, HubPairingNode {

  /// the value of the textfield that has a new Hub ID
  /// Would love to change this to a string accessor and remove the UIKit dependency
  /// Return an empty string `""` if textFeild is nil
  var textFieldText: String! { get }

  /// A way to display an error
  func displayTextErrorMessage(_ errorMessageKey: String)

  /// Update the view
  func update(viewModel: HubPairingViewModel?)

  /// state of the percentage bar
  /// - if nil hide the percentage bar
  /// - if 0.0 don't animate the change
  func update(progress: Float?)

  /// complete the progress view to full
  func completeProgress()

  /// finished the process and continue the flow
  func didFinishPairing()

  /// failed the process, exit the flow, dismiss to dahsboard
  func didFailPairing()

  /// open the phone app and dail the contact center
  func callSupport()
}

protocol HubPairingPresenterProtocol: class,
  HubIdValidator,
  HubPairingTimerDelegate,
  ArcusPlaceCapability {

  /// delegate of the presenter
  var delegate: HubPairingDelegate? { get }

  /// The Hub Id actively pairing
  var hubId: String { get set }
  
  var progressTimer: HubPairingTimer? { get set }
  var timeoutTimer: HubPairingTimer? { get set }
  var pairingTimer: HubPairingTimer? { get set }
  
  var pairingState: HubPairingState { get set }

  /// Defaults to RxCornea.shared.settings?.currentPlace
  var placeId: PlaceModel { get }
  
  /// Used to handle not having more that one Polling request sent at a time
  var requestSending: Bool { get set }

  /// the delegate can call this function to start the pairing process
  func startProcess()

  /// Something has happened at the iOS level that should stop the pairing, backgrounded etc
  func stopProcess()

  /// the button was pressed, the HubPairingPresenter should handle the event based on it's state
  /// Must be called on the Main Thread. Only the HubPairingDelegate should call this function on a
  /// button press. Main thread only because it has direct access to UIKit classes
  /// (normally a no no for presenters) looking to refactor later
  func buttonPressed()

  /// Segue to be performed if the user presses Exit (based on the state of the presenter)
  func exitPopupSegue() -> HubPairingSegues?
}

extension HubPairingPresenterProtocol {
  
  var placeId: PlaceModel {
    guard let currentPlace = RxCornea.shared.settings?.currentPlace else {
      return PlaceModel(attributes: [:])
    }
    return currentPlace
  }

  func stopProcess() {
    self.progressTimer?.cancelUpdate()
    self.pairingTimer?.cancelUpdate()
    self.timeoutTimer?.cancelUpdate()
  }
  
  func didGet(errorCode code: PlaceRegisterHubV2Error) {
    
    var vm = HubPairingViewModel()
    if code.errorType == .errorRegisterAlreadyregistered {
      ArcusAnalytics.tag(named: AnalyticsTags.HubPairingFailedAlreadyRegistered)

      vm.navTitle = "HUB ERROR"
      vm.title = Error01Title.replacingOccurrences(of: hubIDPlaceHolder, with: hubId.uppercased())
      vm.errorText = HubErrorCodeTextFormat
        .replacingOccurrences(of: errorPlaceholder, with: "E01")
        .replacingOccurrences(of: hubIDPlaceHolder, with: hubId.uppercased())
    } else if code.errorType == .errorRegisterOrphanedhub {
      ArcusAnalytics.tag(named: AnalyticsTags.HubPairingFailedOrphanHub)

      vm.navTitle = "HUB ERROR"
      vm.hasFactoryResetButton = true
      vm.title = Error02Title.replacingOccurrences(of: hubIDPlaceHolder, with: hubId.uppercased())
      vm.errorText = HubErrorCodeTextFormat
        .replacingOccurrences(of: errorPlaceholder, with: "E02")
        .replacingOccurrences(of: hubIDPlaceHolder, with: hubId.uppercased())
    } else if code.errorType == .errorFwupgradeFailed {
      ArcusAnalytics.tag(named: AnalyticsTags.HubPairingFailedFWUpgrade)
      // Being extra careful here but should be caught by the previous if statement
      applyingUpdateDidFail()
      return
    }
    pairingState = .hubError
    vm.navTitle = HubErrorNavTitle
    vm.buttonTitle = HubErrorButtonTitle
    
    DispatchQueue.main.async {
      self.delegate?.update(viewModel: vm)
      self.delegate?.update(progress: nil)
    }
  }
  
  func pairingDidTimeOut(enabledButton: Bool = false) {
    
    self.progressTimer?.cancelUpdate()
    self.progressTimer = nil
    self.timeoutTimer?.cancelUpdate()
    self.timeoutTimer = nil
    
    self.pairingState = .searchingForHub
    
    var vm = HubPairingViewModel()
    vm.navTitle = SearchingForHubNavTitle
    vm.title = SearchingForHubTitleFormat.replacingOccurrences(of: hubIDPlaceHolder,
                                                               with: self.hubId.uppercased())
    vm.textFieldPrompt = SearchingForHubTextFieldPrompt
    vm.buttonTitle = SearchingForHubButtonTitle
    vm.buttonEnabled = enabledButton
    vm.warningText = TimeoutWarningTextFormat.replacingOccurrences(of: hubIDPlaceHolder,
                                                                   with: hubId.uppercased())
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: Float(HubPairingConfig.maximumPercentage) )
  }
  
  func hubNeedsUpdate() {
    
    self.timeoutTimer?.cancelUpdate()
    self.timeoutTimer = self.newDownloadingTimeoutTimer()
    self.timeoutTimer?.startUpdates()
    self.progressTimer?.cancelUpdate()
    self.progressTimer = nil
    
    self.pairingState = .updateAvailable
    
    var vm = HubPairingViewModel()
    vm.navTitle = UpdateAvailableNavTitle
    vm.title = UpdateAvailableTitle
    vm.subtitle = UpdateAvailableSubtitle
    vm.hasBackButton = false
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: 0.0)
  }
  
  func downloadDidFail() {
    
    // Ensure we stop Updating
    self.pairingTimer?.cancelUpdate()
    self.pairingTimer = nil
    self.timeoutTimer?.cancelUpdate()
    self.timeoutTimer = nil
    self.progressTimer?.cancelUpdate()
    self.progressTimer = nil
    
    self.pairingState = .downloadFailed
    
    var vm = HubPairingViewModel()
    vm.navTitle = DownloadFailedNavTitle
    vm.title = DownloadFailedTitle
    vm.subtitle = DownloadFailedSubtitle
    vm.buttonTitle = DownloadFailedButtonTitle
    vm.hasBackButton = false
    vm.exitPairingDisabled = false
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: nil)
  }
  
  func hubApplyingUpdate() {
    
    self.timeoutTimer?.cancelUpdate()
    self.timeoutTimer = nil
    self.timeoutTimer = self.newApplyTimeoutTimer()
    self.progressTimer?.cancelUpdate()
    self.progressTimer = nil
    self.pairingState = .applyingUpdate
    self.progressTimer = self.newProgressTimer()
    
    var vm = HubPairingViewModel()
    vm.navTitle = ApplyingUpdateNavTitle
    vm.title = ApplyingUpdateTitle
    vm.subtitle = ApplyingUpdateSubtitle
    vm.hasBackButton = false
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: 0.0)
    self.progressTimer?.startUpdates()
    self.timeoutTimer?.startUpdates()
  }
  
  func applyingUpdateDidFail() {
    
    // Ensure we stop Updating
    self.pairingTimer?.cancelUpdate()
    self.pairingTimer = nil
    self.timeoutTimer?.cancelUpdate()
    self.timeoutTimer = nil
    self.progressTimer?.cancelUpdate()
    self.progressTimer = nil
    
    self.pairingState = .installFailed
    
    var vm = HubPairingViewModel()
    vm.navTitle = InstallFailedNavTitle
    vm.errorText = InstallFailedTitle
    vm.title = InstallFailedSubtitle
    vm.buttonTitle = InstallFailedButtonTitle
    vm.hasBackButton = false
    vm.exitPairingDisabled = false
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: nil)
  }
  
  func didFinishPairing() {
    
    self.progressTimer?.cancelUpdate()
    self.pairingTimer?.cancelUpdate()
    
    self.pairingState = .notStarted
    
    self.delegate?.didFinishPairing()
  }
  
  static func corneaSettings() -> (ArcusSettings & RxSwiftSettings)? {
    return RxCornea.shared.settings as? (ArcusSettings & RxSwiftSettings) ?? nil
  }
  
  func observeCurrentHubModel(settings: (ArcusSettings & RxSwiftSettings)?
    = HubPairingPresenter.corneaSettings()) {
    settings?.eventObservable
      .observeOn(MainScheduler.asyncInstance)
      .filter({
        // swiftlint:disable:next force_cast
        return $0 is CurrentHubChangeEvent && ($0 as! CurrentHubChangeEvent).currentHub != nil
      })
      .take(1)
      .subscribe(onNext: { [weak self] _ in
        self?.didFinishPairing()
      })
      .disposed(by: disposeBag)
  }
  
  func newDownloadingTimeoutTimer() -> HubPairingTimer {
    return HubPairingTimer(delegate: self,
                           timeout: HubPairingConfig.downloadTimeout,
                           updateInterval: HubPairingConfig.timeoutPollInterval)
    
  }
  
  func downloadTimeoutPoll(startTime: TimeInterval, currentOrEnd: TimeInterval) {
    let numerator = currentOrEnd - startTime
    let percentage = Double(numerator / HubPairingConfig.downloadTimeout)
    var toPercentage = Double(percentage * 100)
    toPercentage.round()
    let rounded = toPercentage / 100
    if rounded == 1 { // is equal to 1.0 accurate to 2 significant digits
      //timer finished!
      downloadDidFail()
    }
  }
  
  func newPairingTimeoutTimer() -> HubPairingTimer {
    return HubPairingTimer(delegate: self,
                           timeout: HubPairingConfig.pairingTimeout,
                           updateInterval: HubPairingConfig.timeoutPollInterval)
  }
  
  func pairingTimeoutPoll(startTime: TimeInterval, currentOrEnd: TimeInterval) {
    
    let numerator = currentOrEnd - startTime
    let percentage = Double(numerator / HubPairingConfig.pairingTimeout)
    var toPercentage = Double(percentage * 100)
    toPercentage.round()
    let rounded = toPercentage / 100
    if rounded == 1 { // is equal to 1.0 accurate to 2 significant digits
      //timer finished!
      pairingDidTimeOut()
    }
  }
  
  func newApplyTimeoutTimer() -> HubPairingTimer {
    return HubPairingTimer(delegate: self,
                           timeout: HubPairingConfig.applyingTimeout,
                           updateInterval: HubPairingConfig.timeoutPollInterval)
    
  }
  
  func applyTimeoutPoll(startTime: TimeInterval, currentOrEnd: TimeInterval) {
    let numerator = currentOrEnd - startTime
    let percentage = Double(numerator / HubPairingConfig.applyingTimeout)
    var toPercentage = Double(percentage * 100)
    toPercentage.round()
    let rounded = toPercentage / 100
    if rounded == 1 { // is equal to 1.0 accurate to 2 significant digits
      //timer finished!
      applyingUpdateDidFail()
    }
  }
  
  func newProgressTimer() -> HubPairingTimer {
    return HubPairingTimer(delegate: self,
                           timeout: pairingState == .pairingHub ?
                            HubPairingConfig.pairingTimeout : HubPairingConfig.applyingTimeout,
                           updateInterval: HubPairingConfig.progressPollInterval)
    
  }
  
  func progressPoll(startTime: TimeInterval, currentOrEnd: TimeInterval) {
    let numerator = currentOrEnd - startTime
    let timeout = pairingState == .pairingHub ?
      HubPairingConfig.pairingTimeout : HubPairingConfig.applyingTimeout
    
    let percentage = Double(numerator / timeout)
    let displayPercentage = interpolatePercentage(percentage)
    DispatchQueue.main.async {
      self.delegate?.update(progress: Float( displayPercentage ) )
    }
  }
  
  /// Handle the polling request and responses of the server to see state changes from the server
  /// Every second see if we need to make a new request so the limit is to request at some frequency,
  /// greater than 1 Htz. Don't request if the previous request has not completed, for sanity while
  /// debugging.
  ///
  func hubRegisterPoll(startTime: TimeInterval, currentOrEnd: TimeInterval) {
    
    guard requestSending == false else {
      return
    }
    self.requestSending = true
    try? requestPlaceRegisterHubV2(self.placeId, hubId: self.hubId.uppercased())
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] res in
        if let res = res as? PlaceRegisterHubV2Response {
          self?.requestSending = false
          self?.handlePlaceRegisterHubV2Response(res)
        } else if let errorEvent = res as? SessionErrorEvent {
          self?.requestSending = false
          self?.handleError(errAny: errorEvent.error)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// Handle the timing code and differ more logic to common state transtions
  /// This function handles the overall Registration response that happens when a user first pairs
  /// to a hub. The resonse has the full hub model attached to it.
  func handlePlaceRegisterHubV2Response(_ res: PlaceRegisterHubV2Response) {
    let isRegistered = res.getState() == PlaceRegisterHubV2Response.PlaceState.registered
    let progress: Int? = res.getProgress()
    if isRegistered,
      progress == 100,
      let hubModel = res.getHub() {
      delegate?.config[HubPairingNodeKey.HubModelAddress] = hubModel
      //Registered, The Observer of current Hub should wrap things up shortly
      return
    }
    
    guard let state = res.getState(),
      pairingState != .installFailed,
      pairingState != .hubError,
      pairingState != .downloadFailed else {
        return
    }
    
    if state == .downloading {
      let progress = res.getProgress()
      if pairingState != .updateAvailable {
        hubNeedsUpdate()
      }
      if let progress = progress {
        let progressFloat = Float(progress) / 100.0
        DispatchQueue.main.async {
          self.delegate?.update(progress: progressFloat)
        }
      }
    } else if state == .applying,
      pairingState != .applyingUpdate {
      hubApplyingUpdate()
    }
  }
  
  /// Handles errors sent to us from the platform. All Errors are handles by a
  /// common state but this function needs to generate the unique strings for the error based on
  /// the NSError passed to the function. THe NSError is passed as an any because it could
  /// theoretically be some other object and it should fail gracefully. It should Always display
  /// some error though, but should be considered a programming error the object passed is not an
  /// NSError
  func handleError(errAny: Any?) {
    timeoutTimer?.cancelUpdate()
    progressTimer?.cancelUpdate()
    pairingTimer?.cancelUpdate()
    
    if let hubError = errAny as? PlaceRegisterHubV2Error {
      self.didGet(errorCode: hubError)
    } else {
      // Some other connection error occured (Internet was lost, platform is updating etc)
      ArcusAnalytics.tag(named: AnalyticsTags.HubPairingFailedUserError)
      
      if pairingState == .updateAvailable {
        downloadDidFail()
      } else if pairingState == .applyingUpdate {
        applyingUpdateDidFail()
      }
    }
  }
  
  /// The main Button was Pressed
  /// Must be called on the Main Thread. Only the delegate should call this function on a button press.
  /// Main thread only because it has direct access to UIKit classes (normally a no no for presenters)
  func buttonPressed() {
    switch pairingState {
    case .searchingForHub:
      // validate the Hub ID:
      guard let textFieldText = delegate?.textFieldText else { return }
      
      do {
        _ = try validateHubId(textFieldText)
        hubId = textFieldText
        self.startProcess()
      } catch {
        if let error = error as? HubIdValidationError {
          self.delegate?.displayTextErrorMessage(error.errorMessage)
        }
      }
      break
    case .downloadFailed, .installFailed, .hubError:
      // Call Support
      self.delegate?.callSupport()
      break
    default:
      break
    }
  }
  
  func willStartPairing() {
    
    self.progressTimer?.cancelUpdate()
    self.pairingTimer?.cancelUpdate()
    self.timeoutTimer?.cancelUpdate()
    self.pairingState = .pairingHub
    self.progressTimer = self.newProgressTimer()
    self.timeoutTimer = self.newPairingTimeoutTimer()
    self.pairingTimer =
      HubPairingTimer(delegate: self,
                      timeout: HubPairingConfig.pairingTimeout,
                      updateInterval: HubPairingConfig.pairingUpdateInterval)
    self.progressTimer?.startUpdates()
    self.pairingTimer?.startUpdates()
    self.timeoutTimer?.startUpdates()
    
    var vm = HubPairingViewModel()
    vm.navTitle = PairingHubNavTitle
    vm.title = PairingHubTitleFormat.replacingOccurrences(of: hubIDPlaceHolder,
                                                          with: self.hubId.uppercased())
    vm.subtitle = PairingHubSubtitle
    self.delegate?.update(viewModel: vm)
    self.delegate?.update(progress: 0.0)
  }
  
  func interpolatePercentage(_ percentage: Double) -> Double {
    // we skew the pertentage to max out at 90% this function does that smoke and mirror work
    return percentage * HubPairingConfig.maximumPercentage
  }
  
  
  /// HubPairingTimerDelegate
  
  /// Delegate will handle a tic of the timer with this callback
  /// We have a few timers they all must be handled here
  /// Better than blocks because we don't have a retain cycle with weak delegates
  /// I would love to get away from these nested if statements though
  func timeCallback(withTimer timer: HubPairingTimer,
                    startTime: TimeInterval, timePassed: TimeInterval) {
    if pairingTimer === timer {
      hubRegisterPoll(startTime: startTime, currentOrEnd: timePassed)
    } else if progressTimer === timer {
      progressPoll(startTime: startTime, currentOrEnd: timePassed)
    } else if timeoutTimer === timer {
      
      if pairingState == .pairingHub {
        pairingTimeoutPoll(startTime: startTime, currentOrEnd: timePassed)
      } else if pairingState == .applyingUpdate {
        applyTimeoutPoll(startTime: startTime, currentOrEnd: timePassed)
      } else if pairingState == .updateAvailable {
        downloadTimeoutPoll(startTime: startTime, currentOrEnd: timePassed)
      }
    }
  }
}

class HubPairingPresenter: HubPairingPresenterProtocol {

  var disposeBag = DisposeBag()
  /// delegate
  weak var delegate: HubPairingDelegate?
  var hubId: String = ""
  var pairingState: HubPairingState = .notStarted
  var progressTimer: HubPairingTimer?
  var timeoutTimer: HubPairingTimer?
  var pairingTimer: HubPairingTimer?
  var requestSending: Bool = false
  
  init (delegate: HubPairingDelegate) {
    self.delegate = delegate
    if let hubId = delegate.config[HubPairingNodeKey.HubId] as? String {
      self.hubId = hubId
    }
  }

  deinit {
    pairingTimer?.cancelUpdate()
    pairingTimer = nil
    timeoutTimer?.cancelUpdate()
    timeoutTimer = nil
    progressTimer?.cancelUpdate()
    progressTimer = nil
  }

  func exitPopupSegue() -> HubPairingSegues? {
    switch pairingState {
    case .updateAvailable:
      return .downloadInProgressExitPopup
    case .applyingUpdate:
      return .applyInProgressExitPopup
    case  .downloadFailed:
      return .downloadFailedExitPopup
    case .installFailed:
      return .installFailedExitPopup
    default:
      return nil
    }
  }

  /// the delegate can call this function to start the pairing process
  /// Main Thread only function
  func startProcess() {
    willStartPairing()
    observeCurrentHubModel()
  }

}

extension HubPairingPresenter: HubIdValidator {

  /// Extened to call pairingDidTimeOut in a defer block
  func validateHubId(_ incHubId: String?) throws -> Bool {
    var enabled = false
    defer {
      pairingDidTimeOut(enabledButton: enabled)
    }
    guard let incHubId = incHubId else {
      throw HubIdValidationError.invalidFormat
    }
    if incHubId.count == 0 {
      throw HubIdValidationError.empty
    }
    if incHubId.count < 8 {
      throw HubIdValidationError.tooShort
    }
    if incHubId.count > 8 {
      throw HubIdValidationError.tooLong
    }
    let predicate = NSPredicate(format: "SELF MATCHES %@", "(^[a-zA-Z]{3}-[0-9]{4}?$)")
    if !predicate.evaluate(with: incHubId) {
      throw HubIdValidationError.invalidFormat
    }
    enabled = true
    return true
  }

}
