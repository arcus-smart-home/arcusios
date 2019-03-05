//
//  UniversalLinkHandler.swift
//  i2app
//
//  Created by Arcus Team on 10/25/17.
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

import RxSwift
import Cornea

/**
 Enumeration to specify the different Universal Links supported.
 */
enum UniversalLinkFeaturePath {

  /**
   This is the root, by convention, of all universal links supported for iOS as stablished by 
   the platform team.
   */
  private static let command = "/ios/run"

  /**
   Universal Link to open the app to an account that has just been created.
   */
  static let newAccount = UniversalLinkFeaturePath.command + "/new-account-created"
}

/**
 This class handles the mapping of a universal link to a view controller.
 */
class UniversalLinkHandler: ArcusApplicationServiceProtocol {
  var disposeBag: DisposeBag = DisposeBag()
  var isProcessing: Bool = false

  required init(eventPublisher: ArcusApplicationServiceEventPublisher) {
    observeApplicationEvents(eventPublisher)

    guard let session = RxCornea.shared.session as? RxSwiftSession else { return }

    observeSessionState(session)
  }

  func serviceContinueUserActivity(_ event: ArcusApplicationServiceEvent) {
    guard let activity = event.payload as? NSUserActivity,
      let url = activity.webpageURL else {
        return
    }

    // Check for the path to an expected feature.
    if url.path.contains(UniversalLinkFeaturePath.newAccount) {
      if let token = getParameterValue(fromURL: url, withParameterKey: "token") {
        isProcessing = true
        RxCornea.shared.session?.connectWithToken(token)
        CorneaController.suspendCacheLoadRouting(true)
      }
    }
  }

  // MARK: - Session State Observing

  func observeSessionState(_ session: RxSwiftSession) {
    session.getState()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] state in
        guard self?.isProcessing == true else { return }

        guard state == .active else { return }

        ApplicationRoutingService.defaultService.showGetStarted()
        self?.isProcessing = false
      })
    .disposed(by: disposeBag)
  }

  // MARK: - Private Methods

  private func validateUniversalLink(withURLComponents components: [String]) -> Bool {
    guard components.count >= 3,
    components[0] == "/",
    components[1] == "ios",
    components[2] == "run" else {
      return false
    }

    return true
  }

  private func getParameterValue(fromURL url: URL, withParameterKey key: String) -> String? {
    guard let urlComponents = NSURLComponents(string: url.absoluteString),
      let items = urlComponents.queryItems else {
        return nil
    }

    return items.filter({ (item) in item.name == key }).first?.value
  }
}
