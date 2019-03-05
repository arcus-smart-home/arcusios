//
//  ZWRebuildPresenter.swift
//  i2app
//
//  Arcus Team on 4/17/18.
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

protocol ZWRebuildPresenterProtocol {
  weak var delegate: ZWRebuildDelegate? { get set }

  /// Start the Z-Wave network heal process and begin notifying the delegate of status
  /// updates.
  ///
  /// -hub: The HubModel on which the rebuild should be performed.
  func startRebuilding(_ hub: HubModel?)
  
  /// Cancel/stop any ongoing rebuild process.
  ///
  /// -hub: The HubModel on which the rebuild should be performed.
  func cancelRebuilding(_ hub: HubModel?)
  
  /// Begin reporting status updates of a Z-Wave heal currently in progress to the
  /// delegate.
  ///
  /// -hub: The HubModel on which the rebuild should be performed.
  func continueRebuilding(_ hub: HubModel?)
}

protocol ZWRebuildDelegate: class {
  /// Invoked anytime the platform updates the Z-Wave heal percent complete estimation.
  ///
  /// -percentComplete: A value between 0.0 and 1.0 (inclusive) indicating the percent
  ///                   complete for the active Z-Wave heal process.
  func onRebuildProgressUpdate(_ percentComplete: Float)
  
  /// Invoked to indicate the Z-Wave rebuild process has completed successfully.
  func onRebuildSuccessful()
  
  /// Invoked to indicate an error occured while attempting to rebuild the Z-Wave
  /// network.
  ///
  /// -status: A huma-readable message describing the problem.
  func onError(_ status: String)
}

/// A Shared Presenter to handle a few different ZWave Rebuild task
class ZWRebuildPresenter: ZWRebuildPresenterProtocol,
                          ArcusHubZwaveCapability {

  var disposeBag: DisposeBag = DisposeBag()
  var finished: Bool = false
  weak var delegate: ZWRebuildDelegate?

  func startRebuilding(_ hub: HubModel? = RxCornea.shared.settings?.currentHub) {

    if let hubModel = hub {
      let zwModel = HubZwaveModel(attributes: hubModel.get())
      self.finished = false
      
      do {
        try _ = requestHubZwaveHeal(zwModel, block: false, time: Date(milliseconds: 0))
        continueRebuilding()
        if let percent = getHubZwaveHealPercent(zwModel) {
          self.delegate?.onRebuildProgressUpdate(Float(percent))
        }
        
      } catch {
        self.delegate?.onError("An error occured starting Z-Wave heal.")
      }
      
    } else {
      delegate?.onError("No hub associated with this place.")
    }
  }
  
  func cancelRebuilding(_ hub: HubModel? = RxCornea.shared.settings?.currentHub) {
    if let hubModel = hub {
      let zwModel = HubZwaveModel(attributes: hubModel.get())
      do {
        try requestHubZwaveCancelHeal(zwModel)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] event in
          if event is HubZwaveCancelHealResponse {
            self?.finished = true
          }
        })
        .addDisposableTo(disposeBag)
      } catch {
        self.delegate?.onError("An error occured attempting to cancel the Z-wave heal.")
      }
    }
  }
  
  func continueRebuilding(_ hub: HubModel? = RxCornea.shared.settings?.currentHub) {
    if let hubModel = hub {
      hubModel.eventObservable
        .observeOn(MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] event in
          if let updateEvent = event as? ModelUpdateAttributesEvent {
          
            if let percent = updateEvent.changes["hubzwave:healPercent"] as? Double {
              self?.delegate?.onRebuildProgressUpdate(Float(percent))
              self?.reportRebuildComplete()
            }
          }
        })
        .addDisposableTo(disposeBag)
    }
  }
  
  func reportRebuildComplete(_ hub: HubModel? = RxCornea.shared.settings?.currentHub) {
    if let hubModel = hub {
      let zwModel = HubZwaveModel(attributes: hubModel.get())

      if !finished &&
         getHubZwaveHealFinishReason(zwModel) == HubZwaveHealFinishReason.success &&
         getHubZwaveHealInProgress(zwModel) == false {
        
        self.finished = true
        self.delegate?.onRebuildSuccessful()
      }
    }
  }
  
}
