
//
// HubVolumeCap.swift
//
// Generated on 20/09/18
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

import Foundation
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var hubVolumeNamespace: String = "hubvol"
  public static var hubVolumeName: String = "HubVolume"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubVolumeVolume: String = "hubvol:volume"
  
}

public protocol ArcusHubVolumeCapability: class, RxArcusService {
  /** How loud is the speaker on the hub. */
  func getHubVolumeVolume(_ model: HubModel) -> HubVolumeVolume?
  /** How loud is the speaker on the hub. */
  func setHubVolumeVolume(_ volume: HubVolumeVolume, model: HubModel)

  
}

extension ArcusHubVolumeCapability {
  public func getHubVolumeVolume(_ model: HubModel) -> HubVolumeVolume? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.hubVolumeVolume] as? String,
      let enumAttr: HubVolumeVolume = HubVolumeVolume(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setHubVolumeVolume(_ volume: HubVolumeVolume, model: HubModel) {
    model.set([Attributes.hubVolumeVolume: volume.rawValue as AnyObject])
  }
  
}
