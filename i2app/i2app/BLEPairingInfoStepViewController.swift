//
//  BLEPairingInfoStepViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/19/18.
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
import RxSwift
import RxSwiftExt
import RxCocoa
import CoreBluetooth

class BLEPairingInfoStepViewController: UIViewController {
  // MARK: - PairingStepsPresenter
  fileprivate var step: ArcusPairingStepViewModel?
  fileprivate var presenter: BLEPairingPresenterProtocol?

  // MARK: - ArcusBLEPairingClient
  var bleClient: ArcusBLEAvailability!
  var disposeBag: DisposeBag = DisposeBag()

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK - Constructor

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: BLEPairingPresenterProtocol) -> BLEPairingInfoStepViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingInfoStepViewController")
      as? BLEPairingInfoStepViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel, let client = step.config as? ArcusBLEAvailability {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }

  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if let presenterDelegate = presenter?.customStepDelegate {
      customStepDelegate = presenterDelegate
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    disposeBag = DisposeBag()
  }
  
  // MARK: UI Configuration

  func configureBindings() {
    guard let delegate = customStepDelegate else { return }

    let isAvailable = bleClient.isBLEAvailable()

    isAvailable
      .bind(to: delegate.pagingEnabled)
      .disposed(by: disposeBag)

    isAvailable
      .filter { available in
        return available == false
      }
      .subscribe(onNext: { _ in
        let segueIdentifier = PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue
        delegate.showPopupWithSegue(segueIdentifier)
      })
      .disposed(by: disposeBag)

    delegate.stepsMovedBackSubject
      .asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] index in
        guard let step = self.step as? CustomPairingStepViewModel, step.order == index else {
          return
        }
        // Reset current state.
        self.disposeBag = DisposeBag()
      })
      .disposed(by: disposeBag)
  }
}

