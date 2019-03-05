//
//  WifiNetworkScanNotifier.swift
//  i2app
//
//  Arcus Team on 2/15/18.
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

@objc class WifiNetworkScanNotifier: NSObject {

  private let disposeBag: DisposeBag = DisposeBag()

  func startNotifying() {
    guard let session = RxCornea.shared.session as? RxSwiftSession else { return }

    session.getEvents()
      .filter { (event) -> Bool in
        return event.type == WiFiScanEvents.wiFiScanWiFiScanResults
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: {
        event in
        if let results = event as? SessionMessageEvent {
          var concatenatedResults: [String:AnyObject] = [:]
          concatenatedResults["source"] = event.source as AnyObject
          concatenatedResults["attributes"] = results.attributes as AnyObject
          
          let noteName = NSNotification.Name(kEvtWiFiScanWiFiScanResults)
          NotificationCenter.default.post(name: noteName, object: concatenatedResults)
        }
      })
    .addDisposableTo(disposeBag)
  }

}
