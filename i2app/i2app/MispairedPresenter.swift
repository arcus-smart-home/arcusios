//
//  MispairedPresenter.swift
//  i2app
//
//  Arcus Team on 4/20/18.
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

protocol MispairedPresenterProtocol {
  var delegate: MispairedDelegate? { get set }
  
  /// Causes the presenter to "stop presenter", that is, stop notifying the delegate of any
  /// monitored changes
  func stopPresenting()
  
  /// Attempts to remove the mispaired device associated with the given pairing device from
  /// the user's account.
  ///
  /// -mispairedDev: The pairing device associated with the mispaired device
  /// -force: False to attempt a normal device removal; true to perform a force-remove
  func remove(_ mispairedDev: PairingDeviceModel?, force: Bool)
}

protocol MispairedDelegate: class {
  /// Invoked to indicate there are steps that the user must follow in order to remove their
  /// device. Never invoked during a force-removal.
  ///
  /// -steps: A list of removal steps to be followed
  func onShowRemovalSteps(_ steps: [FactoryResetStepModel])
  
  /// Invoked to indicate the requested device was removed from the place.
  func onRemoved()
  
  /// Invoked to indicate the requested device could not be removed.
  ///
  /// -forced: Indicates whether the removal that failed was a force removal.
  func onRemoveFailed(forced: Bool)
  
  /// Invoked to indicate an unexpected error occured.
  ///
  /// -message: A developer note about what went wrong.
  func onError(_ message: String)
}

public class MispairedPresenter: MispairedPresenterProtocol,
                                 ArcusPairingDeviceCapability {

  let removalTimeout = 10.0 * 60.0    // Ten (10!) (diez!) minute (minuto) timeout!!

  var force: Bool = false
  var timer: Timer?
  weak var delegate: MispairedDelegate?
  public var disposeBag: DisposeBag = DisposeBag()
  
  func stopPresenting() {
    self.delegate = nil
  }
  
  func remove(_ mispairedDev: PairingDeviceModel?, force: Bool) {
    self.force = force
    if let mispairedDev = mispairedDev {
    
      if let cache = RxCornea.shared.modelCache as? RxSwiftModelCache {
        cache.eventObservable
          .observeOn(MainScheduler.asyncInstance)
          .subscribe(onNext: { [weak self] event in
            if let deletedEvent = event as? ModelDeletedEvent,
               deletedEvent.address == mispairedDev.address {
      
              self?.succeed()
            }
          })
          .addDisposableTo(disposeBag)
      }

      if force {
        forceRemove(mispairedDev)
      } else {
        remove(mispairedDev)
      }
      
      startTimeoutTimer()
      
    } else {
      self.delegate?.onError("Request to remove a nil device.")
    }
  }

  private func remove(_ mispairedDev: PairingDeviceModel) {
    do {
      try requestPairingDeviceRemove(mispairedDev)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] event in
        if let response = event as? PairingDeviceRemoveResponse {
          self?.delegate?.onShowRemovalSteps(FactoryResetStepModel.fromSteps(response.getSteps()))
        }
      })
      .addDisposableTo(disposeBag)
    } catch {
      self.delegate?.onError("An error occured trying to remove the device.")
    }
  }

  private func forceRemove(_ mispairedDev: PairingDeviceModel) {
    do {
      try _ = requestPairingDeviceForceRemove(mispairedDev)
    } catch {
      self.delegate?.onError("An error occured trying to remove the device.")
    }
  }

  private func startTimeoutTimer() {
    self.timer = Timer.scheduledTimer(timeInterval: removalTimeout,
                                      target: self,
                                      selector: #selector(self.onTimerTimeout),
                                      userInfo: nil,
                                      repeats: false)
  }

  @objc private func onTimerTimeout() {
    self.timer?.invalidate()
    delegate?.onRemoveFailed(forced: self.force)
  }

  private func succeed() {
    self.timer?.invalidate()
    delegate?.onRemoved()
  }
}
