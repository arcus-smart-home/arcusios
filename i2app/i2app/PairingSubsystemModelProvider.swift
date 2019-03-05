//
//  PairingSubsystemModelProvider.swift
//  i2app
//
//  Created by Arcus Team on 6/28/18.
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
import Cornea

/// Observes the Pairing Subsystem and fetches and emmits pair devs on an observer when the
/// pairing subsystem updates from nil to something substantial
class PairingSubsystemModelProvider<T: SubsystemModel> : ArcusModelProvider<T>,
  ArcusPairingSubsystemCapability {

  var cacheLoadedObservable: BehaviorSubject<Void>

  init?(_ model: T?, modelCache: RxArcusModelCache?, cacheLoader: RxArcusModelCacheLoader?) {
    guard let model = model,
      let modelCache = modelCache,
      let cacheLoader = cacheLoader else {
        return nil
    }

    cacheLoadedObservable = BehaviorSubject<Void>(value: ())
    super.init(model, modelCache:modelCache)

    cacheLoader.getStatus()
      .filter({ status in
        return status == .modelsLoaded
      })
      .subscribe( onNext: { [unowned self] _ in
        self.cacheLoadedObservable.onNext(())
      })
      .disposed(by: disposeBag)
  }
}
