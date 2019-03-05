//
//  PairingCartPresenter.swift
//  i2app
//
//  Arcus Team on 3/7/18.
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
import RxSwiftExt

// No Longer Used but kept for when we move to a Protocol Oriented Presenter for this class
protocol PairingCartPresenterProtocol {

  var delegate: PairingCartDelegate? { get set }

  var pairingSubsystemProvider: ArcusModelProvider<SubsystemModel>? { get set }

  var modelCache: (ArcusModelCache & RxSwiftModelCache)? { get set }

  func search(forProduct: String?, formInput: [String:String])

  func checkForPairedDevices()

  func stopSearching()

  func dismissAll()

  func customize(_ deviceAddress: String)

  func resolve(_ pairDev: PairingDeviceModel)
  
  func abortToDashboard()

  func stopTimeoutUpdates()
}

enum CartDisposition {
  case clean                  // User has paired and customized their devices
  case noDevices              // User is leaving before any devices has pairied
  case uncustomizedDevices    // User has paired but not customized their devices
  case mispairedDevices       // User has mispaired/misconfigured devices in their cart
  case timeoutNoDevices       // Subsystem has idled before devices paired
  case timeoutWithDevices     // Subsystem has idled after devices paired
}

protocol PairingCartDelegate: class {
  
  /// User has requested to return to the dashboard.
  ///
  /// -disposition: Specifies the state of the pairing cart indicating whether the user should
  ///               be prompted to complete customization or device resolution before they
  ///               depart.
  func onSegueToDashboard(_ disposition: CartDisposition)
  
  /// Invoked to indicate the pairing/search process has timed out. Should prompt the user to
  /// to keep searching or bail.
  func onSearchTimeout(_ disposition: CartDisposition)
  
  /// Refresh the pairing cart screen to match the state represented by the given view model.
  ///
  /// -viewModel: A model representing the state and contents of the pairing cart screen.
  func onUpdatePairingCartView(_ viewModel: PairingCartSectionViewModel)
  
  /// Begin customizing the given device (i.e., displaying post-pairing customization steps)
  ///
  /// -device: The device model to being customizing
  func onCustomize(_ device: DeviceModel)
  
  /// Begin resolving issues with a mispaired/misconfigured pairing device model.
  ///
  /// -pairDev: The pairing device model whose errors should be resolved
  func onResolve(_ pairDev: PairingDeviceModel)
  
  /// Invoked to indicate pairing has been completed and user should be transitioned back to
  /// the dashboard or the Z-Wave network rebuild sequence.
  ///
  /// -zwRebuild: When true, user should be presented with ZW rebuild sequence; when false,
  ///             user should be taken to the dashboard.
  func onPairingComplete(zwRebuild: Bool)
  
  /// Invoked to indicate a non-recoverable error occured.
  ///
  /// -reason: A description of the problem
  func onPairingError(_ reason: String)
}

class PairingCartPresenter: ArcusPairingSubsystemCapability,
                            ArcusPairingDeviceCapability,
                            PairingCartViewModelFactory {

  weak var delegate: PairingCartDelegate?
  let disposeBag = DisposeBag()
  private var pairDevs: [PairingDeviceModel] = []
  private var viewModel: PairingCartSectionViewModel?
  private var timeoutObservable: Disposable?
  private var pairedDeviceUpdate = BehaviorSubject<Void>(value: ())

  /// pairing subsystem provider
  var pairingSubsystemProvider: PairingSubsystemModelProvider<SubsystemModel>?
  var modelCache: (ArcusModelCache & RxSwiftModelCache)?

  init?(_ incPairingSubsystemProvider: PairingSubsystemModelProvider<SubsystemModel>?,
        modelCache incModelCache: (ArcusModelCache & RxSwiftModelCache)?) {
    pairingSubsystemProvider = incPairingSubsystemProvider
    modelCache = incModelCache
  }

  /// Start or resume searching for the given product (or for any product when 'forProduct'
  /// is empty or nil. If there are any devices already in the cart, they will be displayed.
  /// Also begins monitoring for changes to the pairing subsystem to alert the user of
  /// timeout conditions.
  ///
  /// -forProduct: The product address of the product to being searching for, or nil, to search
  ///              for all products.
  /// -formInput:  A map of key-value pairs representing user-entered values (from IPCD tutorial
  ///              steps).
  func search(forProduct: String?,
              formInput: [String:String]) {
    // Start searching for requested devices
    self.startSearching(productAddress: forProduct ?? "",
                        formInput: formInput)

    // Update delegate when pairdev models are added, removed or updated
    self.monitorForPairDevChanges()

    // Show troubleshooting tips when subsystem goes idle
    self.monitorForSearchIdleState()

    // Listen for changes to the pairing mode (like timeout)
    self.monitorForPairingMode()
  }

  /// Check to see if there are any devices already in the pairing cart and, if so, displays
  /// them without begining to search or otherwise placing the subsystem in pairing mode.
  /// Does not update the delegate if there are not devices in the cart.
  func checkForPairedDevices() {
    // Display devices already in the cart (no effect if cart is empty)
    fetchAndDisplayPairDevs()

    // Update delegate when pairdev models are added, removed or updated
    monitorForPairDevChanges()
  }

  /// Stop searching for a product and return the pairing subsystem mode to 'idle', but do not
  /// clear any items from the pairing cart.
  func stopSearching() {
    timeoutObservable?.dispose()

    if let ps = try? pairingSubsystemProvider?.modelObservable.value(),
      let pairingSubsystem = ps {
      // swiftlint:disable:next force_try
      _ = try! self.requestPairingSubsystemStopSearching(pairingSubsystem)
        .subscribe(onNext: { _ in
          // Do Nothing
        })
        .disposed(by: disposeBag)
    }
    
  }

/// Stop searching for a product and clear all pairDevs from the pairing cart.
///
/// -subsystem:  (Optional) an instance of the PairingSubsystem; obtains reference from
///              SubsystemCache by default.
  func dismissAll() {
    timeoutObservable?.dispose()
    
    pairingSubsystemProvider?.modelObservable
      .unwrap()
      .flatMap({ [unowned self] pairingSubsystem in
        // swiftlint:disable:next force_try
        return try! self.requestPairingSubsystemDismissAll(pairingSubsystem)
      })
      .take(1)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] event in
        if let response = event as? PairingSubsystemDismissAllResponse {
          self?.process(dismissAllResponse: response)
        }
      })
    .disposed(by: disposeBag)
  }
  
  private func process(dismissAllResponse response: PairingSubsystemDismissAllResponse) {
    delegate?.onPairingComplete(zwRebuild: response.zwRebuildRequested())
    
    KitDeviceDismissHelper.dismissKittedDevicesIfNeeded()
  }

  /// Aborts the pairing/searching process and requests that the user be taken to the dashboard.

  internal func abortToDashboard() {
    delegate?.onSegueToDashboard(getCartDisposition())
  }

  /// Request to start customizing the device with the given address.
  ///
  /// -deviceAddress: The address of the device to start customizing.
  func customize(_ deviceAddress: String) {
    if let device = RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel {
      delegate?.onCustomize(device)
    }
  }

  /// Request to start resolving issues with the given pairing device model
  ///
  /// -pairDev: The pairing device to start resolving
  func resolve(_ pairDev: PairingDeviceModel) {
    stopSearching()
    delegate?.onResolve(pairDev)
  }
  
  private func displaySearching() {
    if self.pairDevs.isEmpty {
      setViewState(searchingForDevicesView())
    }
  }
  
  private func fetchAndDisplayPairDevs() {
    pairingSubsystemProvider?.modelObservable
      .unwrap()
      .take(1)
      .subscribe(onNext: { [weak self] pairingSubsystem in
        self?.handlePairingSubsystemProviderEvent(pairingSubsystem: pairingSubsystem)
      })
    .disposed(by: disposeBag)
  }
  
  private func handlePairingSubsystemProviderEvent(pairingSubsystem: SubsystemModel) {    
    let devs = pairingDeviceModels() ?? []
    pairDevs = devs
      .filter { !isPairedDeviceInKitAndPairing($0) }
    
    // Don't display devices if there aren't any in the cart yet (unless pairing mode is idle)
    if !(pairDevs.isEmpty) ||
      getPairingSubsystemPairingMode(pairingSubsystem) == PairingSubsystemPairingMode.idle {
      displayPairingDevices(pairDevs, subsystem: pairingSubsystem)
    }
  }
  
  private func pairingDeviceModels() -> [PairingDeviceModel]? {
    let namespace = Constants.pairingDeviceNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [PairingDeviceModel] else {
      return nil
    }
    
    return models
  }
  
  private func isPairedDeviceInKitAndPairing(_ pairedDevice: PairingDeviceModel) -> Bool {
    guard let pairingState = getPairingDevicePairingState(pairedDevice) else {
      return false
    }
    
    // If the pair device contains the "KIT" tag, then it can be filtered out of this count.
    if let tags = pairedDevice.getTags() as? [String] {
      for tag in tags where tag.uppercased() == "KIT" {
        if pairingState == .pairing {
          return true
        }
      }
    }
    
    return false
  }
  
  private func getCartDisposition() -> CartDisposition {
    // Nothing has been paired
    if pairDevs.isEmpty {
      return .noDevices
    }

    // One or more mispaired devices in the cart
    for thisPairDev in pairDevs {
      if let state = getPairingDevicePairingState(thisPairDev),
         state == .mispaired || state == .misconfigured {
        return .mispairedDevices
      }
    }
    
    // One or more devices haven't been configured yet
    for thisPairDev in pairDevs {
      if !isDeviceCustomized(thisPairDev) {
        return .uncustomizedDevices
      }
    }
    
    // One or more devices paired cleanly and configured
    return .clean
  }

  private func isDeviceCustomized(_ pairDev: PairingDeviceModel) -> Bool {
    return (getPairingDeviceCustomizations(pairDev) ?? [])
      .contains(PairingCustomizationStepType.complete.rawValue)
  }

  /// stops the timeout observer when the back button is presseed

  func stopTimeoutUpdates() {
    timeoutObservable?.dispose()
    timeoutObservable = nil
  }

  private func displayPairingDevices(_ pairDevs: [PairingDeviceModel], subsystem: SubsystemModel) {
      let mode = self.getPairingSubsystemPairingMode(subsystem)
      let stillSearching = mode != PairingSubsystemPairingMode.idle
      self.setViewState(self.devicesFoundSearching(pairDevs: pairDevs,
                                                   stillSearching: stillSearching))
  }
  
  private func displayTroubleshootingTips(_ subsystem: SubsystemModel) {
    if self.pairDevs.isEmpty {
      // swiftlint:disable:next force_try
      try! requestPairingSubsystemListHelpSteps(subsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] event in
          if let stepsResponse = event as? PairingSubsystemListHelpStepsResponse,
            let stepsData = stepsResponse.getSteps() {
            let steps = HelpStepViewModel.fromHelpSteps(stepsData)
            // swiftlint:disable:next line_length
            self?.setViewState(self?.troubleshootingTipsView(withSteps: steps) ?? PairingCartSectionViewModel([]))
          }
        })
        .addDisposableTo(disposeBag)
    }
  }

  private func displayError(_ error: String) {
    delegate?.onPairingError(error)
  }

  private func monitorForPairingMode() {

    timeoutObservable?.dispose()
    timeoutObservable = pairingSubsystemProvider?.attributeObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] (subsystem, _) in
        guard let mode = self?.getPairingSubsystemPairingMode(subsystem),
          let currentPairDevs = self?.pairDevs else {
            return
        }
        self?.setHomeAnimationVisible(mode != PairingSubsystemPairingMode.idle)
        if mode == PairingSubsystemPairingMode.idle {
          self?.delegate?.onSearchTimeout(currentPairDevs.isEmpty ? .timeoutNoDevices : .timeoutWithDevices)
        }
      })
    timeoutObservable?.addDisposableTo(disposeBag)
  }
  
  private func monitorForSearchIdleState() {
    pairingSubsystemProvider?.attributeObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] (pairingSubsystem, _) in
        guard let strongSelf = self,
          strongSelf.delegate != nil,
          let searchIdle = strongSelf.getPairingSubsystemSearchIdle(pairingSubsystem),
          searchIdle == true else {
            return
        }
        strongSelf.displayTroubleshootingTips(pairingSubsystem)
      })
      .addDisposableTo(disposeBag)

    pairingSubsystemProvider?.modelObservable
      .observeOn(MainScheduler.asyncInstance)
      .unwrap()
      .subscribe(onNext: { [weak self] (pairingSubsystem) in
        guard let strongSelf = self,
          strongSelf.delegate != nil,
          let searchIdle = strongSelf.getPairingSubsystemSearchIdle(pairingSubsystem),
          searchIdle == true else {
            return
        }
        strongSelf.displayTroubleshootingTips(pairingSubsystem)
      })
      .addDisposableTo(disposeBag)
  }

  private func monitorForPairDevChanges() {

    guard let modelCache = modelCache else { return }

    pairingSubsystemProvider?.cacheLoadedObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let strongSelf = self,
          strongSelf.delegate != nil,
          let ps = try? strongSelf.pairingSubsystemProvider?.modelObservable.value(),
          let pairingSubsystem = ps else {
            DDLogError("Fatal Error, Cache Loaded but we have no pairing Subsystem")
            return
        }
        strongSelf.pairDevs = strongSelf.mergedPairingDevices(pairingSubsystem, modelCache)
        strongSelf.pairedDeviceUpdate.onNext(())
      })
    .disposed(by: disposeBag)

    pairingSubsystemProvider?.attributeObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] (pairingSubsystem, _) in
        guard let strongSelf = self,
          strongSelf.delegate != nil else {
          return
        }
        strongSelf.pairDevs = strongSelf.mergedPairingDevices(pairingSubsystem, modelCache)
        strongSelf.pairedDeviceUpdate.onNext(())
      })
      .disposed(by: disposeBag)

    modelCache.eventObservable
      .filter({  [weak self] (event) -> Bool in
        guard let recognizedPairDevs = self?.pairingDeviceModels() else {
          return false
        }
        
        for pairDev in recognizedPairDevs {
          if pairDev.address == event.address {
            return true
          }
        }
        
        return false
      })
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let strongSelf = self,
          strongSelf.delegate != nil,
          let model = try? self?.pairingSubsystemProvider?.modelObservable.value(),
          let pairingSubsystem = model else {
          return
        }
        strongSelf.pairDevs = strongSelf.mergedPairingDevices(pairingSubsystem, modelCache)
        strongSelf.pairedDeviceUpdate.onNext(())
      })
      .disposed(by: disposeBag)

     pairedDeviceUpdate.asObserver()
      .debounce(0.2, scheduler: ConcurrentDispatchQueueScheduler(qos: .utility))
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let strongSelf = self,
          strongSelf.delegate != nil,
          let model = try? self?.pairingSubsystemProvider?.modelObservable.value(),
          let pairingSubsystem = model,
          strongSelf.pairDevs.count > 0 ||
          strongSelf.getPairingSubsystemPairingMode(pairingSubsystem) == PairingSubsystemPairingMode.idle
          else {
            return
        }
        strongSelf.displayPairingDevices(strongSelf.pairDevs, subsystem: pairingSubsystem)
      })
    .disposed(by: disposeBag)
  }

  private func mergedPairingDevices(_ pairingSubsystem: SubsystemModel,
                                    _ modelCache: (ArcusModelCache & RxSwiftModelCache))
    -> [PairingDeviceModel] {

      return (pairingDeviceModels() ?? [])
        .filter { !self.isPairedDeviceInKitAndPairing($0) }
  }

  private func startSearching(productAddress: String,
                              formInput: [String:String]) {
    pairingSubsystemProvider?.modelObservable
      .unwrap()
      .flatMap({ [unowned self] pairingSubsystem in
        // swiftlint:disable:next force_try
        return try! self.requestPairingSubsystemSearch(pairingSubsystem,
                                                       productAddress: productAddress,
                                                       form: formInput)
      })
      .take(1)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] response in
        if response is PairingSubsystemSearchResponse {
          // Check to see (and display) any pairdevs already in the cart
          self?.fetchAndDisplayPairDevs()
          self?.displaySearching()
        } else {
          self?.displayError("Platform rejected request to search.")
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  private func setViewState(_ model: PairingCartSectionViewModel) {
    self.viewModel = model
    delegate?.onUpdatePairingCartView(model)
  }
  
  private func setHomeAnimationVisible(_ visible: Bool) {
    if !visible && isHomeAnimationVisible() {
      viewModel?.sections.remove(at: 0)
      if let updated = viewModel {
        self.delegate?.onUpdatePairingCartView(updated)
      }
    } else if visible && !isHomeAnimationVisible() {
      viewModel?.sections.insert(HomeAnimationSectionModel(), at: 0)
      if let updated = viewModel {
        self.delegate?.onUpdatePairingCartView(updated)
      }
    }
  }
  
  private func isHomeAnimationVisible() -> Bool {
    if let sections = self.viewModel?.sections {
      return sections.count > 0 && sections[0] is HomeAnimationSectionModel
    } else {
      return false
    }
  }
}

extension PairingSubsystemDismissAllResponse {
  func zwRebuildRequested() -> Bool {
    for thisActionData in getActions() ?? [] {
      if let thisAction = thisActionData as? [String:Any?],
         let thisActionString = thisAction["action"] as? String,
         thisActionString == "ZWAVE_REBUILD" {
        return true
      }
    }
    
    return false
  }
}
