//
//  ExternalCommunications.swift
//  Cornea
//
//  Created by Arcus Team on 3/15/18.
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

/// Interface that interacts like SubsystemsController
public protocol SubsystemsControllerInterface {
  func clearCurrentUserStates()
  func retrieveSubsystems(forPlaceId: String)
  func addOrUpdateSubsystem(with: SubsystemModel, andSource: String)
}

/// Interface that interacts like AccountController
public protocol AccountControllerInterface {
  func sendDeviceInfo(_ person: PersonModel, deviceToken: String?)
}

/// Interface that interacts like CorneaController
public protocol CorneaControllerInterface {
  func suspendCacheLoadRouting()
}

/// Helper protocol that combines the three above. as we refactor the code we can remove parts of this
/// protocol as implementation is handled better in Cornea instead of i2App, or removed from Cornea
/// and only in i2App
public protocol ArcusLegacyLogic: SubsystemsControllerInterface, AccountControllerInterface,
CorneaControllerInterface { }
