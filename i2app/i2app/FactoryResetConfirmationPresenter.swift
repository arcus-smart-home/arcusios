//
//  FactoryResetConfirmationPresenter.swift
//  i2app
//
//  Arcus Team on 5/8/18.
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

protocol FactoryResetConfirmationPresenterProtocol {
  var delegate: FactoryResetConfirmationDelegate? { get set }
  func startMonitoringForTimeout(_ subsystem: SubsystemModel?)
  func stopMonitoringForTimeout()
}

protocol FactoryResetConfirmationDelegate: class {
  func onPairingTimeout()
}

class FactoryResetConfirmationPresenter: FactoryResetConfirmationPresenterProtocol,
                                         ArcusPairingSubsystemCapability {
  
  weak var delegate: FactoryResetConfirmationDelegate?

  var timeoutObservable: Disposable?
  var disposeBag: DisposeBag = DisposeBag()
  
  func startMonitoringForTimeout(_ subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) {
    if let pairingSubsystem = subsystem {
      self.timeoutObservable = pairingSubsystem.eventObservable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] _ in
          if let mode = self?.getPairingSubsystemPairingMode(pairingSubsystem) {
            if mode == PairingSubsystemPairingMode.idle {
              self?.delegate?.onPairingTimeout()
            }
          }
        })
      timeoutObservable?.addDisposableTo(disposeBag)
    }
  }

  func stopMonitoringForTimeout() {
    timeoutObservable?.dispose()
  }
}
