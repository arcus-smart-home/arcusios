//
//  ArcusModelProvider.swift
//  i2app
//
//  Created by Arcus Team on 6/19/18.
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

/// Observes the Model Cache to keep count of the same model through app launches
/// using the model address as a unique identifier
class ArcusModelProvider<T: ArcusModel> {

  var address: String
  var modelObservable: BehaviorSubject<T?>
  var attributeObservable: PublishSubject<(model: T, changes: [String: AnyObject])>
  var disposeBag = DisposeBag()

  init?(_ model: T?, modelCache: RxArcusModelCache?) {
    guard let incAddress = model?.address,
      let modelCache = modelCache else {
        return nil
    }
    attributeObservable = PublishSubject<(model: T, changes: [String: AnyObject])>()
    address = incAddress
    modelObservable = BehaviorSubject<T?>(value: model)
    modelCache.eventObservable
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: {[weak attributeObservable, weak modelObservable, address] event in
        if let event = event as? ModelUpdatedEvent,
          let model = event.model as? T,
          event.address == address {
          attributeObservable?.onNext((model: model, changes: event.changes))
        } else if let event = event as? ModelDeletedEvent,
          event.address == address {
          modelObservable?.onNext(nil)
        } else if event is ModelCacheFlushedEvent {
          modelObservable?.onNext(nil)
        } else if let event = event as? ModelAddedEvent,
          event.address == address,
          let model = event.model as? T {
          modelObservable?.onNext(model)
        }
      })
      .disposed(by: disposeBag)
  }
}
