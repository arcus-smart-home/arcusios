//
//  BLEPairingLoadingPopUpViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/26/18.
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
import RxCocoa

class BLEPairingLoadingPopUpViewController: ArcusPopupViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!

  var loadingTitle: Variable<String> = Variable("Connecting")
  weak var loadingStatus: Variable<String>?

  var disposeBag: DisposeBag = DisposeBag()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    loadingTitle
      .asObservable()
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)

    loadingStatus?
      .asObservable()
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    disposeBag = DisposeBag()
  }
}
