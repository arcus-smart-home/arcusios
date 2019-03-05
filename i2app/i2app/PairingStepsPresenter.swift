//
//  PairingStepsPageViewPresenter.swift
//  i2app
//
//  Arcus Team on 2/16/18.
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

protocol PairingStepsDelegate: class {
  /// Invoked to indicate that the place has gone into pairing mode and the platform
  /// has returned pairing instructions for the requested product.
  ///
  /// - viewModel: Data model containing the pairing instructions to be rendered by the view
  func onLoadedPairingSteps(viewModel: PairingStepsViewModel)
  
  /// Invoked to indicate that an error occured while trying to start pairing for the
  /// requested product.
  ///
  /// - reason: A string describing what went wrong
  func onPairingError(_ reason: String)
  
  /// Invoked to indicate the pairing/search process has timed out. Should prompt the user to
  /// to keep searching or bail.
  func onSearchTimeout(_ disposition: CartDisposition)

  /// Invoked to indicate pairing has been completed and user should be transitioned back to
  /// the dashboard or the Z-Wave network rebuild sequence.
  ///
  /// -zwRebuild: When true, user should be presented with ZW rebuild sequence; when false,
  ///             user should be taken to the dashboard.
  func onPairingComplete(zwRebuild: Bool)
  
  /// Invoked to indicate that the user has completed whatever entry (if any) is required
  /// on this screen and they are free to proceed to the next step.
  /// -enable: When true, user can proceed to next screen in sequence
  func onSetProceedEnabled(_ enable: Bool)
  
  /// Invoked to indicate that pairing steps have been completed by user and that the device
  /// searching screen ("bugs bunny") should be displayed.
  /// -formInput:  A key-value pair map of user-entered data required to pair certain cloud-
  ///              to cloud devices. An empty map when no user input is required.
  func onSegueToSearching(formInput: [String:String])
  
  /// Invoked to indicate that the modal cloud-to-cloud connection web view should be
  /// displayed
  ///
  /// -c2cStyle: An indication of the type of cloud-to-cloud connection to perform (i.e,
  ///            Honeywell or Nest
  /// -c2cUrl: The URL that should initially be loaded in the web view to start the
  ///          cloud-to-cloud connection process.
  func onSegueToCloudToCloud(c2cStyle: CloudToCloudStyle, c2cUrl: URL)

  /// Invoked to indicate that a device with custom pairings steps has completed, and should
  /// take custom action in order to initiate pairing.
  func completeCustomPairing()

  /// Pairing was completed by the steps themselves usch as a Voice Assistant, dismiss to Dashboard
  func onCompletedPairing()
}

protocol InputFormDelegate: class {
  /// Determines if this sequence of steps contains a form (for user input).
  func hasForm() -> Bool
  
  /// Determines if the form associated with this sequence of pairing steps has been
  /// sufficiently completed by the user and is ready for submission to the platform.
  /// Will return true only if hasForm() is also true, and the input provided by the
  /// user meets all validation requirements.
  func hasCompletedForm() -> Bool
  
  /// Returns the current user input form (irrespective of validation or completeness);
  /// returns an empty map if this sequence of steps does not specify a form or if the
  /// form has not yet been completed.
  func getCompletedForm() -> [String:String]
}

protocol PairingStepsPresenterProtocol: InputFormDelegate {
  weak var delegate: PairingStepsDelegate? { get set }
  weak var formDelegate: InputFormDelegate? { get set }

  /// Puts the current place in pairing mode, and returns pairing instruction data for
  /// given product.
  ///
  /// - productAddress: The address of the product to be paired
  /// - subsystem: An instance of the PairingSubsystem
  func startPairing(productAddress: String, subsystem: SubsystemModel?)
  
  
  func formWasUpdated()
  
  /// Takes the place out of pairing mode, cancelling any pending search for a preivously-
  /// specified product. Has no effect if the place is not pairing.
  ///
  /// - subsystem: An instance of the PairingSubsystem
  func abortPairing(subsystem: SubsystemModel?)
  
  /// Indicates that the user has pressed "SEARCH" at the final pairing step; segue to the
  /// searching screen.
  func completePairingSteps()
  
  /// Called to indicate that the user has sucessfully completed a cloud-to-cloud (webview)
  /// pairing step and that they should be taken to pairing cart.
  func completeCloudToCloudSetup()  
}

class PairingStepsPresenter: PairingStepsPresenterProtocol, ArcusPairingSubsystemCapability,
ArcusProductCapability, BLEPairingPresenterProtocol {

  var customStepDelegate: PairingStepsCustomStepDelegate { return delegate as! PairingStepsCustomStepDelegate }
  weak var delegate: PairingStepsDelegate?
  weak var formDelegate: InputFormDelegate?
  
  internal let disposeBag = DisposeBag()
  var viewModel: PairingStepsViewModel?
  var timeoutObservable: Disposable?

  func formWasUpdated() {
    if hasForm() {
      delegate?.onSetProceedEnabled(hasCompletedForm())
    } else {
      delegate?.onSetProceedEnabled(true)
    }
  }

  func startPairing(productAddress: String,
                    subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) {
    guard let pairingSubsystem = subsystem else {
      delegate?.onPairingError("Pairing subsystem not available.")
      return
    }

    do {
      try requestPairingSubsystemStartPairing(pairingSubsystem, productAddress: productAddress, mock: false)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak delegate, weak self]
          response in
          if let pairingResponse = response as? PairingSubsystemStartPairingResponse {
            let newViewModel = PairingStepsViewModel(pairingResponse, productAddress: productAddress)
            if self?.viewModel == nil {
              self?.viewModel = newViewModel
              
              // Check if the product is a voice assistant, if so, insert a custom step for step 2
              let isVoice = self?.processVoiceAssistant(productAddress: productAddress) ?? false
              self?.viewModel?.isVoiceAssistant = isVoice
              
              delegate?.onLoadedPairingSteps(viewModel: self?.viewModel ?? newViewModel)
            }
          } else {
            delegate?.onPairingError("Platform rejected request to start pairing.")
          }
        })
        .addDisposableTo(disposeBag)

      // TODO: Listener of pairing timeout errors and invoke delegate method.
      // Events not implemented on the platform as of 2/26/18.

    } catch {
      delegate?.onPairingError("An error occured requesting to start pairing.")
    }

    // Handle Pairing Timeout
    timeoutObservable?.dispose()
    timeoutObservable = pairingSubsystem.eventObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        if let mode = self?.getPairingSubsystemPairingMode(pairingSubsystem),
          mode == PairingSubsystemPairingMode.idle {
          let hasPairingDevices = self?.subsystemHasPairingDevices() ?? false
          self?.delegate?.onSearchTimeout(hasPairingDevices ? .timeoutWithDevices : .timeoutNoDevices)
        }
      })
    timeoutObservable?.disposed(by: disposeBag)
  }
  
  private func subsystemHasPairingDevices() -> Bool {
    let namespace = Constants.pairingDeviceNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [PairingDeviceModel] else {
      return false
    }
    
    return models.count > 0
  }
  
  private func processVoiceAssistant(productAddress: String,
                                     modelCache: ArcusModelCache? = RxCornea.shared.modelCache) -> Bool {
    guard let cache = modelCache,
      let model = cache.fetchModel(productAddress) as? ProductModel,
      let viewModel = viewModel,
      viewModel.steps.count > 0,
      let categories = getProductCategories(model),
      // This could be a constant in the future
      categories.contains("Voice Assistant") else {
        return false
  }

    let productName = getProductShortName(model) ?? ""
    let vendorName = getProductVendor(model) ?? ""
    var appName = ""
    if vendorName == "Google" {
      appName = "Google Home"
    } else {
      appName = "Amazon Alexa"
    }
    let instructionsText = "Connecting Arcus and \(productName) is done through the \(appName) App."

    var customStep = PairingStepsStepViewModel(productAddress: productAddress)

    customStep.instructions = [instructionsText]
    customStep.linkText = "Download \(appName) App"
    customStep.order = viewModel.steps.count + 1

    // Get data needed from the first step
    if let firstStep = viewModel.steps.first as? PairingStepsStepViewModel {
      customStep.id = firstStep.id
      customStep.externalAppUrl = firstStep.externalAppUrl
    }

    customStep.secondaryActionText = "SETUP INSTRUCTIONS"
    if productName.uppercased() == "ALEXA" {
      customStep.secondaryActionURL = NSURL.SupportAlexa
    } else {
      customStep.secondaryActionURL = NSURL.SupportGoogleAsst
    }

    self.viewModel?.steps.append(customStep)
    return true
  }

  /// Dismiss the pairing cart when exiting from the timeout popup
  func dismissAll(subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) {
    timeoutObservable?.dispose()

    guard let pairingSubsystem = subsystem else { return }
    try? requestPairingSubsystemDismissAll(pairingSubsystem)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] event in
        if let response = event as? PairingSubsystemDismissAllResponse {
          self?.delegate?.onPairingComplete(zwRebuild: response.zwRebuildRequested())
          KitDeviceDismissHelper.dismissKittedDevicesIfNeeded()
        }
      })
      .addDisposableTo(disposeBag)
  }

  func abortPairing(subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) {
    if let pairingSubsystem = subsystem {
      do {
        timeoutObservable?.dispose()
        try _ = requestPairingSubsystemStopSearching(pairingSubsystem)
      } catch {
        delegate?.onPairingError("An error occured trying to cancel pairing.")
      }
    }
  }

  func hasForm() -> Bool {
    guard let delegate = self.formDelegate else {
      return false
    }
    
    return delegate.hasForm()
  }
  
  func hasCompletedForm() -> Bool {
    guard let delegate = self.formDelegate else {
      return true
    }
    
    return delegate.hasCompletedForm()
  }
  
  func getCompletedForm() -> [String:String] {
    guard let delegate = self.formDelegate else {
      return [:]
    }
    
    return delegate.getCompletedForm()
  }

  func completeCloudToCloudSetup() {
    delegate?.onSegueToSearching(formInput: self.getCompletedForm())
  }

  func completePairingSteps() {
    if viewModel?.isVoiceAssistant ?? false {
      delegate?.onCompletedPairing()
    } else if viewModel?.isWiFiPairing ?? false {
      delegate?.completeCustomPairing()
    } else if viewModel?.isBLEPairing ?? false {
      delegate?.completeCustomPairing()
    } else if viewModel?.isCloudToCloudConnected() ?? false,
       let c2cStyle = viewModel?.c2cStyle,
       let c2cUrl = viewModel?.c2cUrl {
      
      delegate?.onSegueToCloudToCloud(c2cStyle: c2cStyle, c2cUrl: c2cUrl)
    } else {
      delegate?.onSegueToSearching(formInput: self.getCompletedForm())
    }
  }

  // swiftlint:disable:next line_length
  func finalizeCustomPairing(subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) -> Single<Void> {
    return Single<Void>.create { [unowned self] single in
      guard let subsystem = subsystem else {
        single(.error(ClientError(errorType: .unknown)))
        return Disposables.create()
      }

      // swiftlint:disable:next force_try
      let disposable = try! self.requestPairingSubsystemStopSearching(subsystem)
        .map{ (event) -> Void in
          if let errorEvent = event as? ArcusErrorEvent {
            throw errorEvent.error
          }
          return ()
        }
        .subscribe(
          onNext: { _ in
             single(.success())
        }, onError: { error in
          single(.error(error))
        })

      return Disposables.create {
        disposable.dispose()
      }
    }
  }
}
