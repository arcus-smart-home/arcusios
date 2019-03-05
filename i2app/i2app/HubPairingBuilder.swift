//
//  HubPairingBuilder.swift
//  i2app
//
//  Created by Arcus Team on 4/2/18.
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

/// Able to share the config as you move through the Hub Pairing Flow
public protocol HubPairingNode: class {
  var config: [String : Any] { get set }
}

/**
 Keys that are valid for use in the config variable of `HubPairingNode`
 */
struct HubPairingNodeKey {
  static let HubId = "kHubIdKey"
  static let HubModelAddress = "kHubModelKey"
}

let kHubPairingYoutubeKey = "videoId"

let kHubPairingYoutubeLink = "5R0_SovOAYc"
let kHubV3PairingYoutubeLink = "5R0_SovOAYc" //TODO: Update when the youtube is available

/// Factory that creates the HubPairing Flow and sets up the config.
public class HubPairingBuilder: NSObject {

  static public func buildHubOrKit() -> UIViewController {
    let vc = UIStoryboard.init(name: "HubPairing", bundle: nil)
      .instantiateViewController(withIdentifier: "HubOrKitSelectionViewController")
    return vc
  }

}
