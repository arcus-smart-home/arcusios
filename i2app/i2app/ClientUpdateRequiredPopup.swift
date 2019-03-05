//
//  ClientUpdateRequiredPopup.swift
//  i2app
//
//  Created by Arcus Team on 8/31/18.
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
import RxSwift
import RxCocoa
import Cornea
import StoreKit

/// A Warning Modal that displays that a newer version of the app required to pair a device
/// See "PairingCatalog.storyboard" for the UI of this View Controller
class ClientUpdateRequiredPopup: ArcusPopupViewController,
  SKStoreProductViewControllerDelegate {

  @IBOutlet var updateAppButton: UIButton!

  var disposeBag = DisposeBag()
  var storeProductViewController = SKStoreProductViewController()
  var canPresent = Variable<Bool>(false)
  var shouldPresent = Variable<Bool>(false)

  override func viewDidLoad() {
    super.viewDidLoad()
    storeProductViewController.delegate = self
    bindUpdateAppPressed()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    /* Attempt to load the product VC early. We do this after the view is available to
     present. It is loaded and cached so that the popup loads quickly

     There was 1 second or more network created latency in development
     which is why I am preloading the product info
     */
    storeProductViewController
      .loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: 1043584510],
                   completionBlock: {[ weak self] (status: Bool, error: Error?) -> Void in
                    // Alert on the variable that the VC is ready to load
                    self?.canPresent.value = status
      })
  }

  func bindUpdateAppPressed() {

    updateAppButton.rx.tap.asObservable()
      .throttle(1, latest: false, scheduler: MainScheduler.instance)
      .subscribe( onNext: { [unowned self] _ in
        // Alert on the variable that the user wants the view controller to be presented
        self.shouldPresent.value = true
      })
      .disposed(by: disposeBag)

    Observable.zip(canPresent.asObservable(), shouldPresent.asObservable()) { return $0 && $1 }
      .filter({ return $0 })
      .subscribe(onNext: { [unowned self] _ in
        self.present(self.storeProductViewController, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }

  @IBAction func cancelPressed(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion:nil)
  }

  // MARK: SKStoreProductViewControllerDelegate

  func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    viewController.presentingViewController?.dismiss(animated: true, completion: { [weak self] _ in
      self?.presentingViewController?.dismiss(animated: true, completion:nil)
    })
  }

}
