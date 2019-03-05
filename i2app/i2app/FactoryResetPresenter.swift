//
//  FactoryResetPresenter.swift
//  i2app
//
//  Arcus Team on 4/19/18.
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

protocol FactoryResetPresenterProtocol {
  var delegate: FactoryResetDelegate? { get }
  
  /// Start the factory reset process; may place the hub in unpairing mode depending on the subsystems
  /// current context (based on the product initially asked to be paired).
  ///
  /// -subsystem: The pairing subsystem to invoke factoryReset() on.
  func factoryReset(_ subsystem: SubsystemModel?)
}

protocol FactoryResetDelegate: class {
  /// Invoked to display a list of factory reset instruction steps.
  ///
  /// -steps: The list of factory reset steps to display
  func onDisplayResetSteps(_ steps: [FactoryResetStepModel])
  
  /// Invoked to indicate an error occured trying to factory reset.
  ///
  /// -reason: A description of what went wrong
  func onFactoryResetError(_ reason: String)
}

class FactoryResetPresenter: FactoryResetPresenterProtocol, ArcusPairingSubsystemCapability {
  var disposeBag: DisposeBag = DisposeBag()
  weak var delegate: FactoryResetDelegate?

  func factoryReset(_ subsystem: SubsystemModel? = SubsystemCache.sharedInstance.pairingSubsystem()) {
    if let subsystem = subsystem {
      do {
        try requestPairingSubsystemFactoryReset(subsystem)
          .observeOn(MainScheduler.asyncInstance)
          .subscribe(onNext: { [weak self] event in
            if let response = event as? PairingSubsystemFactoryResetResponse {
              self?.delegate?.onDisplayResetSteps(FactoryResetStepModel.fromSteps(response.getSteps()))
            }
          })
          .addDisposableTo(disposeBag)
      } catch {
        delegate?.onFactoryResetError("An error occured requesting factory reset.")
      }
    } else {
      delegate?.onFactoryResetError("No pairing subsystem with which to perform factory reset.")
    }
  }
}
