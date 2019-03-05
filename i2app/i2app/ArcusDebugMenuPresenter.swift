//
//  ArcusDebugMenuPresenter.swift
//  i2app
//
//  Created by Arcus Team on 12/5/17.
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

fileprivate extension Constants {
  static let kBugfenderAllowed: Bool = false
}

protocol ArcusDebugMenuPresenter {
  weak var delegate: ArcusDebugMenuPresenterDelegate? { get set }
  var debugItems: [ArcusDebugMenuViewModel] { get set }

  func setUp()
  func tearDown()
  func fetch()
}

protocol ArcusDebugMenuPresenterDelegate: class {
  func updateLayout()
}

class DebugMenuPresenter: ArcusDebugMenuPresenter {
  weak var delegate: ArcusDebugMenuPresenterDelegate?
  var debugItems: [ArcusDebugMenuViewModel] = []

  required init(delegate: ArcusDebugMenuPresenterDelegate?) {
    self.delegate = delegate
  }

  deinit {
    tearDown()
  }

  func setUp() {
    fetch()
  }

  func tearDown() {
    debugItems = []
  }

  func fetch() {
    debugItems = debugMenuItems(Constants.kBugfenderAllowed)
    delegate?.updateLayout()
  }

  // MARK: Private Functions
  // MARK: Get DebugItem ViewModels

  private func debugMenuItems(_ bugFenderAllowed: Bool) -> [ArcusDebugMenuViewModel] {
    var items: [ArcusDebugMenuViewModel] = [platformTypeDebugItem()]
    if bugFenderAllowed {
      items += [bugfenderDebugItem()]
    }
    items += [
      versionDebugItem(),
      buildIdDebugItem(),
      hubIdDebugItem(),
      userIdDebugItem(),
      sessionStartDebugItem(),
      deviceCountDebugItem(),
      bleTestItem()
    ]
    return items
  }

  // MARK: Platform Selection Handling

  private func platformTypeDebugItem() -> ArcusDebugMenuViewModel {
    let platformIsDev: Bool = isDev()
    let platformHandeler: DebugSwitchHandler = {
      state in
      self.setPlatform(state)
    }
    let platformTypeVM = DebugMenuViewModel(title: "Dev-Test Platform",
                                            identifier: Constants.kSwitchCell,
                                            switchHandler: platformHandeler,
                                            switchState: platformIsDev)
    return platformTypeVM
  }

  private func isDev() -> Bool {
    guard let session: ArcusSession = RxCornea.shared.session else { return false }
    let isDev: Bool = (session.platform == .devTest)
    return isDev
  }

  private func setPlatform(_ isDev: Bool) {
    guard let session: ArcusSession = RxCornea.shared.session else { return }
    var instance: ArcusPlatformInstance = .prod
    if isDev {
      instance = .devTest
    }
    session.configureSessionUrl(instance, host: nil, port: nil) // Host is only used w/ .other
  }

  // MARK: Bugfender Enable/Disable

  private func bugfenderDebugItem() -> ArcusDebugMenuViewModel {
    let enabled: Bool = bugfenderEnabled()
    let bugfenderVM = DebugMenuViewModel(title: "Bugfender",
                                         identifier: Constants.kSwitchCell,
                                         switchState: enabled)
    return bugfenderVM
  }

  private func bugfenderEnabled() -> Bool {
    guard let isEnabled = Bundle.main.infoDictionary?["BugfenderEnabled"] as? Bool else {
      return false
    }
    return isEnabled
  }

  private func setBugfenderState(_ enabled: Bool) {
    // Not currently implemented.
  }

  // MARK: Version

  private func versionDebugItem() -> ArcusDebugMenuViewModel {
    let version: String = versionNumber()
    let versionVM = DebugMenuViewModel(title: "Version", description: version)
    return versionVM
  }

  private func versionNumber() -> String {
    guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
      return "0.0"
    }
    return version
  }

  // MARK: Build ID

  private func buildIdDebugItem() -> ArcusDebugMenuViewModel {
    let build: String = buildId()
    let buildIdVM = DebugMenuViewModel(title: "Build", description: build)
    return buildIdVM
  }

  private func buildId() -> String {
    let key: String = kCFBundleVersionKey as String
    guard let build = Bundle.main.infoDictionary?[key] as? String else {
      return ""
    }
    return build
  }

  // MARK:  Hub ID

  private func hubIdDebugItem() -> ArcusDebugMenuViewModel {
    let hub: String = hubId()
    let hubIdVM = DebugMenuViewModel(title: "Hub ID", description: hub)
    return hubIdVM
  }

  private func hubId() -> String {
    guard let hubId = RxCornea.shared.settings?.currentHub?.modelId else {
      return ""
    }
    return hubId
  }

  // MARK: User ID

  private func userIdDebugItem() -> ArcusDebugMenuViewModel {
    let user: String = userId()
    let userIdVM = DebugMenuViewModel(title: "User ID", description: user)
    return userIdVM
  }

  private func userId() -> String {
    guard let currentPerson = RxCornea.shared.settings?.currentPerson else {
      return ""
    }
    guard let email = currentPerson.emailAddress else {
      return ""
    }
    return email
  }

  // MARK:  Session Start Time

  private func sessionStartDebugItem() -> ArcusDebugMenuViewModel {
    let sessionStart: String = sessionStartTime()
    let sessionStartVM = DebugMenuViewModel(title: "Session Start", description: sessionStart)
    return sessionStartVM
  }

  private func sessionStartTime() -> String {
    guard let startTime: Date = RxCornea.shared.session?.sessionInfo?.startTime else {
      return ""
    }
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy hh:mm a"
    formatter.amSymbol = "am"
    formatter.pmSymbol = "pm"

    return formatter.string(from: startTime)
  }

  // MARK: Device Count

  private func bleTestItem() -> ArcusDebugMenuViewModel {
    let viewModel = DebugMenuViewModel(title: "BLE Test")

    return viewModel
  }

  private func pairingCartDebugItem() -> ArcusDebugMenuViewModel {
    let viewModel = DebugMenuViewModel(title: "Pairing Cart")
    
    return viewModel
  }

  private func deviceCountDebugItem() -> ArcusDebugMenuViewModel {
    let count: String = deviceCount()
    let deviceCountVM = DebugMenuViewModel(title: "Device Count", description: count)
    return deviceCountVM
  }

  private func deviceCount() -> String {
    let count = DeviceManager.instance().devices.count
    return "\(count)"
  }
}
